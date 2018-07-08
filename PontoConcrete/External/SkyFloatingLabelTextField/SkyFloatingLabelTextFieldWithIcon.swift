import UIKit

/**
 A beautiful and flexible textfield implementation with support for icon, title label, error message and placeholder.
 */
open class SkyFloatingLabelTextFieldWithIcon: SkyFloatingLabelTextField {
    /// A UILabel value that identifies the label used to display the icon
    open var iconLabel: UILabel!

    /// A UIFont value that determines the font that the icon is using
    @objc open dynamic var iconFont: UIFont? {
        didSet {
            self.iconLabel?.font = self.iconFont
        }
    }

    /// A String value that determines the text used when displaying the icon
    @IBInspectable
    open var iconText: String? {
        didSet {
            self.iconLabel?.text = self.iconText
        }
    }

    /// A UIColor value that determines the color of the icon in the normal state
    @IBInspectable
    open dynamic var iconColor: UIColor = UIColor.gray {
        didSet {
            updateIconLabelColor()
        }
    }

    /// A UIColor value that determines the color of the icon when the control is selected
    @IBInspectable
    open dynamic var selectedIconColor: UIColor = UIColor.gray {
        didSet {
            updateIconLabelColor()
        }
    }

    /// A float value that determines the width of the icon
    @IBInspectable
    open dynamic var iconWidth: CGFloat = 20 {
        didSet {
            updateFrame()
        }
    }

    /**
     A float value that determines the left margin of the icon.
     Use this value to position the icon more precisely horizontally.
     */
    @IBInspectable
    open dynamic var iconMarginLeft: CGFloat = 4 {
        didSet {
            updateFrame()
        }
    }

    /**
     A float value that determines the bottom margin of the icon.
     Use this value to position the icon more precisely vertically.
     */
    @IBInspectable
    open dynamic var iconMarginBottom: CGFloat = 4 {
        didSet {
            updateFrame()
        }
    }

    /**
     A float value that determines the rotation in degrees of the icon.
     Use this value to rotate the icon in either direction.
     */
    @IBInspectable
    open var iconRotationDegrees: Double = 0 {
        didSet {
            iconLabel.transform = CGAffineTransform(rotationAngle: CGFloat(iconRotationDegrees * .pi / 180.0))
        }
    }

    // MARK: Initializers

    /**
     Initializes the control
     - parameter frame the frame of the control
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createIconLabel()
    }

    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createIconLabel()
    }

    // MARK: Creating the icon label

    /// Creates the icon label
    fileprivate func createIconLabel() {
        let iconLabel = UILabel()
        iconLabel.backgroundColor = UIColor.clear
        iconLabel.textAlignment = .center
        iconLabel.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        self.iconLabel = iconLabel
        addSubview(iconLabel)

        updateIconLabelColor()
    }

    // MARK: Handling the icon color

    /// Update the colors for the control. Override to customize colors.
    open override func updateColors() {
        super.updateColors()
        self.updateIconLabelColor()
    }

    fileprivate func updateIconLabelColor() {
        if !isEnabled {
            self.iconLabel?.textColor = disabledColor
        } else if hasErrorMessage {
            self.iconLabel?.textColor = errorColor
        } else {
            self.iconLabel?.textColor = editingOrSelected ? self.selectedIconColor : self.iconColor
        }
    }

    // MARK: Custom layout overrides

    /**
     Calculate the bounds for the textfield component of the control.
     Override to create a custom size textbox in the control.
     - parameter bounds: The current bounds of the textfield component
     - returns: The rectangle that the textfield component should render in
     */
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        if isLTRLanguage {
            rect.origin.x += CGFloat(self.iconWidth + self.iconMarginLeft)
        } else {
            rect.origin.x -= CGFloat(self.iconWidth + self.iconMarginLeft)
        }
        rect.size.width -= CGFloat(self.iconWidth + self.iconMarginLeft)
        return rect
    }

    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        if isLTRLanguage {
            rect.origin.x += CGFloat(self.iconWidth + self.iconMarginLeft)
        } else {
            // don't change the editing field X position for RTL languages
        }
        rect.size.width -= CGFloat(self.iconWidth + self.iconMarginLeft)
        return rect
    }

    /**
     Calculates the bounds for the placeholder component of the control.
     Override to create a custom size textbox in the control.
     - parameter bounds: The current bounds of the placeholder component
     - returns: The rectangle that the placeholder component should render in
     */
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        if isLTRLanguage {
            rect.origin.x += CGFloat(self.iconWidth + self.iconMarginLeft)
        } else {
            // don't change the editing field X position for RTL languages
        }
        rect.size.width -= CGFloat(self.iconWidth + self.iconMarginLeft)
        return rect
    }

    /// Invoked by layoutIfNeeded automatically
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }

    fileprivate func updateFrame() {
        let textWidth: CGFloat = bounds.size.width
        if isLTRLanguage {
            self.iconLabel.frame = CGRect(
                x: 0,
                y: bounds.size.height - textHeight() - self.iconMarginBottom,
                width: self.iconWidth,
                height: textHeight()
            )
        } else {
            self.iconLabel.frame = CGRect(
                x: textWidth - self.iconWidth,
                y: bounds.size.height - textHeight() - self.iconMarginBottom,
                width: self.iconWidth,
                height: textHeight()
            )
        }
    }
}
