import UIKit

/**
 A beautiful and flexible textfield implementation with support for title label, error message and placeholder.
 */
@IBDesignable
open class SkyFloatingLabelTextField: UITextField { // swiftlint:disable:this type_body_length
    /**
     A Boolean value that determines if the language displayed is LTR.
     Default value set automatically from the application language settings.
     */
    open var isLTRLanguage: Bool = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
            updateTextAligment()
        }
    }

    fileprivate func updateTextAligment() {
        if self.isLTRLanguage {
            textAlignment = .left
            self.titleLabel.textAlignment = .left
        } else {
            textAlignment = .right
            self.titleLabel.textAlignment = .right
        }
    }

    // MARK: Animation timing

    /// The value of the title appearing duration
    @objc open dynamic var titleFadeInDuration: TimeInterval = 0.2
    /// The value of the title disappearing duration
    @objc open dynamic var titleFadeOutDuration: TimeInterval = 0.3

    // MARK: Colors

    fileprivate var cachedTextColor: UIColor?

    /// A UIColor value that determines the text color of the editable text
    @IBInspectable
    open dynamic override var textColor: UIColor? {
        set {
            self.cachedTextColor = newValue
            self.updateControl(false)
        }
        get {
            return self.cachedTextColor
        }
    }

    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable open dynamic var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            updatePlaceholder()
        }
    }

    /// A UIFont value that determines text color of the placeholder label
    @objc open dynamic var placeholderFont: UIFont? {
        didSet {
            self.updatePlaceholder()
        }
    }

    fileprivate func updatePlaceholder() {
        guard let placeholder = placeholder, let font = placeholderFont ?? font else {
            return
        }
        let color = isEnabled ? placeholderColor : disabledColor
        #if swift(>=4.0)
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font,
                ]
            )
        #else
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
            )
        #endif
    }

    /// A UIFont value that determines the text font of the title label
    @objc open dynamic var titleFont: UIFont = .systemFont(ofSize: 13) {
        didSet {
            updateTitleLabel()
        }
    }

    /// A UIColor value that determines the text color of the title label when in the normal state
    @IBInspectable open dynamic var titleColor: UIColor = .gray {
        didSet {
            updateTitleColor()
        }
    }

    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable open dynamic var lineColor: UIColor = .lightGray {
        didSet {
            updateLineView()
        }
    }

    /// A UIColor value that determines the color used for the title label and line when the error message is not `nil`
    @IBInspectable open dynamic var errorColor: UIColor = .red {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the title label and line when text field is disabled
    @IBInspectable open dynamic var disabledColor: UIColor = UIColor(white: 0.88, alpha: 1.0) {
        didSet {
            updateControl()
            updatePlaceholder()
        }
    }

    /// A UIColor value that determines the text color of the title label when editing
    @IBInspectable open dynamic var selectedTitleColor: UIColor = .blue {
        didSet {
            updateTitleColor()
        }
    }

    /// A UIColor value that determines the color of the line in a selected state
    @IBInspectable open dynamic var selectedLineColor: UIColor = .black {
        didSet {
            updateLineView()
        }
    }

    // MARK: Line height

    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable open dynamic var lineHeight: CGFloat = 0.5 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable open dynamic var selectedLineHeight: CGFloat = 1.0 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    // MARK: View components

    /// The internal `UIView` to display the line below the text input.
    open var lineView: UIView!

    /// The internal `UILabel` that displays the selected, deselected title or error message based on the current state.
    open var titleLabel: UILabel!

    // MARK: Properties

    /**
     The formatter used before displaying content in the title label.
     This can be the `title`, `selectedTitle` or the `errorMessage`.
     The default implementation converts the text to uppercase.
     */
    open var titleFormatter: ((String) -> String) = { (text: String) -> String in
        text.uppercased()
    }

    /**
     Identifies whether the text object should hide the text being entered.
     */
    open override var isSecureTextEntry: Bool {
        set {
            super.isSecureTextEntry = newValue
            fixCaretPosition()
        }
        get {
            return super.isSecureTextEntry
        }
    }

    /// A String value for the error message to display.
    open var errorMessage: String? {
        didSet {
            self.updateControl(true)
        }
    }

    /// The backing property for the highlighted property
    fileprivate var _highlighted: Bool = false

    /**
     A Boolean value that determines whether the receiver is highlighted.
     When changing this value, highlighting will be done with animation
     */
    open override var isHighlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            updateTitleColor()
            updateLineView()
        }
    }

    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }

    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage: Bool {
        return self.errorMessage != nil && self.errorMessage != ""
    }

    fileprivate var _renderingInInterfaceBuilder: Bool = false

    /// The text content of the textfield
    @IBInspectable
    open override var text: String? {
        didSet {
            self.updateControl(false)
        }
    }

    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    @IBInspectable
    open override var placeholder: String? {
        didSet {
            setNeedsDisplay()
            self.updatePlaceholder()
            self.updateTitleLabel()
        }
    }

    /// The String to display when the textfield is editing and the input is not empty.
    @IBInspectable open var selectedTitle: String? {
        didSet {
            self.updateControl()
        }
    }

    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title: String? {
        didSet {
            updateControl()
        }
    }

    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected: Bool {
        didSet {
            self.updateControl(true)
        }
    }

    // MARK: - Initializers

    /**
     Initializes the control
     - parameter frame the frame of the control
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.init_SkyFloatingLabelTextField()
    }

    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.init_SkyFloatingLabelTextField()
    }

    fileprivate final func init_SkyFloatingLabelTextField() {
        borderStyle = .none
        self.createTitleLabel()
        self.createLineView()
        self.updateColors()
        self.addEditingChangedObserver()
        self.updateTextAligment()
    }

    fileprivate func addEditingChangedObserver() {
        addTarget(self, action: #selector(SkyFloatingLabelTextField.editingChanged), for: .editingChanged)
    }

    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc open func editingChanged() {
        self.updateControl(true)
        self.updateTitleLabel(true)
    }

    // MARK: create components

    fileprivate func createTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.font = titleFont
        titleLabel.alpha = 0.0
        titleLabel.textColor = titleColor

        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }

    fileprivate func createLineView() {
        if self.lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
            configureDefaultLineHeight()
        }

        self.lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(self.lineView)
    }

    fileprivate func configureDefaultLineHeight() {
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        lineHeight = 2.0 * onePixel
        selectedLineHeight = 2.0 * lineHeight
    }

    // MARK: Responder handling

    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(true)
        return result
    }

    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    open override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateControl(true)
        return result
    }

    /// update colors when is enabled changed
    open override var isEnabled: Bool {
        didSet {
            self.updateControl()
            self.updatePlaceholder()
        }
    }

    // MARK: - View updates

    fileprivate func updateControl(_ animated: Bool = false) {
        self.updateColors()
        self.updateLineView()
        self.updateTitleLabel(animated)
    }

    fileprivate func updateLineView() {
        if let lineView = lineView {
            lineView.frame = self.lineViewRectForBounds(bounds, editing: self.editingOrSelected)
        }
        self.updateLineColor()
    }

    // MARK: - Color updates

    /// Update the colors for the control. Override to customize colors.
    open func updateColors() {
        self.updateLineColor()
        self.updateTitleColor()
        self.updateTextColor()
    }

    fileprivate func updateLineColor() {
        if !self.isEnabled {
            self.lineView.backgroundColor = self.disabledColor
        } else if self.hasErrorMessage {
            self.lineView.backgroundColor = self.errorColor
        } else {
            self.lineView.backgroundColor = self.editingOrSelected ? self.selectedLineColor : self.lineColor
        }
    }

    fileprivate func updateTitleColor() {
        if !self.isEnabled {
            self.titleLabel.textColor = self.disabledColor
        } else if self.hasErrorMessage {
            self.titleLabel.textColor = self.errorColor
        } else {
            if self.editingOrSelected || self.isHighlighted {
                self.titleLabel.textColor = self.selectedTitleColor
            } else {
                self.titleLabel.textColor = self.titleColor
            }
        }
    }

    fileprivate func updateTextColor() {
        if !self.isEnabled {
            super.textColor = self.disabledColor
        } else if self.hasErrorMessage {
            super.textColor = self.errorColor
        } else {
            super.textColor = self.cachedTextColor
        }
    }

    // MARK: - Title handling

    fileprivate func updateTitleLabel(_ animated: Bool = false) {
        var titleText: String?
        if self.hasErrorMessage {
            titleText = self.titleFormatter(self.errorMessage!)
        } else {
            if self.editingOrSelected {
                titleText = self.selectedTitleOrTitlePlaceholder()
                if titleText == nil {
                    titleText = self.titleOrPlaceholder()
                }
            } else {
                titleText = self.titleOrPlaceholder()
            }
        }
        self.titleLabel.text = titleText
        self.titleLabel.font = titleFont

        self.updateTitleVisibility(animated)
    }

    fileprivate var _titleVisible: Bool = false

    /*
     *   Set this value to make the title visible
     */
    open func setTitleVisible(
        _ titleVisible: Bool,
        animated: Bool = false,
        animationCompletion: ((_ completed: Bool) -> Void)? = nil
    ) {
        if self._titleVisible == titleVisible {
            return
        }
        self._titleVisible = titleVisible
        self.updateTitleColor()
        self.updateTitleVisibility(animated, completion: animationCompletion)
    }

    /**
     Returns whether the title is being displayed on the control.
     - returns: True if the title is displayed on the control, false otherwise.
     */
    open func isTitleVisible() -> Bool {
        return hasText || self.hasErrorMessage || self._titleVisible
    }

    fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
        let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())
        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            let animationOptions: UIViewAnimationOptions = .curveEaseOut
            let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }

    // MARK: - UITextField text/placeholder positioning overrides

    /**
     Calculate the rectangle for the textfield when it is not being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let titleHeight = self.titleHeight()

        let rect = CGRect(
            x: superRect.origin.x,
            y: titleHeight,
            width: superRect.size.width,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
        return rect
    }

    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let titleHeight = self.titleHeight()

        let rect = CGRect(
            x: superRect.origin.x,
            y: titleHeight,
            width: superRect.size.width,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
        return rect
    }

    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0,
            y: titleHeight(),
            width: bounds.size.width,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    // MARK: - Positioning Overrides

    /**
     Calculate the bounds for the title label. Override to create a custom size title field.
     - parameter bounds: The current bounds of the title
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the title label should render in
     */
    open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        if editing {
            return CGRect(x: 0, y: 0, width: bounds.size.width, height: self.titleHeight())
        }
        return CGRect(x: 0, y: self.titleHeight(), width: bounds.size.width, height: self.titleHeight())
    }

    /**
     Calculate the bounds for the bottom line of the control.
     Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }

    /**
     Calculate the height of the title label.
     -returns: the calculated height of the title label. Override to size the title with a different height
     */
    open func titleHeight() -> CGFloat {
        if let titleLabel = titleLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return 15.0
    }

    /**
     Calcualte the height of the textfield.
     -returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        return font!.lineHeight + 7.0
    }

    // MARK: - Layout

    /// Invoked when the interface builder renders the control
    open override func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }

        borderStyle = .none

        self.isSelected = true
        self._renderingInInterfaceBuilder = true
        self.updateControl(false)
        invalidateIntrinsicContentSize()
    }

    /// Invoked by layoutIfNeeded automatically
    open override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.frame = self.titleLabelRectForBounds(bounds, editing: self.isTitleVisible() || self._renderingInInterfaceBuilder)
        self.lineView.frame = self.lineViewRectForBounds(bounds, editing: self.editingOrSelected || self._renderingInInterfaceBuilder)
    }

    /**
     Calculate the content size for auto layout

     - returns: the content size to be used for auto layout
     */
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: self.titleHeight() + self.textHeight())
    }

    // MARK: - Helpers

    fileprivate func titleOrPlaceholder() -> String? {
        guard let title = title ?? placeholder else {
            return nil
        }
        return self.titleFormatter(title)
    }

    fileprivate func selectedTitleOrTitlePlaceholder() -> String? {
        guard let title = selectedTitle ?? title ?? placeholder else {
            return nil
        }
        return self.titleFormatter(title)
    }
} // swiftlint:disable:this file_length
