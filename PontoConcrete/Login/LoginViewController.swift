import Moya
import UIKit

fileprivate extension Selector {
    static let loginTapped = #selector(LoginViewController.tappedLogin)
}

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidTapAutenticate(viewController: LoginViewController)
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?

    let containerView = LoginView()
    private(set) var service: PontoMaisService

    init(service: PontoMaisService = PontoMaisService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = self.containerView
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        if ProcessInfo.processInfo.isUITesting {
            configureUITests()
        }
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField, floatingLabelTextField.tag == 99 {
                if text.count < 3 || !text.contains("@") {
                    floatingLabelTextField.errorMessage = "E-mail inválido"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.containerView.emailTextField {
            self.containerView.passwordTextField.becomeFirstResponder()
            return true
        }

        textField.resignFirstResponder()

        if self.containerView.emailTextField.text != "" && self.containerView.passwordTextField.text != "" {
            login()
        }

        return true
    }
}

extension LoginViewController {
    private func setupView() {
        self.containerView.updateUI(state: .ready)

        self.containerView.loginButton.addTarget(self, action: .loginTapped, for: .touchUpInside)
        self.containerView.emailTextField.delegate = self
        self.containerView.passwordTextField.delegate = self
    }

    @objc
    fileprivate func tappedLogin() {
        self.login()
    }

    private func login() {
        self.containerView.updateUI(state: .loading)

        guard let login = self.containerView.emailTextField.text,
            let password = self.containerView.passwordTextField.text else {
            return
        }

        self.service.login(email: login, password: password) { loginResponse, result in
            switch result {
            case .success:
                if let validLogin = loginResponse {
                    guard let token = validLogin.token, let clientId = validLogin.clientId else {
                        self.containerView.updateUI(state: .error("Dados Incorretos"))
                        return
                    }

                    guard let email = self.containerView.emailTextField.text else { return }

                    let user = SessionData(token: token, clientId: clientId, email: email)

                    guard CurrentUser.shared.new(user: user) else { return }

                    SwiftWatchConnectivity.shared.sendMesssage(message: user.asDict())

                    self.delegate?.loginViewControllerDidTapAutenticate(viewController: self)
                }

            case let .failure(error):
                self.containerView.updateUI(state: .error(error.localizedDescription))
            }
        }
    }

    private func configureUITests() {
        let endpointClosure = { (target: PontoMaisRoute) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: {
                         .networkResponse(200, target.sampleData)
            }, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }

        let provider = MoyaProvider<PontoMaisRoute>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let api = PontoMaisAPI(provider: provider)
        service = PontoMaisService(provider: api)
    }
}
