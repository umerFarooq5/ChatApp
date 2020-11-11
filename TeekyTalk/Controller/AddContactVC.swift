//
//  AddContactVC.swift
//  TeekyTalk
//
//  Created by umer malik on 24/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Firebase
class AddContactVC: UIViewController, UITextFieldDelegate {
    
    let names : UITextField = {
        let lbl = UITextField()
        lbl.layer.cornerRadius = 5
        lbl.font = UIFont.systemFont(ofSize: 19)
        lbl.placeholder = "name"
        lbl.textAlignment = .center
        return lbl
    }()
    
    let email : UITextField = {
        let email = UITextField()
        email.layer.cornerRadius = 5
        email.font = UIFont.systemFont(ofSize: 19)
        email.placeholder = "email"
        email.textAlignment = .center
        return email
    }()
    
    
    let addBtn : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.setTitle("add", for: .normal)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(handleAddBtn), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "add contact"
        constraints()
        
    }
    
    
    
    @objc func handleAddBtn() {
        
        guard let email = email.text else {return}
        guard let name = names.text else {return}
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        api.addContact(email: email, names: name, uid: currentUid) {
            
            self.showAlert(textToShow: "Hey doesn't look like there is a user with that email check your details again please", com: { }, cancelCom: {}  )
            
        } completion: {
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}



extension AddContactVC {
    
    func constraints() {
        
        view.addSubview(names)
        names.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 10, width: 250, height: 35)
        
        view.addSubview(email)
        email.anchor(top:  names.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 250, height: 35)
       
        view.addSubview(addBtn)
        addBtn.anchor(top: email.bottomAnchor, left: view.leftAnchor ,paddingTop: 10, paddingLeft: 10, paddingRight: 0,width: 150,  height: 30)
        
    }
}
