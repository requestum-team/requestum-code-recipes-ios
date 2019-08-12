## Continuous Deployment

### Project

// TODO: write project specific settings to work with development / staging / production servers (flavours, server base urls, google json files etc)

### Fastlane

1. Init fastlane in project
2. Appfile

```
json_key_file("")

package_name("com.app.app")
```

Fastfile

```
gradle_task = "assemble"
build_type = "Release"

flavor_dev = "demoServer"
flavor_staging = "stagingServer"
flavor_prod = "prodServer"

crashlytics_api_token = ""
crashlytics_build_secret = ""
crashlytics_groups = "rq"

slack_url = ""


default_platform(:android)

platform :android do

  desc "Build app and upload internally"
  lane :distribute_test do |options| 

    gradle(task: gradle_task, flavor: options[:flavor], build_type: build_type)

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
    
    distribute_test(flavor: flavor_dev)

  end

  lane :staging do

    distribute_test(flavor: flavor_staging)

  end

  lane :prod do
    
    distribute_test(flavor: flavor_prod)

  end

end
```

3. Run `fastlane staging` or other lane name
