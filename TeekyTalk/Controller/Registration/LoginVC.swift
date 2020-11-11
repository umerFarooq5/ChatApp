//
//  LoginVC.swift
//  TeekyTalk
//
//  Created by umer malik on 22/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        constraints()
        hideKeyboardWhenTappedAround(addedTo: view)
    }
    
    
    
    let titlelabel : UILabel = {
        let label = UILabel()
        label.text = "TeekyTalk"
        label.font = UIFont(name: "chalkDuster", size: 50)
        label.textAlignment = .center
        label.textColor = .systemGreen
        return label
    }()
    
    let loginlabel : UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont(name: "chalkDuster", size: 30)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    let emailTextfield  : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "email"
        textfield.textAlignment = .center
        textfield.backgroundColor = .white
        textfield.autocorrectionType = .no
        textfield.layer.cornerRadius = 5
        return textfield
    }()
    
    let passwordTextfield  : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "password"
        textfield.backgroundColor = .white
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 5
        textfield.autocorrectionType = .no
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    let forgotPasswordButton : UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.setTitle("  Forgot Password", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleForgot), for: .touchUpInside)
        return button
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont(name: "chalkDuster", size: 20)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let createAccountButton : UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "chalkDuster", size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    
    let stack : UIStackView = {
        let s = UIStackView()
        s.distribution = .fillEqually
        s.axis = .vertical
        s.spacing = 15
        return s
    }()
    
    
    @objc func handleLogin() {
        
        print("logging tapped")
        self.view.endEditing(true)
        guard let email = emailTextfield.text?.lowercased()  else {return}
        guard let password = passwordTextfield.text  else {return}
        
        api.signin(email: email, password: password , errorCompletion: {
            // handle error
            self.showAlert(textToShow: "please check your details looks like there's an error") {
                
            } cancelCom: {}
            
        }) {
            self.dismiss(animated: true)
        }
    }
    
    
    @objc func handleRegister() {
        print("handle Register tapped")
        self.view.endEditing(true)
        
        let registerVC = RegisterVC()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
    
    
    @objc func handleForgot() {
        self.view.endEditing(true)
        let forgotDetailsVC = ForgotDetailsVC()
        present(forgotDetailsVC, animated: true, completion: nil)
    }
    
}



extension LoginVC {
    
    
    func constraints() {
        
        // this just notifies us that is the keyboard is about to appear or disappear and then we can put the functions what we would like to be done in each case
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //---------------------------------------------------------------------------------------------------------------------------
        
        view.addSubview(stack)
        stack.addSubview(titlelabel)
        
        stack.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 50, paddingBottom: 10, paddingRight: 50, height: 320)
        
        stack.addArrangedSubview(loginlabel)
        stack.addArrangedSubview(emailTextfield)
        stack.addArrangedSubview(passwordTextfield)
        stack.addArrangedSubview(forgotPasswordButton)
        stack.addArrangedSubview(loginButton)
        stack.addArrangedSubview(createAccountButton)
        
        titlelabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor)
        
    }
    
}
