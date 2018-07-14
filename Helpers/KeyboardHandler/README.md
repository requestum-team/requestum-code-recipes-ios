
##### NOTE: IQKeyboardManagerSwift is preferred and should be used across all projects. Use KeyboardEventsHandler only when it is really needed and you know what you are doing.

### KeyboardEventsHandler 

 Autoresize view for text input

### Example:

 - Add bottom constraint to main view
 - Init KeyboardEventsHandler with constraint & view
 - Done. 

```swift
...
 
 @IBOutlet var bottomConstraint: NSLayoutConstraint!
 fileprivate var keyboardHandler: KeyboardEventsHandler?

...

  override func viewDidLoad() {
        super.viewDidLoad()
    
        keyboardHandler = KeyboardEventsHandler(  constraint: bottomConstraint,  forView: self.view)
  }

```

