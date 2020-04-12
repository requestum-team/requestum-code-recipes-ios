## Continuous Deployment

### Project

1. Only one target
2. Add Config folder with Development.xcconfig, Staging.xcconfig, Production.xcconfig (files are not Target Membership)

```
//
//  Development.xcconfig
//
//
//  Created by Requestum.
//  Copyright © 2019 Requestum. All rights reserved.
//

// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

#include "Pods/Target Support Files/Pods-App/Pods-App.development-debug.xcconfig"
#include "Pods/Target Support Files/Pods-App/Pods-App.development-release.xcconfig"

SERVER_ENVIRONMENT = development

CUSTOM_PRODUCT_BUNDLE_IDENTIFIER = com.app.id
MARKETING_VERSION = 1.0
CURRENT_PROJECT_VERSION = 1

APP_NAME = App
```

3. Create Configurations by duplicating Debug and Release configurations in the project like `Production-Debug`, `Staging-Release`. Set corresponding xcconfig files to each configuration

4. Set Info.plist as 

Bundle identifier - `$(CUSTOM_PRODUCT_BUNDLE_IDENTIFIER)`<br>
Bundle versions string, short - `$(MARKETING_VERSION)`<br>
Bundle version - `$(CURRENT_PROJECT_VERSION)`<br>
Bundle name - `$(APP_NAME)` (in General tab make empty)<br>
ServerEnvironment - `$(SERVER_ENVIRONMENT)`<br>

5. In Target Build Settings for `Product Bundle Identifier` set `${CUSTOM_PRODUCT_BUNDLE_IDENTIFIER}`. It will set bundle ids (from .xcconfig files) to each configuration. After this in General tab the Bundle identifier will be shown like <Multiple values> and in tab Signing & Capabilities will be multiple items (per each bundle id) or just one if bundle id is the same for all configurations.

6. (If needed) Google plist run script before compile (plist files should not be included in target) `<APP_FOLDER>` заменить на правильное

```
PATH_TO_GOOGLE_PLISTS="${PROJECT_DIR}/<APP_FOLDER>/Resources/Google"

case "${CONFIGURATION}" in

"Staging-Debug" | "Staging-Release" )
cp -r "$PATH_TO_GOOGLE_PLISTS/GoogleService-Info-staging.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;

"Production-Debug" | "Production-Release" )
cp -r "$PATH_TO_GOOGLE_PLISTS/GoogleService-Info-production.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist" ;;

*)
;;
esac
```

7. Create Shared schemes

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

8. ServerAPI should handle diffrent envs

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
            return "https://"
        case .staging:
            return "https://"
        case .production:
            return "https://"
        }
    }
```

9. Set `Product Name` in Build Settings to `$(TARGET_NAME)` as it was by default (after above actions it could be set to empty and app will fail to build). Also it can be changed to env specific app name

9. Run each scheme (which means each configuration) on the simulator (or device) to make sure they work and in case of different bundle ids - different applications. 

##Fastlane

1. Init fastlane in project
2. Appfile

```
apple_id "<email>"
team_id "<team_id>"
itc_team_id "<itc_team_id>"
```

Fastfile

```
workspace = "App.xcworkspace"

scheme_dev = "AppDevelopment"
scheme_staging = "AppStaging"
scheme_prod = "AppProduction"

prov_profile_dev_adhoc = "com.app.dev AdHoc"
prov_profile_staging_adhoc = "com.app.staging AdHoc"
prov_profile_prod_adhoc = "com.app.prod AdHoc"

prov_profile_dev_appstore = "com.app.dev AppStore"
prov_profile_staging_appstore = "com.app.staging AppStore"
prov_profile_prod_appstore = "com.app.prod AppStore"

app_id_dev = "com.app.dev"
app_id_staging = "com.app.staging"
app_id_prod = "com.app.prod"

slack_url = ""

firebase_app_id_dev = ""
firebase_app_id_staging = ""
firebase_app_id_prod = ""


default_platform(:ios)

platform :ios do

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

    firebase_app_distribution(
      app: options[:firebase_app_id],
      groups: "qa"
    )

    slack(
      message: "New build is available on Firebase App Distribution",
      slack_url: slack_url,
      default_payloads: [:lane, :git_branch]
    )

  end

  lane :distribute_appstore do |options| 

    get_certificates(
      development: false,
    )

    get_provisioning_profile(
      adhoc: false,
      app_identifier: options[:app_id]
    )

    build_app(
      workspace: workspace,
      scheme: options[:scheme],
      clean: true,
      silent: true,
      export_options: {
        method: "app-store",
        provisioningProfiles: { 
          options[:app_id] => options[:provisioning_profile],
        }
      },
      output_directory: "build"
    )

    upload_to_testflight(
      skip_submission: true, 
      skip_waiting_for_build_processing: true
    )

  end

  lane :build do |options|

    case options[:env] 
    when "dev"
      distribute_adhoc(app_id: app_id_dev, provisioning_profile: prov_profile_dev_adhoc, scheme: scheme_dev, firebase_app_id: firebase_app_id_dev)
    when "staging"
      distribute_adhoc(app_id: app_id_staging, provisioning_profile: prov_profile_staging_adhoc, scheme: scheme_staging, firebase_app_id: firebase_app_id_staging)
    when "prod"
      distribute_adhoc(app_id: app_id_prod, provisioning_profile: prov_profile_prod_adhoc, scheme: scheme_prod, firebase_app_id: firebase_app_id_prod)
    end

  end

lane :deploy do |options|

    case options[:env] 
    when "dev"
      distribute_appstore(app_id: app_id_dev, provisioning_profile: prov_profile_dev_appstore, scheme: scheme_dev)
    when "staging"
      distribute_appstore(app_id: app_id_staging, provisioning_profile: prov_profile_staging_appstore, scheme: scheme_staging)
    when "prod"
      distribute_appstore(app_id: app_id_prod, provisioning_profile: prov_profile_prod_appstore, scheme: scheme_prod)
    end

  end

end
```

3. To install Firebase App Distribution plugin run `bundle exec fastlane add_plugin firebase_app_distribution` (Note: v0.1.4 was broken, so used 0.1.3)

3. Use like `bundle exec fastlane deploy env:dev`, `bundle exec fastlane build env:prod` and so on
