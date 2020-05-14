//
//  SignUpVC.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    var currentPick = "Ticketmaster"
    var pickerOptions = ["Ticketmaster","Rijksmuseum"]
    //MARK: - UIObjects
    lazy var SignUpLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "SignUp"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Verdana", size: 30)
        return label
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 5
        return textField
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create account", for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveUser), for: .touchUpInside)
        return button
    }()
    lazy var apiPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 5
        return picker
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually

        return stackView
    }()
    lazy var pickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Select an API to use for this account"
        label.numberOfLines = 0
        label.font = UIFont(name: "verdana", size: 20)
        label.textAlignment =  .center
        label.textColor = .white
        return label
    }()
    
    //MARK: - Regular Functions
    private func setUpView(){
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        setUpSignUpLogoLabel()
        setUpStackView()
        setUpPickerLabel()
        setUpPicker()
        
    }
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    //    MARK: - Objc Functions
    @objc private func saveUser(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Oops", message: "Please fill out all fields")
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
        FirebaseAuthService.manager.CreateAuthUser(email: email, password: password) { (result) in
            switch result{
            case .failure(let error):
                self.showAlert(title: "Error creating user", message: "An error occured while creating new account \(error)")
            case .success(let user):
                FirestoreService.manager.SaveUser(user: AppUser(from: user)) { (result) in
                    switch result{
                    case .failure(let error):
                        self.showAlert(title: "Error saving user", message: "\(error)")
                    case .success():
                        print("saved")
                        self.handleCreatedUserInFirestore(result: result)
                    }
                }
            }
        }
    }
    private func handleCreatedUserInFirestore(result: Result<(), Error>) {
        switch result {
        case .success:
            FirebaseAuthService.manager.updateUserFields(experience: currentPick) { (result) in
                switch result{
                case .failure(let error):
                    self.showAlert(title: "Error", message: "\(error)")
                case .success(()):
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
            
        case .failure(let error):
            self.showAlert(title: "Error creating user", message: "An error occured while creating new account \(error)")
        }
    }

     
     
    
    //MARK: - Constraints
    private func setUpSignUpLogoLabel(){
        view.addSubview(SignUpLogoLabel)
        SignUpLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            SignUpLogoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            SignUpLogoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            SignUpLogoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            SignUpLogoLabel.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
    }
    private func setUpStackView(){
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80)
        ])
    }
    
    private func setUpPickerLabel(){
        view.addSubview(pickerLabel)
        pickerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerLabel.topAnchor.constraint(equalTo: SignUpLogoLabel.bottomAnchor, constant: 50),
            pickerLabel.heightAnchor.constraint(equalToConstant: 30),
            pickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    private func setUpPicker(){
        view.addSubview(apiPicker)
        apiPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            apiPicker.topAnchor.constraint(equalTo: pickerLabel.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            apiPicker.heightAnchor.constraint(equalToConstant: 80),
            apiPicker.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0)
        ])
    }
}

//MARK: - UIPicker Delegate
extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = pickerOptions[row]
        return row
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPick = pickerOptions[row]
    }
    
}
