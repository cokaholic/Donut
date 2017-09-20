<p align="center">
  <img src="https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/logo.png" width="500">
</p>

# Overview
<p align="center">
  <img src="https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/overview.gif" width="300">
</p>

<p align="center">
<b>Donut</b><a> is a library for arranging views circularly like a donut.<br><br>You can use it so easily, and it will be a wonderful experience for you.<br><br>This library is inspired by </a><a href="https://github.com/emadrazo/EMCarousel">EMCarousel</a><a>.</a>
</p>
  
# Contents
- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Author](#author)

## <a name="features"> Features

![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat-square
)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg?style=flat-square)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat-square
)](http://mit-license.org)
![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat-square)
![pod](https://img.shields.io/badge/pod-v1.2.0-red.svg?style=flat-square)

- [x] Animated item selection
- [x] Add items with animation
- [x] Support auto cell alignment center
- [x] Support 3D inclination angle (x, z)
- [x] Support animation curve （linear, easeInOut, easeIn, easeOut）
- [x] Support Interface Builder
- [x] Support `Swift3`
- [x] And more...

## <a name="usage"> Usage

### *1. Frame Size And Center Diff*
It is better to set **frame of a UIViewController's view to frame of the donutView**.  
If you want to move center point of the donutView, please use `setCenterDiff(CGPoint(x: #X_Diff, y: #Y_Diff))`.  

### *2. Set Configures*

### Inclinations
If you want to change the inclinations of DonutView, please use `setCarouselInclination(angleX: #AngleX, angleZ: #AngleZ)`.  
You can change it about X and Z angles.  

| **#AngleX = -.pi / 8.0** | **#AngleZ = -.pi / 4.0** |
|---|---|
| ![x-pi_8](https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/x-pi_8.gif) | ![z-pi_4](https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/z-pi_4.gif) |

### Cells Alpha
If you want to change the alpha of front or back DonutViewCells, please use `setFrontCellAlpha(#AlphaFront)` or `setBackCellAlpha(#AlphaBack)`.  

| **#AlphaFront = 1.0, #AlphaBack = 0.7** | **#AlphaFront = 0.7, #AlphaBack = 1.0** |
|---|---|
| ![f10_b07](https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/f10_b07.png) | ![f07_b10](https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/f07_b10.png) |

### Selectable
You can set whether DonutView is selectable or not by `setSelectableCell(Bool)`.  
If the cells is selectable, the selected cell is scrolled to the center.  

### Auto Cell Alignment Center
You can set whether the alignment of DonutView is center or not by `setCellAlignmentCenter(Bool)`.  

| **true** | **false** |
|---|---|
| ![alignment_center_true](https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/alignment_center_true.gif) | ![alignment_center_false](https://raw.githubusercontent.com/cokaholic/ImageAssets/master/Donut/alignment_center_false.gif) |

### Back Cells Interaction Enabled
You can set whether the interaction of DonutView's back cells is enable or not by `setBackCellInteractionEnabled(Bool)`.  

### Only Cells Interaction Enabled
You can set whether the interaction of DonutView is enable only cells or not by `setOnlyCellInteractionEnabled(Bool)`.  

### Animation Curve
If you want to change the animation curve of DonutView, please use `setAnimationCurve(UIViewAnimationCurve)`.  
You can set an animation curve from below list.  

```swift
public enum UIViewAnimationCurve : Int {

    case easeInOut // slow at beginning and end

    case easeIn // slow at beginning

    case easeOut // slow at end

    case linear
}
```

### *3. DonutViewDelegate (if you need)*
If you want to know at changed center cell or selected cell, you can use below delegate methods.

```swift
optional func donutView(_ donutView: DonutView, didChangeCenter cell: DonutViewCell)
optional func donutView(_ donutView: DonutView, didSelect cell: DonutViewCell)
```

### *4. Add Cells*
You can add one or more cells inherited from DonutViewCell to DonutView.  
**Attention Please!: Before adding a cell, you need to set the frame size for the added cell!!!**  
If you want to add cell, please use `addCell(_ cell: DonutViewCell)` or `addCells(_ cells: [DonutViewCell])`.

```swift
class ViewController: UIViewController, DonutViewDelegate {
  private let donutView = DonutView()
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        donutView.frame = view.bounds                   // It's better
        donutView.setCenterDiff(CGPoint(x: 0, y: 0))    // Set center diff
        donutView.setFrontCellAlpha(1.0)                // Set front cells alpha
        donutView.setBackCellAlpha(0.7)                 // Set back cells alpha
        donutView.setSelectableCell(true)               // Set selectable
        donutView.setCellAlignmentCenter(true)          // Set auto cell alignment center
        donutView.setBackCellInteractionEnabled(false)  // Set back cells interaction
        donutView.setOnlyCellInteractionEnabled(true)   // Set only cells interaction
        donutView.setAnimationCurve(.linear)            // Set animation curve
        donutView.addCells(getCardCells())              // Add cells

        donutView.delegate = self                       // Set delegate
        view.addSubview(donutView)
  }
  
  // MARK: - DonutViewDelegate

  func donutView(_ donutView: DonutView, didChangeCenter cell: DonutViewCell) {
      print("current center cell: \(cell)")
  }

  func donutView(_ donutView: DonutView, didSelect cell: DonutViewCell) {
      print("selected cell: \(cell)")
  }
}
```

See [Example](https://github.com/cokaholic/Donut/tree/master/Example), for more details.

## <a name="requirements"> Requirements

- Xcode 8.0+
- Swift 3.0+
- iOS 9.0+

## <a name="installation"> Installation

### CocoaPods

Donut is available through [CocoaPods](http://cocoapods.org).   
To install
it, simply add the following line to your Podfile:

```ruby
pod "Donut"
```

### Carthage

Add the following line to your `Cartfile`:

```ruby
github "cokaholic/Donut"
```

### Manually

Add the [Donut](./Donut) directory to your project.

## <a name="author"> Author

Keisuke Tatsumi

- [GitHub](https://github.com/cokaholic)
- [Facebook](https://www.facebook.com/keisuke.tatsumi.50)
- [Twitter](https://twitter.com/TK_u_nya)
- Gmail: nietzsche.god.is.dead@gmail.com

## License

Donut is available under the MIT license.  
See the [LICENSE file](https://github.com/cokaholic/Donut/blob/master/LICENSE) for more info.
