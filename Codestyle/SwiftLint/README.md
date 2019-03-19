
###  SwilftLint
[SwilftLint](https://github.com/realm/SwiftLint) source repo  
<br>


### Using [CocoaPods](https://cocoapods.org):

Simply add the following line to your Podfile:

```ruby
pod 'SwiftLint'
```

This will download the SwiftLint binaries and dependencies in `Pods/` during your next
`pod install` execution and will allow you to invoke it via `${PODS_ROOT}/SwiftLint/swiftlint`
in your Script Build Phases.


Copy  `.swiftlint.yml ` to project folder


Change {project_name} in .swiftlint.yml

```
included: 
  - {project_name}
excluded: 
  - Carthage
  - Pods
  - {project_name}/Resources
```

### Done


