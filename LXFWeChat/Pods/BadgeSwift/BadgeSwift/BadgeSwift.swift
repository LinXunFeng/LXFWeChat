import UIKit

/**
 
 Badge view control for iOS and tvOS.
 
 Project home: https://github.com/marketplacer/swift-badge
 
 */
@IBDesignable public class BadgeSwift: UILabel {
  
  /// Background color of the badge
  @IBInspectable public var badgeColor: UIColor = UIColor.red {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /// Width of the badge border
  @IBInspectable public var borderWidth: CGFloat = 0 {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  /// Color of the bardge border
  @IBInspectable public var borderColor: UIColor = UIColor.white {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  /// Badge insets that describe the margin between text and the edge of the badge.
  @IBInspectable public var insets: CGSize = CGSize(width: 5, height: 2) {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  // MARK: Badge shadow
  // --------------------------
  
  /// Opacity of the badge shadow
  @IBInspectable public var shadowOpacityBadge: CGFloat = 0.5 {
    didSet {
      layer.shadowOpacity = Float(shadowOpacityBadge)
      setNeedsDisplay()
    }
  }
  
  /// Size of the badge shadow
  @IBInspectable public var shadowRadiusBadge: CGFloat = 0.5 {
    didSet {
      layer.shadowRadius = shadowRadiusBadge
      setNeedsDisplay()
    }
  }
  
  /// Color of the badge shadow
  @IBInspectable public var shadowColorBadge: UIColor = UIColor.black {
    didSet {
      layer.shadowColor = shadowColorBadge.cgColor
      setNeedsDisplay()
    }
  }
  
  /// Offset of the badge shadow
  @IBInspectable public var shadowOffsetBadge: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      layer.shadowOffset = shadowOffsetBadge
      setNeedsDisplay()
    }
  }
  
  /// Corner radius of the badge. -1 if unspecified. When unspecified, the corner is fully rounded. Default: -1.
  @IBInspectable public var cornerRadius: CGFloat = -1 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /// Initialize the badge view
  convenience public init() {
    self.init(frame: CGRect())
  }
  
  /// Initialize the badge view
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  /// Initialize the badge view
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  /// Add custom insets around the text
  override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    
    var insetsWithBorder = actualInsetsWithBorder()
    let rectWithDefaultInsets = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
    
    // If width is less than height
    // Adjust the width insets to make it look round
    if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
      insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
    }
    let result = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
    
    return result
  }
  
  /// Draws the label with insets
  override public func drawText(in rect: CGRect) {
    if cornerRadius >= 0 {
      layer.cornerRadius = cornerRadius
    }else {
      // Use fully rounded corner if radius is not specified
      layer.cornerRadius = rect.height / 2
    }
    
    let insetsWithBorder = actualInsetsWithBorder()
    let insets = UIEdgeInsets(
      top: insetsWithBorder.height,
      left: insetsWithBorder.width,
      bottom: insetsWithBorder.height,
      right: insetsWithBorder.width)
    
    let rectWithoutInsets = UIEdgeInsetsInsetRect(rect, insets)
    
    super.drawText(in: rectWithoutInsets)
  }
  
  /// Draw the background of the badge
  override public func draw(_ rect: CGRect) {
    let rectInset = rect.insetBy(dx: borderWidth/2, dy: borderWidth/2)
    
    let actualCornerRadius = cornerRadius >= 0 ? cornerRadius : rect.height/2
    
    var path: UIBezierPath?
    
    if actualCornerRadius == 0 {
      // Use rectangular path when corner radius is zero as a workaround
      // a glith in the left top corner with UIBezierPath(roundedRect).
      path = UIBezierPath(rect: rectInset)
    } else {
      path = UIBezierPath(roundedRect: rectInset, cornerRadius: actualCornerRadius)
    }

    badgeColor.setFill()
    path?.fill()

    if borderWidth > 0 {
      borderColor.setStroke()
      path?.lineWidth = borderWidth
      path?.stroke()
    }
    
    super.draw(rect)
  }
  
  private func setup() {
    textAlignment = NSTextAlignment.center
    clipsToBounds = false // Allows shadow to spread beyond the bounds of the badge
  }
  
  /// Size of the insets plus the border
  private func actualInsetsWithBorder() -> CGSize {
    return CGSize(
      width: insets.width + borderWidth,
      height: insets.height + borderWidth
    )
  }
  
  /// Draw the stars in interface builder
  @available(iOS 8.0, *)
  override public func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    
    setup()
    setNeedsDisplay()
  }
}
