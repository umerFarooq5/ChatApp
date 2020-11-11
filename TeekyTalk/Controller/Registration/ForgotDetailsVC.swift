//
//  ForgotDetailsVC.swift
//  TeekyTalk
//
//  Created by umer malik on 22/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit

class ForgotDetailsVC: UIViewController {

    // additional work to reset password still needs to be done
    let infolabel : UILabel = {
        let label = UILabel()
        label.text = "enter your email and we will send you a reset link"
        label.font = UIFont(name: "chalkDuster", size: 20)
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    let titlelabel : UILabel = {
        let label = UILabel()
        label.text = "forgot your details ?"
        label.font = UIFont(name: "chalkDuster", size: 80)
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    
    let emailTextfield  : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "email"
        textfield.textAlignment = .center
        textfield.backgroundColor = .white
        textfield.layer.cornerRadius = 5
        return textfield
    }()
    
    let resetButton : UIButton = {
        let button = UIButton()
        button.setTitle("reset", for: .normal)
        button.titleLabel?.font = UIFont(name: "chalkDuster", size: 20)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleDismisss), for: .touchUpInside)
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
    
    let DismissButton : UIButton = {
        let button = UIButton()
        button.setTitle("back", for: .normal)
        button.addTarget(self, action: #selector(handleDismisss), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        constraints()
        hideKeyboardWhenTappedAround(addedTo: view)
    }
    
    
    @objc func handleDismisss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ForgotDetailsVC {
    
    func constraints() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(DismissButton)
        view.addSubview(stack)
        
        stack.addSubview(infolabel)
        stack.addArrangedSubview(emailTextfield)
        stack.addArrangedSubview(resetButton)
        
        stack.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 80, paddingBottom: 10, paddingRight: 80, height: 100)
        
        infolabel.anchor(left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor, paddingBottom: 30, height: 80)
        
        DismissButton.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, width: 40, height: 50)
    }
    
    
}
