# APESuperHUD
A simple way to display a HUD with a message or progress information in your application.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/6545513/19601280/eafb4b50-97a8-11e6-811b-23a6e9d92234.gif" alt="APESuperHUD">
</p>

## Features
- Simplicity.
- Customizable. See [Change appearance](#change-appearance).
- Fully written in Swift.
- Unit tests.

## Requirements
- iOS 9 or later.
- Xcode 9 (Swift 4.1) or later.
  - For Swift 3.0 use version 1.1.3
  - For Swift 2.2 use version 0.6

## Installation
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `APESuperHUD` by adding it to your `Podfile`:
```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
    pod 'APESuperHUD', :git => 'https://github.com/apegroup/APESuperHUD.git'
end
```
Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 9.0:

#### Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `APESuperHUD` by adding it to your `Cartfile`:
```
github "apegroup/APESuperHUD"
```

## Usage
Don't forget to import.
```swift
import APESuperHUD
```
#### Show hud with icon
```swift
let image = UIImage(named: "apegroup")!
APESuperHUD.show(style: .icon(image: image, duration: 3.0), title: "Hello", message: "world")

// Or create a instance of APESuperHud

/*
let hudViewController = APESuperHUD(style: .icon(image: image, duration: 3), title: "Hello", message: "world")
present(hudViewController, animated: true)
*/
```
#### Show hud with loading indicator
```swift
APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")

DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
    APESuperHUD.dismissAll(animated: true)
})

// Or create a instance of APESuperHud

/*
let hudViewController = APESuperHUD(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
present(hudViewController, animated: true)

DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
    hudViewController.dismiss(animated: true)
})
*/
```
#### Show hud with title and message
```swift
APESuperHUD.show(style: .textOnly, title: "Hello", message: "world")

DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
    APESuperHUD.dismissAll(animated: true)
})

// Or create a instance of APESuperHud

/*
let hudViewController = APESuperHUD(style: .textOnly, title: "Hello", message: "world")
present(hudViewController, animated: true)

DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
    hudViewController.dismiss(animated: true)
})
*/
```
#### Show hud with updates
```swift
APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")

DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
    APESuperHUD.show(style: .textOnly, title: "Done loading", message: nil)

    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
        let image = UIImage(named: "apegroup")!
        APESuperHUD.show(style: .icon(image: image, duration: 3.0), title: nil, message: nil)
    })
})
```
#### Change appearance
```swift
/// Text color of the title text inside the HUD
HUDAppearance.titleTextColor = UIColor.black

/// Text color of the message text inside the HUD
HUDAppearance.messageTextColor = UIColor.black

/// The color of the icon in the HUD
HUDAppearance.iconColor = UIColor.black

/// The background color of the view where the HUD is presented
HUDAppearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)

/// The background color of the HUD view
HUDAppearance.foregroundColor = UIColor.white

/// The color of the loading indicator
HUDAppearance.loadingActivityIndicatorColor = UIColor.gray

/// The corner radius of the HUD
HUDAppearance.cornerRadius = 10.0

/// Enables/disables shadow effect around the HUD
HUDAppearance.shadow = true

/// The shadow color around the HUD
HUDAppearance.shadowColor = UIColor.black

/// The shadow offset around the HUD
HUDAppearance.shadowOffset = CGSize(width: 0, height: 0)

/// The shadow radius around the HUD
HUDAppearance.shadowRadius = 6.0

/// The shadow opacity around the HUD
HUDAppearance.shadowOpacity = 0.15

/// Enables/disables removal of the HUD if the user taps on the screen
HUDAppearance.cancelableOnTouch = true

/// The info message font in the HUD
HUDAppearance.messageFont = UIFont.systemFont(ofSize: 13, weight: .regular)

/// The title font in the HUD
HUDAppearance.titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)

/// The size of the icon inside the HUD
HUDAppearance.iconSize = CGSize(width: 48, height: 48)

/// The HUD size
HUDAppearance.hudSize = CGSize(width: 144, height: 144)

/// The HUD fade in duration
HUDAppearance.animateInTime = 0.7

/// The HUD fade out duration
HUDAppearance.animateOutTime = 0.7
```

## Contributing
All people are welcome to contribute. See CONTRIBUTING for details.

## License
APESuperHUD is released under the MIT license. See LICENSE for details.
