//
//  SettingsVC.swift
//  TeekyTalk
//
//  Created by umer malik on 15/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    let profileImg : UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 1
        iv.layer.cornerRadius =  150 / 2
        iv.backgroundColor = .yellow
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let addImgBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("add Image", for: .normal)
        btn.backgroundColor = .yellow
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleimagePicker), for: .touchUpInside)
        return btn
    }()
    
    
    let deleteBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("delete account", for: .normal)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 5
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return btn
    }()
    
    
    var logoutBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("logout", for: .normal)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 5
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return btn
    }()
    
    
    func setPicker() {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true)
    }
    
    
    @objc func handleimagePicker() {
        setPicker()
    }
    
    
    @objc func handleLogout() {
        api.logout {
            let loginVC = TabVC()
            self.present(loginVC, animated: true)
        }
    }
    
    
    @objc func handleDelete() {
        
        showAlert(textToShow: "your account will be deleted immediately") {
            let user = AUTH.currentUser
            api.deleteAllContacts()
            api.deleteMyImage()
            api.deleteRecentMessages()
            api.deleteUsersAndImages()
            
            user?.delete(completion: { Error in
                if let error = Error {
                    print(error)
                } else {
                    let contactsVC = ContactsVC()
                    self.present(contactsVC, animated: true)
                }
            })
        } cancelCom: {}
     
    }
    
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let currentUid = AUTH.currentUser?.uid else {return}
        let imageToShow = info[.originalImage] as! UIImage
        guard let imageData = imageToShow.jpegData(compressionQuality: 0.4) else {return}
        
        imagePicker.dismiss(animated: true, completion: nil)
        api.updateimageUrl(data: imageData, currentUid: currentUid) {
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       constraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let currentUid = AUTH.currentUser?.uid else {return}
        api.getImages(uid: currentUid) { user in
            self.profileImg.kf.setImage(with:  URL(string: user.PROFILE_IMAGE))

        }
    }
    
    
    
    
    func constraints() {
        
        view.backgroundColor = .black
        
        view.addSubview(profileImg)
        profileImg.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10, width: 150, height: 150)
        profileImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(addImgBtn)
        addImgBtn.anchor(top: profileImg.bottomAnchor, paddingTop: 20, width: 150, height: 30)
        addImgBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(deleteBtn)
        deleteBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, width: 150, height: 30)
        deleteBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(logoutBtn)
        logoutBtn.anchor(bottom: deleteBtn.topAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 150, height: 30)
        logoutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}

