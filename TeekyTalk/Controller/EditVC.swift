//
//  EditVC.swift
//  TeekyTalk
//
//  Created by umer malik on 15/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Firebase


class EditVC: UIViewController {

    var user : User?

    let nameLbl : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        return lbl
    }()
    
    
    let emailLbl : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        return lbl
    }()
    
    
    let deleteBtn : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitle("Delete Contact", for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(handleDeleteBtn), for: .touchUpInside)
        return btn
    }()
    
    
    let blockBtn : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.setTitle("Block", for: .normal)
        btn.backgroundColor = .gray
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(handleBlockBtn), for: .touchUpInside)
        return btn
    }()
    
    
    let stack : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    
    
    let detailStack : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.distribution = .fillEqually
        return sv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.title = "edit contact"
        constraints()
        checkIfBlocked()
        setUserDetails()
     }
    
 
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func setUserDetails() {
        guard let user = self.user else {return}
        nameLbl.text = user.name
        emailLbl.text = user.email
    }
    
 
    func checkIfBlocked() {
        guard let currentUid = AUTH.currentUser?.uid else {return}
        guard let userUid = user?.userUid else {return}
        api.checkIfBlocked(currentUid: currentUid, userUid: userUid) { blocked in
            
            self.blockBtn.backgroundColor = blocked.isBlocked  == true  ? .red       :  .blue
            let show                      = blocked.isBlocked  == true ? "unblock"  :  "block"
            self.blockBtn.setTitle(show, for: .normal)
        }
    }
    
    
    @objc func handleEditBtn() {
        showUpdateNameAlert()
    }
    
    
    @objc func handleBlockBtn() {
        guard let uid = AUTH.currentUser?.uid else {return}
        guard let userUid = user?.userUid else {return}
        self.handleBlock(uid: uid, userUid: userUid)
    }
    
    
    func handleBlock(uid: String, userUid: String) {
        
        if blockBtn.backgroundColor == .gray || blockBtn.backgroundColor ==  .blue {
            api.block(uid: uid, userUid: userUid, ifTrue: true)
        } else {
            api.block(uid: uid, userUid: userUid, ifTrue: false)
        }
    }
    
    
    @objc func handleDeleteBtn() {
        self.handleDeleteContact {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func handleDeleteContact(completion : @escaping () -> ()) {
        guard let currentEmail = AUTH.currentUser?.email else {return}
        guard let userEmail = user?.email else {return}
        showAlert(textToShow: "are you sure you want to delete this contact") {
          
            api.handleDeleteContact(currentEmail: currentEmail, userEmail: userEmail)
            self.navigationController?.popViewController(animated: true)
            
        } cancelCom: {}
        
      
    }
    
        
    func showUpdateNameAlert() {
        guard let docId = user?.DOC_ID else {return}
       
        let alert = UIAlertController(title: "Update name", message: "", preferredStyle: .alert)
        let saveName = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
           
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            guard let name = textField.text else {return}
            api.updatename(docId: docId, withName: name, completion: {
                self.navigationController?.popViewController(animated: true)

            })
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in

            textField.placeholder = "enter new name"
        }
        alert.addAction(saveName)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
}



extension EditVC {
    
    func constraints() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditBtn))
        
        view.addSubview(stack)
        stack.addArrangedSubview(deleteBtn)
        stack.addArrangedSubview(blockBtn)
        stack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor , paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 30)
        
        view.addSubview(detailStack)
        detailStack.addArrangedSubview(nameLbl)
        detailStack.addArrangedSubview(emailLbl)
        detailStack.anchor(left: view.leftAnchor, bottom: stack.topAnchor, right: view.rightAnchor,paddingLeft: 10, paddingBottom: 50, paddingRight: 10, height: 70)
        
    }
}
