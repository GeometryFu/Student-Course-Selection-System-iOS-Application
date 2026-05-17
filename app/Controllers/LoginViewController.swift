import UIKit

class LoginViewController: UIViewController {
    
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "登录"
        view.backgroundColor = .white
        
        // 创建标题
        let titleLabel = UILabel()
        titleLabel.text = "教务管理系统"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // 创建用户名输入框
        usernameTextField.placeholder = "用户名"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocapitalizationType = .none
        
        // 创建密码输入框
        passwordTextField.placeholder = "密码"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        // 创建登录按钮
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        // 创建错误标签
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        
        // 创建堆栈视图
        let stackView = UIStackView(arrangedSubviews: [titleLabel, usernameTextField, passwordTextField, loginButton, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        // 添加到视图
        view.addSubview(stackView)
        
        // 设置布局
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            usernameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func loginTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "请输入用户名和密码"
            return
        }
        
        // 验证用户
        if let user = DataManager.shared.authenticate(username: username, password: password) {
            errorLabel.text = ""
            // 根据用户类型跳转到不同的主界面
            let mainVC: UIViewController
            
            if user.type == .student {
                mainVC = StudentTabBarController()
            } else {
                mainVC = TeacherTabBarController()
            }
            
            // 设置为根视图控制器
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: mainVC)
                sceneDelegate.window?.makeKeyAndVisible()
            }
        } else {
            errorLabel.text = "用户名或密码错误"
        }
    }
}
