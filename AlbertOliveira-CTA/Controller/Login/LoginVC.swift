//
//  LoginVC.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    //MARK: - UIObjects
    lazy var loginLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "CTA Project"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Verdana", size: 30)
        return label
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.backgroundColor = .white
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        return button
    }()
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account?  ",
                                                        attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!,
                                                                     NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up",attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!,
                                                                                 NSAttributedString.Key.foregroundColor:  UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - Objc Functions
     @objc private func loginUser(){
         guard let email = emailTextField.text, let password = passwordTextField.text else {
                   showAlert(title: "Error", message: "Please fill out all fields.")
                   return
               }
               guard email.isValidEmail else {
                   showAlert(title: "Error", message: "Please enter a valid email")
                   return
               }
               guard password.isValidPassword else {
                   showAlert(title: "Error", message: "Please enter a valid password. Passwords must have at least 8 characters.")
                   return
               }
         FirebaseAuthService.manager.loginUser(email: email, password: password) { (result) in
               self.handleLoginResponse(with: result)
         }
     }
     @objc private func showSignUp(){
         let signupVC = SignUpVC()
         signupVC.modalPresentationStyle = .formSheet
         present(signupVC, animated: true, completion: nil)
     }
         
    //MARK: - Regular Functions
    private func setUpView(){
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        setUpLoginLabel()
        setUpStackView()
    }
    
      private func showAlert(title: String, message: String) {
          let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          present(alertVC, animated: true)
    }
    
       private func handleLoginResponse(with result: Result<(), Error>) {
           switch result {
           case .failure(let error):
               showAlert(title: "Error", message: "Could not log in. Error: \(error)")
           case .success:
               guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                   else {
                       return
               }
               UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                   window.rootViewController = UserTabBarVC()
               }, completion: nil)
           }
       }
    
    //MARK: - Constraints
    private func setUpLoginLabel(){
        view.addSubview(loginLogoLabel)
        loginLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginLogoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            loginLogoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loginLogoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            loginLogoLabel.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
    }
    private func setUpStackView(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, createAccountButton])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80)
        ])
    }
}
