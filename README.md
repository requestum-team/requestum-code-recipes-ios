# requestum-code-recipes-ios

### Application
[App](Application/App.swift) - Setup third party services and common app stuff
<br>

### Extensions

#### Foundation

[FileManager+Ext](Extensions/Foundation/FileManager+Ext.swift) - folders
<br>
[String+Validation](Extensions/Foundation/String+Validation.swift) - email regex, spaces
<br>

#### UIKit
[UIApplication+Bundle](Extensions/UIKit/UIApplication+Bundle.swift) - keys from Info.plist
<br>
[UIApplication+TopViewController](Extensions/UIKit/UIApplication+TopViewController.swift) - top vc
<br>
[UINavigationController+Orientation](Extensions/UIKit/UINavigationController+Orientation.swift) - orientation
<br>
[UITableView+Ext](Extensions/UIKit/UITableView+Ext.swift) - generics for cell
<br>
[UIView+Inspectable](Extensions/UIKit/UIView+Inspectable.swift) - to use in Storyboard
<br>
[UIView+Render](Extensions/UIKit/UIView+Render.swift) - UIView to image
<br>

### Helpers
[DataSource](Helpers/DataSource.swift) - save to UserDefaults simple types and mappable via ObjectMapper
<br>
[AlertsManager](Helpers/AlertsManager.swift) - show alerts
<br>
[HUD](Helpers/HUD.swift) - JGProgressHUD helper
<br>
[XibBasedView](Helpers/XibBasedView.swift) - for view with .xib
<br>

### Managers

[DatabaseManager](Managers/DatabaseManager.swift) - Realm database
<br>
[DatabaseManager+Schema](Managers/DatabaseManager+Schema.swift) - migration
<br>
[RemoteNotificationManager](Managers/RemoteNotificationManager.swift) - Push notifications
<br>
[RemoteNotificationsManager+Push](Managers/RemoteNotificationsManager+Push.swift) - to implement actions on app specific push notifications
<br>
[RateManager](Managers/RateManager.swift) - rate the app
<br>

### API
[DataResponse+Result](Extensions/Network/DataResponse+Result.swift) - Alamofire helpers for API
<br>
[NSError+Response](Extensions/Network/NSError+Response.swift) - NSError helpers for API
<br>
[ServerConstants](Managers/Server/ServerConstants.swift) - API endpoints, OAuth credentials and other constants needed for API requests
<br>
[ObjectManager](Managers/Server/ObjectManager.swift) - base manager for handling API requests
<br>
[UserManager](Managers/Server/UserManager.swift) - user entity handling, OAuth, session, user requests
<br>
[EventManager](Managers/Server/EventManager.swift) - example of how to use managers for API requests, grouped by entities (Event, Order, Payment etc)
<br>

### Models

[Push](Models/Push.swift) - to implement actions on app specific push notifications
<br>
[Token](Models/Token.swift) - OAuth token to use in API
<br>
[User](Models/User.swift) - User in API
<br>