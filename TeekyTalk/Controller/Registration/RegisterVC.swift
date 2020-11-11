//
//  RegisterVC.swift
//  TeekyTalk
//
//  Created by umer malik on 22/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class RegisterVC: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        constraints()
        hideKeyboardWhenTappedAround(addedTo: view)
    }
    
    
    
    
    
    let DismissButton : UIButton = {
        let button = UIButton()
        button.setTitle("login", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    let titlelabel : UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.font = UIFont(name: "chalkDuster", size: 60)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    
    let registerlabel : UILabel = {
        let label = UILabel()
        label.text = "Register"
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
        textfield.layer.cornerRadius = 5
        textfield.autocorrectionType = .no

        return textfield
    }()
    
    
    let passwordTextfield  : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "password"
        textfield.textAlignment = .center
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 5
        textfield.autocorrectionType = .no

        return textfield
    }()
    
    
    let nameTextfield  : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "name "
        textfield.textAlignment = .center
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 5
        return textfield
    }()
    
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("register", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let stack : UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.distribution = .fillEqually
        s.axis = .vertical
        s.spacing = 15
        return s
    }()
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleRegister() {

        guard  let email = emailTextfield.text?.lowercased() else {return}
        guard  let password = passwordTextfield.text else {return}
        view.endEditing(true)

        if isValidEmail(email: email) == false {
            showAlert(textToShow: "not a valid email") { } cancelCom: {}
            return
        } else {
            if isValidPassword(password: password) == false {
                showAlert(textToShow: "Password must contain eight characters including uppercase letter and number") {
                } cancelCom: {}
                passwordTextfield.text = ""
                return
            } else {
                // create a new user
                api.register(email: email, password: password, errorCompletion: {
                    
                }) {
                    guard let userUid = Auth.auth().currentUser?.uid else {
                        print("no")
                        return
                    }
                    let data = ["email" : email,  "userUid" : userUid] as [String : Any]
                    api.saveUser(data: data)
                    
                    let VC = TabVC()
                    VC.modalPresentationStyle = .fullScreen
                    self.present(VC, animated: true)
                }
            }
        }
    }
    

}




extension RegisterVC {
    
    func constraints() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(stack)
        view.addSubview(DismissButton)
        
        stack.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 50, paddingBottom: 10, paddingRight: 50, height: 250)
        
        stack.addArrangedSubview(registerlabel)
        stack.addArrangedSubview(emailTextfield)
        
        stack.addArrangedSubview(passwordTextfield)

                stack.addArrangedSubview(registerButton)
        
        //     titlelabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //
        
        DismissButton.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 10, paddingLeft: 5, width: 40, height: 50)
    }
    
    
}
