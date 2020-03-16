## Init Project

1. Create a new project in Xcode <br>

	```
	Template: Single View App
	Product Name: Name of the app starts from capital letter without spaces. 	Example: HelloWorld
	Team: Alex Djimiev
	Organization Name: Requestum
	Organization Identifier: com.requestum
	Language: Swift
	Leave checkboxes empty for Use Core Data, Include Unit Tests, Include UI 	Tests
	```
It is preferred to set production client's organization and bundle id initially. If not, it will be needed to move later.

2. A project should be inside the repository root folder without extra folders

	```
	repository-folder/HelloWorld.xcodeproj - correct
	repository-folder/HelloWorld/HelloWorld.xcodeproj - wrong
	```

3. Remove created by `default ViewController`

4. Mark scheme as `Shared` in `Manage Schemes`

5. Set minimum iOS target to the previous major version (if iOS 12 is the latest, then iOS 11.0)

6. Add `.gitignore` file in the root folder, use https://github.com/github/gitignore to find appropriate files for the used programming language and computer OS (combine in one file [iOS.gitignore](./iOS.gitignore))

7. Add `Cocoapods`, libraries included by default for a client-server [Podfile](./Podfile). `Pods folder should be included in .gitignore` 

8. Add `SwiftLint` [Codestyle](../Codestyle)

9. Add `R.swift` https://github.com/mac-cain13/R.swift

10. Add `Crashlytics` in Firebase (use client's project from the start)

11. Use basic init project example for reference of what classes and structure to use [init-project-ios](./init-project-ios) (can be outdated)

12. `Run` app, make sure everything is ok

13. Setup `Fastlane` [Fastlane](../CD)