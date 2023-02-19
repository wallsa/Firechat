//
//  LoginController.swift
//  Firechat
//
//  Created by Wallace Santos on 18/02/23.
//

import UIKit

class LoginController:UIViewController{
    
    //MARK: - Properties
    
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
        

        
    }
    
    func configureGradientLayer(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.mainPurple.cgColor, UIColor.navyBlue.cgColor]
        gradient.locations = [0, 1]
        gradient.borderColor = UIColor.red.cgColor
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }

//MARK: - Selectors
    
    @objc func handleSignup(){
        print("DEBUG: HANDLE SIGNUP")
    }
    
    @objc func handleLogin(){
        print("DEBUG Handle Login")
    }
    
    @objc func togglePassword(){
        passwordTextField.isSecureTextEntry.toggle()
    }
}
