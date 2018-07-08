import FontAwesome
import JVFloatLabeledText
import SnapKit

class LoginView: UIView {
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "bg")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    lazy var logoView: LogoView = {
        let logoView = LogoView()
        logoView.accessibilityLabel = "logotipo"
        logoView.isAccessibilityElement = true
        return logoView
    }()

    lazy var emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon(frame: .zero)
        tf.title = "E-mail"
        tf.textColor = .white
        tf.placeholder = "E-mail"
        tf.iconFont = UIFont.fontAwesome(ofSize: 15)
        tf.iconText = "\u{f003}"
        tf.selectedIconColor = .madison
        tf.placeholderColor = .madison
        tf.errorColor = .lust
        tf.iconColor = .madison
        tf.tintColor = .madison
        tf.textColor = .madison
        tf.lineColor = .madison
        tf.selectedTitleColor = .madison
        tf.selectedLineColor = .madison

        tf.isAccessibilityElement = true
        tf.accessibilityLabel = "email"
        tf.accessibilityIdentifier = "email"
        tf.tag = 99
        tf.borderStyle = .none
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()

    lazy var passwordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon(frame: .zero)
        tf.title = "Senha"
        tf.textColor = .white
        tf.placeholder = "Senha"
        tf.iconFont = UIFont.fontAwesome(ofSize: 15)
        tf.iconText = "\u{f13e}"

        tf.errorColor = .lust
        tf.selectedIconColor = .madison
        tf.placeholderColor = .madison
        tf.iconColor = .madison
        tf.tintColor = .madison
        tf.textColor = .madison
        tf.lineColor = .madison
        tf.selectedTitleColor = .madison
        tf.selectedLineColor = .madison

        tf.isAccessibilityElement = true
        tf.accessibilityLabel = "senha"
        tf.accessibilityIdentifier = "senha"
        tf.borderStyle = .none
        tf.isSecureTextEntry = true
        tf.keyboardType = .default
        tf.returnKeyType = .go
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()

    lazy var incorrectLoginLabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.numberOfLines = 2
        lb.textColor = .white
        lb.text = "Dados Incorretos"
        lb.isAccessibilityElement = true
        lb.accessibilityLabel = "validator"
        lb.accessibilityIdentifier = "validator"
        return lb
    }()

    lazy var loginButton: UIButton = { () -> UIButton in
        let view = UIButton(frame: .zero)
        view.setTitle("", for: .disabled)
        view.setTitle("Entrar", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 17)
        view.accessibilityLabel = "entrar"
        view.accessibilityIdentifier = "entrar"
        view.isAccessibilityElement = true
        view.accessibilityTraits = UIAccessibilityTraitButton
        view.borderColor = .white
        view.borderWidth = 1
        view.cornerRadius = 10

        return view
    }()

    fileprivate(set) lazy var activityIndicator = { () -> UIActivityIndicatorView in
        let aiv = UIActivityIndicatorView(frame: .zero)
        aiv.hidesWhenStopped = true
        aiv.activityIndicatorViewStyle = .white
        aiv.accessibilityLabel = "aguarde"
        aiv.accessibilityIdentifier = "aguarde"
        aiv.isAccessibilityElement = true
        return aiv
    }()

    public init() {
        super.init(frame: .zero)
        setupViewConfiguration()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum LoginUIState {
    case ready
    case error(String)
    case loading
}

extension LoginView {
    func updateUI(state: LoginUIState) {
        self.containerView.isUserInteractionEnabled = true
        self.activityIndicator.stopAnimating()
        self.loginButton.alpha = 1
        self.incorrectLoginLabel.text = ""
        self.loginButton.isEnabled = true

        switch state {
        case .loading:
            self.containerView.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
            self.loginButton.alpha = 0.2
            self.incorrectLoginLabel.alpha = 1
            self.loginButton.isEnabled = false
        case .ready:
            self.incorrectLoginLabel.alpha = 0
        case let .error(error):
            incorrectLoginLabel.isHidden = false
            incorrectLoginLabel.alpha = 1
            incorrectLoginLabel.text = error
            containerView.shake()
        }
    }
}

extension LoginView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(self.containerView)
        self.containerView.addSubview(self.backgroundImage)
        self.containerView.addSubview(self.logoView)
        self.containerView.addSubview(self.emailTextField)
        self.containerView.addSubview(self.passwordTextField)
        self.containerView.addSubview(self.incorrectLoginLabel)
        self.containerView.addSubview(self.activityIndicator)
        self.containerView.addSubview(self.loginButton)
    }

    func setupConstraints() {
        self.backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        self.containerView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }

        self.logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(80)
            make.width.equalTo(164)
            make.height.equalTo(105)
        }

        self.setupTextFields()

        self.activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalTo(loginButton)
        }

        self.loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.left.right.equalTo(0).inset(20)
        }
    }

    private func setupTextFields() {
        self.emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom).offset(50)
            make.width.equalTo(310)
            make.height.equalTo(45)
        }

        self.passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.width.equalTo(310)
            make.height.equalTo(45)
        }

        self.incorrectLoginLabel.snp.makeConstraints { make in
            make.left.equalTo(passwordTextField.snp.left)
            make.top.equalTo(passwordTextField.snp.bottom).inset(-10)
            make.width.equalTo(276)
            make.height.equalTo(30)
        }
    }
}
