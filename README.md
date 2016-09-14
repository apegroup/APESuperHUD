#APESuperHUD
A simple way to display a HUD with a message or progress information in your application.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/16682908/12681053/f4974f7e-c6ac-11e5-972e-f234200872aa.gif" alt="APESuperHUD">
  <img src="https://cloud.githubusercontent.com/assets/16682908/12681280/1c018a6a-c6ae-11e5-884e-d12a1a112f58.gif" alt="APESuperHUD">
</p>

##Features
- Simplicity.
- Customizable. See [Change appearance](#change-appearance).
- Fully written in Swift.
- Unit tests.

##Requirements
- iOS 8 or later.
- Xcode 8 (Swift 3.0) or later. For Swift 2.2 use version 0.6

##Installation
####CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `APESuperHUD` by adding it to your `Podfile`:
```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'APESuperHUD', :git => 'https://github.com/apegroup/APESuperHUD.git'
end
```
Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 8.0:

####Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `APESuperHUD` by adding it to your `Cartfile`:
```
github "apegroup/APESuperHUD"
```

##Usage
Don't forget to import.
```swift
import APESuperHUD
```
####Show message HUD
######With default icon
```swift
APESuperHUD.showOrUpdateHUD(icon: .email, message: "1 new message", duration: 3.0, presentingView: self.view, completion: { _ in
    // Completed
})
```
######With custom image
```swift
APESuperHUD.showOrUpdateHUD(icon: UIImage(named: "apegroup")!, message: "Demo message", duration: 3.0, presentingView: self.view, completion: { _ in
    // Completed
})
```
######With Title
```swift
APESuperHUD.showOrUpdateHUD(title: "Title", message: "Demo message", presentingView: self.view) { _ in
    // Completed
}
```


####Show HUD with loading indicator
######With loading text
```swift
APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Demo loading...", presentingView: self.view)
```
######Without loading text
```swift
APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view, completion: nil)
```
######With funny loading texts
```swift
APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, funnyMessagesLanguage: .english, presentingView: self.view)
```
####Remove HUD
```swift
APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: { _ in
    // Completed
})
```
####Change appearance
```swift
APESuperHUD.appearance.cornerRadius = 12
APESuperHUD.appearance.animateInTime = 1.0
APESuperHUD.appearance.animateOutTime = 1.0
APESuperHUD.appearance.backgroundBlurEffect = .none
APESuperHUD.appearance.iconColor = UIColor.green
APESuperHUD.appearance.textColor =  UIColor.green
APESuperHUD.appearance.loadingActivityIndicatorColor = UIColor.green
APESuperHUD.appearance.defaultDurationTime = 4.0
APESuperHUD.appearance.cancelableOnTouch = true
APESuperHUD.appearance.iconWidth = 48
APESuperHUD.appearance.iconHeight = 48
APESuperHUD.appearance.messageFontName = "Caviar Dreams"
APESuperHUD.appearance.titleFontName = "Caviar Dreams"
APESuperHUD.appearance.titleFontSize = 22
APESuperHUD.appearance.messageFontSize = 14
```

##Contributing
All people are welcome to contribute. See CONTRIBUTING for details.

##License
APESuperHUD is released under the MIT license. See LICENSE for details.
