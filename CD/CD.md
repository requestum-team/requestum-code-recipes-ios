#Continuous Deployment

##Project

1. Only one target
2. Add Config folder with Development.xcconfig, Staging.xcconfig, Production.xcconfig (files are not Target Membership)

```
//
//  Development.xcconfig
//
//
//  Created by Alex Kovalov.
//  Copyright © 2019 Requestum. All rights reserved.
//

// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

#include "Pods/Target Support Files/Pods-Increase/Pods-TownApp.development-debug.xcconfig"
#include "Pods/Target Support Files/Pods-Increase/Pods-TownApp.development-release.xcconfig"

SERVER_ENVIRONMENT = development

PRODUCT_BUNDLE_IDENTIFIER = com.town.app.beta

APP_NAME = TownDevelopment
APP_VERSION = 1.0
APP_BUILD_NUMBER = 51

```

3. Create Configurations by duplicating Debug and Release configurations in the project like `Production-Debug`, `Staging-Release`. Set corresponding xcconfig files to each configuration
4. Set Info.plist as 

Bundle Id - `$(PRODUCT_BUNDLE_IDENTIFIER)`<br>
(and in General tab of project settings leave empty)<br>
App version - `$(APP_VERSION)`<br>
Build number - `$(APP_BUILD_NUMBER)`<br>
Bundle Name - `$(APP_NAME)`<br>
ServerEnvironment - `$(SERVER_ENVIRONMENT)`<br>

5. Google plist run script before compile (plist files should not be included in target) `<APP_FOLDER>` заменить на правильное

```
PATH_TO_GOOGLE_PLISTS="${PROJECT_DIR}/<APP_FOLDER>/Resources/Google"

case "${CONFIGURATION}" in

"Development-Debug" | "Development-Release" )
cp -r "$PATH_TO_GOOGLE_PLISTS/GoogleService-Info-development.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;

"Staging-Debug" | "Staging-Release" )
cp -r "$PATH_TO_GOOGLE_PLISTS/GoogleService-Info-staging.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;

"Production-Debug" | "Production-Release" )
cp -r "$PATH_TO_GOOGLE_PLISTS/GoogleService-Info-production.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;

*)
;;
esac
```

6. Create Shared schemes

<APP_NAME>Development<br>
<APP_NAME>Staging<br>
<APP_NAME>Production<br>

For each scheme set corresponding configuration file in each build variants.
For example

```
Run -> Development-Debug
Test -> Developmnet-Debug
Profile -> Development-Release
Analyze -> Development-Debug
Archive -> Development-Release
```

7. ServerAPI should handle diffrent envs

```
	enum Environment: String {
        
        case development
        case staging
        case production
    }
    
    static var environment: Environment {
        
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ServerEnvironment") as? String else {
            return .production
        }
        return Environment(rawValue: value) ?? .production
    }
    
    static var baseUrl: String {
        
        switch ServerAPI.environment {
        case .development:
            return "https://increase.requestumdemo.com/"
        case .staging:
            return "https://api.staging.increase.global/"
        case .production:
            return "https://api.increase.global/"
        }
    }
```


##Fastlane

1. Init fastlane in project
2. Appfile

```
apple_id("alex.kovalov@requestum.com")
team_id("2RDN27XWZH")
```

Fastfile

```
workspace = "TownApp.xcworkspace"

scheme_dev = "TownAppDevelopment"
scheme_staging = "TownAppStaging"
scheme_prod = "TownAppProduction"

provisioning_profile_dev = "com.town.app.beta AdHoc"
provisioning_profile_staging = "com.town.app.beta AdHoc"
provisioning_profile_prod = "com.town.app AdHoc"

app_id_dev = "com.town.app.beta"
app_id_staging = "com.town.app.beta"
app_id_prod = "com.town.app"

crashlytics_api_token = "d66e6c7725accf55413336b52b55d88363d05144"
crashlytics_build_secret = "716cec6bfb758c1e040ac9eec183c418ecb286d14193f1c4f4b9d79a07316afe"
crashlytics_groups = "rq"

slack_url = "https://hooks.slack.com/services/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"


default_platform(:ios)

platform :ios do

  desc "Build app and upload internally"
  lane :distribute_adhoc do |options| 

    get_certificates(
      development: false,
    )

    get_provisioning_profile(
      adhoc: true,
      app_identifier: options[:app_id]
    )

    build_app(
      workspace: workspace,
      scheme: options[:scheme],
      clean: true,
      silent: true,
      export_options: {
      method: "ad-hoc",
        provisioningProfiles: { 
          options[:app_id] => options[:provisioning_profile],
        }
      },
      output_directory: "build"
    )

    crashlytics(
      api_token: crashlytics_api_token, 
      build_secret: crashlytics_build_secret,
      groups: crashlytics_groups
    )

    slack(
      message: "New build is available on Crashlytics",
      slack_url: slack_url,
      default_payloads: [:lane, :git_branch]
    )

  end

  lane :dev do
    
    distribute_adhoc(app_id: app_id_dev, provisioning_profile: provisioning_profile_dev, scheme: scheme_dev)

  end

  lane :staging do

    distribute_adhoc(app_id: app_id_staging, provisioning_profile: provisioning_profile_staging, scheme: scheme_staging)

  end

  lane :prod do
    
    distribute_adhoc(app_id: app_id_prod, provisioning_profile: provisioning_profile_prod, scheme: scheme_prod)

  end

end
```

3. Run `fastlane staging` or other lane name




