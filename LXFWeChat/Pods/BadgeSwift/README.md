<img src='graphics/swift_badge_showcase_2.png' width='419' alt='Swift Badge'>

# A badge control for iOS and tvOS written in Swift

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)][carthage]
[![CocoaPods Version](https://img.shields.io/cocoapods/v/BadgeSwift.svg?style=flat)][cocoadocs]
[![License](https://img.shields.io/cocoapods/l/BadgeSwift.svg?style=flat)](/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/BadgeSwift.svg?style=flat)][cocoadocs]
[cocoadocs]: http://cocoadocs.org/docsets/BadgeSwift
[carthage]: https://github.com/Carthage/Carthage

* The badge is a subclass of UILabel view.
* It can be created and customized from the Storyboard or from the code.

## Setup (Swift 3.0)

There are three ways you can add BadgeSwift to your Xcode project.

**Add source (iOS 7+)**

Simply add [BadgeSwift.swift](https://github.com/marketplacer/swift-badge/blob/master/BadgeSwift/BadgeSwift.swift) file to your project.

#### Setup with Carthage (iOS 8+)

Alternatively, add `github "marketplacer/swift-badge" ~> 4.0` to your Cartfile and run `carthage update`.

#### Setup with CocoaPods (iOS 8+)

If you are using CocoaPods add this text to your Podfile and run `pod install`.

    use_frameworks!
    target 'Your target name'
    pod 'BadgeSwift', '~> 4.0'

### Legacy Swift versions

Setup a [previous version](https://github.com/marketplacer/swift-badge/wiki/Legacy-Swift-versions) of the library if you use an older version of Swift.

## Usage

### Creating a badge in the Storyboard

* Drag a **Label** to your view.
* Set its `class` to `BadgeSwift` in identity inspector.
* Set the `module` property to `BadgeSwift` if you used Carthage or CocoaPods setup methods.

<img src='https://raw.githubusercontent.com/marketplacer/swift-badge/master/graphics/swift_badge_class_name_3.png' width='258' alt='Add badge to storyboard'>

* Customize the badge properties in the attributes inspector (text, color and other).
* If storyboard does not show the badge correctly click **Refresh All Views** from the **Editor** menu.

<img src='https://github.com/marketplacer/swift-badge/blob/master/graphics/swift_badge_attributes_inspector_2.png' width='374' alt='Change badge properties in attribute inspector'>

*Note*: Carthage setup method does not allow to customize Cosmos view from the storyboard, please do it from code instead.


### Creating a badge from the code

```Swift
let badge = BadgeSwift()
view.addSubview(badge)
// Position the badge ...
```

[See example](https://github.com/marketplacer/swift-badge/blob/master/Demo-iOS/ViewControllers/CreateBadgeFromCodeViewController.swift) of how to create and position the badge from code in the demo app.

#### Customization

```Swift
// Text
badge.text = "2"

// Insets
badge.insets = CGSize(width: 12, height: 12)

// Font
badge.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)

// Text color
badge.textColor = UIColor.yellow

// Badge color
badge.badgeColor = UIColor.black

// Shadow
badge.shadowOpacityBadge = 0.5
badge.shadowOffsetBadge = CGSize(width: 0, height: 0)
badge.shadowRadiusBadge = 1.0
badge.shadowColorBadge = UIColor.black

// No shadow
badge.shadowOpacityBadge = 0

// Border width and color
badge.borderWidth = 5.0
badge.borderColor = UIColor.magenta

// Customize the badge corner radius.
// -1 if unspecified. When unspecified, the corner is fully rounded. Default: -1.
badge.cornerRadius = 10
```

## Demo app

This project includes a demo app.

<img src='graphics/demo_app/swift_badge_ios_demo_app.png' width='320' alt='BadgeSwift for iOS demo app'>
<img src='graphics/demo_app/swift_badge_ios_in_table_view.png' width='320' alt='Show BadgeSwift in a table view in iOS'>
<img src='graphics/demo_app/swift_badge_create_from_code.png' width='320' alt='Create badge from code BadgeSwift for iOS'>

## Alternative solutions

Here are some alternative badges for iOS.

* [ckteebe/CustomBadge](https://github.com/ckteebe/CustomBadge)
* [JaviSoto/JSBadgeView](https://github.com/JaviSoto/JSBadgeView)
* [mikeMTOL/UIBarButtonItem-Badge](https://github.com/mikeMTOL/UIBarButtonItem-Badge)
* [mustafaibrahim989/MIBadgeButton-Swift](https://github.com/mustafaibrahim989/MIBadgeButton-Swift)
* [soffes/SAMBadgeView](https://github.com/soffes/SAMBadgeView)
* [tmdvs/TDBadgedCell](https://github.com/tmdvs/TDBadgedCell)

## Thanks to 👍

* [amg1976](https://github.com/amg1976) for adding a border and redesigning the drawing.
* [gperdomor](https://github.com/gperdomor) for adding ability to customize corner radius.

## License

BadgeSwift is released under the [MIT License](LICENSE).

## Feedback is welcome

If you found a bug or want to improve the badge feel free to create an issue.
