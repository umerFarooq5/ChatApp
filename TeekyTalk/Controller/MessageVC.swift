//
//  MessageVC.swift
//  TeekyTalk
//
//  Created by umer malik on 14/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
// 

import UIKit
import FirebaseFirestore
import Firebase

class MessageVC: UIViewController, UITextViewDelegate {
    
    var user : User?
    var myMessage = [Message]()
    
    
    let topView : UIView = {
        let view = UIView()
        return view
    }()
    
    
    let cancelBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("cancel", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return btn
    }()
    
    
//    let addBtn : UIButton = {
//        let btn = UIButton()
//        btn.setImage(.add, for: .normal)
//        btn.setTitleColor(.gray, for: .normal)
//        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
//        return btn
//    }()
//
    
    let nameLbl : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    

    var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MessageCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        return cv
    }()
    
    
    let bottomContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    let messsage : UITextView = {
        let message = UITextView()
        message.backgroundColor = .lightGray
        message.layer.cornerRadius = 5
        message.font = UIFont.systemFont(ofSize: 19)
        return message
    }()
    
    
    let sendButton : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.setImage(UIImage(named: "send"), for: .normal)
        btn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return btn
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraints()
        
        messsage.delegate = self
        cv.delegate = self
        cv.dataSource = self
        
        hideKeyboardWhenTappedAround(addedTo: cv)
        fetchMessage()
        keyboardNotifications()

    }
        

    func textViewDidBeginEditing(_ textView: UITextView) {
        messsage.becomeFirstResponder()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        checkIfBlocked()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    
    func checkIfBlocked() {
        guard let uid = AUTH.currentUser?.uid else {return}
        guard let userUid = user?.userUid else {return}
        api.IfBlocked(currentUid: uid, userUid: userUid) {
            self.showAlert(textToShow: "you have blocked this user") {
                self.dismiss()
            } cancelCom: {
                self.dismiss()
            }
            
        } com2: {
            self.showAlert(textToShow: "you cannot contact this user") {
                self.dismiss()
            } cancelCom: {
                self.dismiss()
            }
        }
    }
    
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    
    func fetchMessage() {
        guard let contact = self.user else {return}
        api.fetchMessages(users: contact) { messages in
            self.myMessage = messages
            self.cv.reloadData()
            self.scrollToBtm()
        }
    }
    
    
    @objc func handleCancel() {
//        self.dismiss(animated: true)
        self.dismiss()

        
    }
    
    
    @objc func handleSend() {
        guard let contact = user else {return}
        guard let message = messsage.text else {return}
        
        if !message.isEmpty {
            api.saveMessage(message: message, user: contact) {
                self.messsage.text = ""
                self.view.endEditing(true)
                scrollToBtm()
            }
       
        } else {
            self.view.endEditing(true)
        }
    }
    

    func scrollToBtm()  {
        let item = self.collectionView(self.cv, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.cv.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
    }


}



extension MessageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myMessage.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MessageCell
        cell.messagess = myMessage[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        let  estimatedSize = MessageCell(frame: frame)
        estimatedSize.label.text = myMessage[indexPath.item].message
        estimatedSize.layoutIfNeeded()
        
        let target = CGSize(width: view.frame.width, height: 1000)
        let size = estimatedSize.systemLayoutSizeFitting(target)
        return .init(width: view.frame.width, height: size.height)
    }
    
        
}


extension MessageVC {
    
    func constraints() {
        view.addSubview(bottomContainer)
        bottomContainer.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor, height: 60)
        
        bottomContainer.addSubview(messsage)
        messsage.anchor(top: bottomContainer.topAnchor, left: bottomContainer.leftAnchor, bottom: bottomContainer.bottomAnchor, right: bottomContainer.rightAnchor, paddingTop: 8, paddingLeft: 10, paddingBottom: 8, paddingRight: 50)
        
        bottomContainer.addSubview(sendButton)
        sendButton.anchor(top: bottomContainer.topAnchor, left: messsage.rightAnchor, bottom: bottomContainer.bottomAnchor, right: bottomContainer.rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        view.addSubview(topView)
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor , right: view.rightAnchor, height: 40)
       
        topView.addSubview(nameLbl)
        topView.addSubview(cancelBtn)
       
        cancelBtn.anchor(top: topView.topAnchor, bottom: topView.bottomAnchor, right: topView.rightAnchor, width: 80)
        
        view.addSubview(cv)
        cv.anchor(top: topView.bottomAnchor , left: view.leftAnchor, bottom: bottomContainer.topAnchor, right: view.rightAnchor, paddingBottom: 10)
        
    }
    
    
}
