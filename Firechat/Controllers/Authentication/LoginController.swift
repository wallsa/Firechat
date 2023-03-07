//
//  LoginController.swift
//  Firechat
//
//  Created by Wallace Santos on 18/02/23.
//

import UIKit
import JGProgressHUD

protocol AuthenticateControllerProtocol{
    func checkAuthenticateStatus()
}

protocol AuthenticationDelegate:AnyObject{
    func authenticateComplete(forUid uid:String)
}

class LoginController:UIViewController{
    
    //MARK: - Properties
    
    weak var delegate:AuthenticationDelegate?
    
    private var loginViewModel = LoginViewModel()
    
    private let logoImage : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: Constants.messageBaloon)
        return imageView
    }()
    
    private let emailTextField : UITextField = {
        return UITextField().createLoginTextField(placeholder:"Email", isSecure: false, keyboardType: .emailAddress)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().createLoginTextField(placeholder: "Password", isSecure: true, keyboardType: .default)
    }()
    
    private let eyeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.eye), for: .normal)
        button.tintColor = .mainPurple
        button.addTarget(self , action: #selector(togglePassword), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
        return button
    }()
    
    private lazy var emailContainer : UIView = {
        return UIView().loginContainer(image: Constants.envelope, textfield: emailTextField)
    }()
    
    private lazy var passwordContainer : UIView = {
        return UIView().loginContainer(image: Constants.lock, textfield: passwordTextField, showPassButton: eyeButton)
    }()
    
    private let dontHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString()
                .attributedText(withText: "Dont have an account? ", andBoldText: "Sign Up", color: .white), for: .normal)
        button.addTarget(self , action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainPurple
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.7
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self , action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }

//MARK: - API

//MARK: - Helper Functions
    
    func configure(){
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(logoImage)
        logoImage.centerX(inview: view)
        logoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20, width: 150, height: 150)
        
        view.addSubview(emailContainer)
        emailContainer.anchor(top: logoImage.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 50, paddingLeft: 24, paddingRight: 24, height: 50)
        view.addSubview(passwordContainer)
        passwordContainer.anchor(top: emailContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 8)
        
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
    }
    

//MARK: - Selectors
    
    @objc func handleSignup(){
        let signupController = SignupController()
        signupController.delegate = delegate
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        showHUD(true, with: "Loggin In")
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error{
                self.showHUD(false)
                print("DEBUG: Error log in \(error.localizedDescription)")
                let alert = UIAlertController().createSimpleAlert(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true)
                return
            }
            print("DEBUG:Sucess Login")
            self.showHUD(false)
            guard let uid = result?.user.uid else {return}
            self.delegate?.authenticateComplete(forUid: uid)
        }
    }
    
    @objc func togglePassword(){
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func handleTextChange(sender:UITextField){
        if sender == emailTextField{
            loginViewModel.email = sender.text
        } else {
            loginViewModel.password = sender.text
        }
        checkAuthenticateStatus()
    }
}
//MARK: - Authenticate Controller Protocol

extension LoginController:AuthenticateControllerProtocol{
    
    func checkAuthenticateStatus() {
        if loginViewModel.formIsValid{
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.7
        }
    }
}


