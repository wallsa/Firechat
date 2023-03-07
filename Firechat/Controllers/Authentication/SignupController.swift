//
//  SignupController.swift
//  Firechat
//
//  Created by Wallace Santos on 18/02/23.
//

import UIKit
import Firebase

class SignupController:UIViewController{
    
//MARK: - Properties
    weak var delegate:AuthenticationDelegate?
    private let imagePicker =  UIImagePickerController()
    private var image : UIImage?
    
    
    private var signupViewModel = SignupViewModel()
    
    private let profilePhotoView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Constants.personAdd)
        view.tintColor = .white
        view.isUserInteractionEnabled = true
   
        return view
    }()
    
    private let fullNameTextField : UITextField = {
        return UITextField().createLoginTextField(placeholder: "Fullname", isSecure: false, keyboardType: .default)
    }()
    
    private let usernameTextField : UITextField = {
        return UITextField().createLoginTextField(placeholder: "Username", isSecure: false, keyboardType: .default)
    }()
    
    private let emailTextField : UITextField = {
        return UITextField().createLoginTextField(placeholder: "Email", isSecure: false, keyboardType: .emailAddress)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().createLoginTextField(placeholder: "Password", isSecure: true, keyboardType: .twitter)
    }()
    
    private lazy var  fullnameContainer : UIView = {
        return UIView().loginContainer(image: Constants.person, textfield: fullNameTextField)
    }()
    
    private lazy var  usernameContainer : UIView = {
        return UIView().loginContainer(image: Constants.person, textfield: usernameTextField)
    }()
    
    private lazy var emailContainer : UIView = {
        return UIView().loginContainer(image: Constants.envelope, textfield: emailTextField)
    }()
    
    private lazy var  passwordContainer : UIView = {
        return UIView().loginContainer(image: Constants.lock, textfield: passwordTextField, showPassButton: eyeButton)
    }()
    
    private let eyeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.eye), for: .normal)
        button.tintColor = .mainPurple
        button.addTarget(self , action: #selector(togglePassword), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
        return button
    }()
    
    private let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainPurple
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.7
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self , action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString().attributedText(withText: "Already have an account? ", andBoldText: "Login", color: .white), for: .normal)
        button.addTarget(self , action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePickerDelegates()
        configure()
    }

//MARK: - API
    
    

//MARK: - Helper Functions
    
    
    func configure(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
    
        view.addSubview(profilePhotoView)
        profilePhotoView.centerX(inview: view)
        profilePhotoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20, width: 120, height: 120)
        profilePhotoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        
        view.addSubview(fullnameContainer)
        fullnameContainer.anchor(top: profilePhotoView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24, height: 50)
        
        view.addSubview(usernameContainer)
        usernameContainer.anchor(top: fullnameContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24, height: 50)

        view.addSubview(emailContainer)
        emailContainer.anchor(top: usernameContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24, height: 50)

        view.addSubview(passwordContainer)
        passwordContainer.anchor(top: emailContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24, height: 50)

        view.addSubview(signupButton)
        signupButton.anchor(top: passwordContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24, height: 50)

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 8)
        
        fullNameTextField.addTarget(self , action: #selector(signupFormChange), for: .editingChanged)
        usernameTextField.addTarget(self , action: #selector(signupFormChange), for: .editingChanged)
        emailTextField.addTarget(self , action: #selector(signupFormChange), for: .editingChanged)
        passwordTextField.addTarget(self , action: #selector(signupFormChange), for: .editingChanged)
    }
    

//MARK: - Selectors
    
    
    @objc func handleRegister(){
        guard let fullname = fullNameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let image = image else {
            let alert = UIAlertController().createSimpleAlert(title: "Error", message: "Please select a profile image")
            present(alert, animated: true)
            return
        }
        showHUD(true, with: "Registering your user")
        
        let credentials = AuthCredentials(email: email, fullname: fullname, username: username, password: password, profileImage: image)
        
        AuthService.shared.registerUser(withCredentials: credentials) { databaseError in
            if let error = databaseError{
                self.showHUD(false)
                print("DEBUG: Error in database try again later... \(error.localizedDescription)")
                return
            }
        } authCompletion: { result, authError in
            if let error = authError{
                self.showHUD(false)
                print("DEBUG: Error in authentication try again later... \(error.localizedDescription)")
                return
            }
            print("DEBUG: Sucess register user")
            self.showHUD(false)
            guard let uid = result?.user.uid else {return}
            self.delegate?.authenticateComplete(forUid: uid)
        }
       
    }
    
    @objc func handleAlreadyHaveAccount(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSelectPhoto(){
        present(imagePicker, animated: true)
    }
    
    @objc func signupFormChange(sender:UITextField){
        switch sender {
            case emailTextField: signupViewModel.email = sender.text
            case fullNameTextField: signupViewModel.fullname = sender.text
            case usernameTextField: signupViewModel.username = sender.text
            case passwordTextField: signupViewModel.password = sender.text
            default:break
        }
        checkAuthenticateStatus()
    }
    
    @objc func togglePassword(){
        passwordTextField.isSecureTextEntry.toggle()
    }
    
}

//MARK: - Image Picker Delegate

extension SignupController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func setImagePickerDelegates(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.image = profileImage
        profilePhotoView.layer.masksToBounds = true

        profilePhotoView.layer.borderColor = UIColor.white.cgColor
        profilePhotoView.layer.borderWidth = 3
        profilePhotoView.layer.cornerRadius = 120 / 2

        profilePhotoView.image = profileImage

        
        dismiss(animated: true)
    }
}
//MARK: - AuthenticateControllerProtocol

extension SignupController:AuthenticateControllerProtocol{
    func checkAuthenticateStatus() {
        if signupViewModel.formIsValid{
            signupButton.isEnabled = true
            signupButton.alpha = 1
        } else {
            signupButton.isEnabled = false
            signupButton.alpha = 0.7
        }
    } 
}


