//
//  FBase.swift
//  TeekyTalk
//
//  Created by umer malik on 24/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import Foundation
import Firebase

class api  {


    // registered the user with firebase
    static func register(email: String , password : String, errorCompletion: @escaping () -> (), completion: @escaping () -> ()) {
        AUTH.createUser(withEmail: email, password: password) { (result, Error) in
            
            if let error = Error { print(error.localizedDescription)
                errorCompletion()
                return
            } else {
                completion()
            }
        }
    }
    
    
    // Add a contact to your own contact list by filtering through the users that are signed up to the app if they exist the contact will be added
    static func addContact(email: String, names : String, uid : String ,noUserCompletion : @escaping () -> (),completion : @escaping () -> ()) {
        
        guard let currentEmail = AUTH.currentUser?.email else {return}
        
        COLLECTION_APP_USERS.whereField("email", isEqualTo: email).getDocuments { (snapshot, Error) in
            if let er = Error {
                print(er.localizedDescription)
                
                return
            } else {
                
                guard  let snap  = snapshot else {return}
                if snap.isEmpty  {
                    noUserCompletion()
                
                    
                } else {
                    
                    for snap in snap.documents {
                        let user = User(user: snap.data())
                        
                        let myContactsRef : DocumentReference
                        let data = ["email" : user.email, "userUid" : user.userUid ] as [ String : Any]
                        
                        
                        myContactsRef = COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).addDocument(data:data)
                        let docId =   myContactsRef.documentID
                        myContactsRef.updateData(["names" : names, "docId" : docId ])
                        
                        completion()
                    }
                }
            }
        }
    }
    
    
    // Fetch the contacts that are saved for your account
    static func getMyContacts(completion : @escaping ([User]) -> Void) {
        
        var users = [User]()
        guard let currentEmail = AUTH.currentUser?.email else {return}
        
        COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).addSnapshotListener { (snapshot, Error) in
            if let er = Error {
                
                print(er.localizedDescription)
            } else {
                
                users.removeAll()
                snapshot?.documentChanges.forEach{ (change) in
                    let myContact = User(user: change.document.data())
                    users.append(myContact)
                }
            }
            completion(users)
        }
    }
    
    
    
    // Update your profile image that is saved on firebase storage
    static func updateimageUrl(data: Data, currentUid : String, completion : @escaping () -> ()) {
        guard let currentEmail = AUTH.currentUser?.email else {return}
        
        let imageRef = Storage.storage().reference(withPath: "profileImage\(currentUid)")
        
        imageRef.putData(data, metadata: nil) { (meta , error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            imageRef.downloadURL { (URL, Error) in
                
                guard let url = URL?.absoluteString else {return}
                let refrence = COLLECTION_APP_USERS.document(currentUid)
                
                refrence.setData([PROFILE_IMAGE : url], merge: true) { (Error) in
                    if let er = error {
                        
                        print(er.localizedDescription)
                        return
                    } else {
                        COLLECTION_USER_IMAGES.document(currentEmail).setData(["userEmail" : currentEmail, PROFILE_IMAGE : url])
                        
                        completion()
                    }
                }
            }
        }
    }
    
    
    
    
    static func signin(email: String , password : String, errorCompletion: @escaping () -> (), completion: @escaping () -> () ) {
        
        AUTH.signIn(withEmail: email, password: password) { (result, Error) in
            if let error = Error {
                print(error.localizedDescription)
                errorCompletion()
                return
            } else {
                completion()
            }
        }
    }
    
    // when you register your account this also saves your details on the app users collection
    static func saveUser(data : [String : Any]) {
        guard let currentUid = AUTH.currentUser?.uid else {return}
        COLLECTION_APP_USERS.document(currentUid).setData(data)
    }
    
    
    static func logout(completion: @escaping () -> ()) {
        print(" successfully logged out")
        do {
            try AUTH.signOut()
            
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    static func ifUserNotLoggedIn(completion: @escaping () -> ()) {
        if AUTH.currentUser == nil {
            completion()
        }
    }
    
    
    static func saveMessage(message: String, user: User,  completion: () -> ()) {
        
        guard let currentUid = AUTH.currentUser?.uid else {return}
        
        let data = ["message" : message, "fromId" : currentUid, "toId" : user.userUid, "timestamp" : Timestamp(date: Date())] as [ String : Any]
        // this will also be able to create the document ID which we can put into the data that we are going to save so we can manage the document using the document ID whenever we need it
        let currentUserRef : DocumentReference
        let contactUserRef : DocumentReference
        let currentRecentMsg : DocumentReference
        let contactUserRecentMsg2 : DocumentReference
        
        currentUserRef = COLLECTION_MESSAGES.document(currentUid).collection(user.userUid).addDocument(data: data) { _ in
            
        }
        
        currentRecentMsg =  COLLECTION_MESSAGES.document(currentUid).collection(RECENT_MESSAGES).document(user.userUid)
        
        currentRecentMsg.setData(data)
        let id = currentRecentMsg.documentID
        currentRecentMsg.updateData([DOC_ID : id])
        
        contactUserRef = COLLECTION_MESSAGES.document(user.userUid).collection(currentUid).addDocument(data: data) { _ in
        }
        
        contactUserRecentMsg2 = COLLECTION_MESSAGES.document(user.userUid).collection(RECENT_MESSAGES).document(currentUid)
        
        contactUserRecentMsg2.setData(data)
        let id2 = contactUserRecentMsg2.documentID
        contactUserRecentMsg2.updateData([DOC_ID : id2])
        
        let docId = currentUserRef.documentID
        currentUserRef.updateData([DOC_ID: docId])
        
        let docId2 = contactUserRef.documentID
        contactUserRef.updateData([DOC_ID : docId2])
        
        
        completion()
        
    }
    
    
    static func fetchMessages(users: User, completion: @escaping ([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = AUTH.currentUser?.uid else {return}
       
        COLLECTION_MESSAGES.document(currentUid).collection(users.userUid).order(by: "timestamp", descending: false).addSnapshotListener {
            (snapshot, Error) in
            if let er = Error {
                print(er.localizedDescription)
            } else {
                snapshot?.documentChanges.forEach({ (change) in
                    
                    if change.type == .added {
                        
                        let messsage = Message(dictionary: change.document.data())
                        
                        messages.append(messsage)
                        completion(messages)
                    }
                })
            }
        }
    }
    
    // this will fetch an individual user this is used when sending and receiving messages because each message will have the user UID saved, we will use that to fetch an individual user
    static func fetchUser(uid: String,comp:  @escaping(User) -> Void) {
        COLLECTION_APP_USERS.document(uid).getDocument { (DocumentSnapshot, Error) in
            guard let data = DocumentSnapshot?.data() else {return}
            let user = User(user: data)
            comp(user)
        }
    }
    
    
    static func recentMessages(completion: @escaping([Conversation]) -> Void)    {
        
        var conversation = [Conversation]()
        guard let currentUid = AUTH.currentUser?.uid else {return}
        
        COLLECTION_MESSAGES.document(currentUid).collection(RECENT_MESSAGES).order(by: "timestamp", descending: false).addSnapshotListener { (QuerySnapshot, Error) in
            QuerySnapshot?.documentChanges.forEach { (change) in
                if change.type == .added {
                    let message = Message(dictionary: change.document.data())
                    if !message.DOC_ID.isEmpty {
                        
                        self.fetchUser(uid: message.DOC_ID) { user in
                            let convo = Conversation(message: message, user: user)
                            conversation.append(convo)
                            completion(conversation)
                        }
                    }
                }
            }
        }
        

    }
    
    
    // get the users image
    static func getImages(uid: String, completion: @escaping(User) -> Void ) {
        COLLECTION_APP_USERS.document(uid).getDocument { (DocumentSnapshot, Error) in
            guard let data = DocumentSnapshot?.data() else {return}
            let userImage = User(user: data)
            print(userImage.PROFILE_IMAGE)
            completion(userImage)
        }
    }
    
    
    static func IfBlocked(currentUid: String, userUid: String, com: @escaping() -> Void,  com2: @escaping() -> Void) {
        
        COLLECTION_BLOCKED.document(currentUid).collection(BLOCKED_USERS).document(userUid).addSnapshotListener { (Snapshot, Error) in
            guard let data = Snapshot?.data() else {return}
            let user = Blocked(dictionary: data)
            if user.isBlocked == true {
             //   If you have been blocked or you have blocked the user this will be called and in each case completion we decide what we wish to happen
                com()
            }
        }
        
        COLLECTION_BLOCKED.document(userUid).collection(BLOCKED_USERS).document(currentUid).addSnapshotListener { (Snapshot, Error) in
            guard let data = Snapshot?.data() else {return}
            let user = Blocked(dictionary: data)
            if user.isBlocked == true {
                
                com2()
            }
        }
        
    }
    
    
    static func deleteAllContacts() {
        guard let currentEmail = AUTH.currentUser?.email else {return}
        
        COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).getDocuments { (Snapshot, Error) in
            guard let data = Snapshot?.documents else {return}
            for data in data {
                let user = User(user: data.data())
                COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).document(user.DOC_ID).delete()
                
            }
        }
    }
    
    
    static func deleteMyImage() {
        guard let currentUid = AUTH.currentUser?.uid else {return}
        
        let imageRef = Storage.storage().reference(withPath: "profileImage\(currentUid)")
        imageRef.delete { Error in
            if let error = Error {
                print(error)
            } else {
                print("successfully deleted image")
            }
        }
    }
    
    
  static func deleteMessages(currentUid: String, docId: String) {
       
    COLLECTION_MESSAGES.document(currentUid).collection(docId).getDocuments { (snapshot, Error) in

            if let er = Error {
                print(er)
            } else {
                guard let snapshot = snapshot?.documents else {return}
                for snap in snapshot {
                    
                    let message = Message(dictionary: snap.data())
                    COLLECTION_MESSAGES.document(currentUid).collection(RECENT_MESSAGES).document(docId).delete()
                    COLLECTION_MESSAGES.document(currentUid).collection(docId).document(message.DOC_ID).delete()
                }
            }
        }
    }
   
    
    static func deleteRecentMessages() {

        guard let currentUid = AUTH.currentUser?.uid else {return}

        COLLECTION_MESSAGES.document(currentUid).collection(RECENT_MESSAGES).getDocuments { (Snapshot, Error) in
            guard let data = Snapshot?.documents else {return}
            
            for data in data {
                let message = Message(dictionary: data.data())
                COLLECTION_MESSAGES.document(currentUid).collection(RECENT_MESSAGES).document(message.DOC_ID).delete()
            }
        }

    }
    
    
    static func deleteUsersAndImages() {
        guard let currentUid   = AUTH.currentUser?.uid     else {return}
        guard let currentEmail = AUTH.currentUser?.email   else {return}
        
        COLLECTION_APP_USERS.document(currentUid).delete()
        COLLECTION_USER_IMAGES.document(currentEmail).delete()
    }
    
    static func handleDeleteContact(currentEmail: String, userEmail: String) {
        
        COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, Error) in
            
            guard let data =  snapshot?.documents else {return}
            for data in data {
                let user = User(user: data.data())
                COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).document(user.DOC_ID).delete()
            }
        }
    }
    
    static func updatename(docId: String, withName: String, completion: @escaping () -> ()) {
        guard let currentEmail = AUTH.currentUser?.email else {return}

        COLLECTION_MYCONTACTS.document(currentEmail).collection(DETAILS).document(docId).updateData(["names" : withName])

        completion()
    }
    
    
    static func checkIfBlocked(currentUid: String, userUid: String, completion: @escaping (Blocked) -> Void) {
        COLLECTION_BLOCKED.document(currentUid).collection(BLOCKED_USERS).document(userUid).addSnapshotListener { (DocumentSnapshot, Error) in
            
            guard let data = DocumentSnapshot?.data() else {return}
            let user = Blocked(dictionary: data)
            completion(user)
        }
    }
    
    static func block(uid: String, userUid: String, ifTrue: Bool) {
        if ifTrue == true {
            
            COLLECTION_BLOCKED.document(uid).collection(BLOCKED_USERS).document(userUid).setData( ["uid" : userUid, "isBlocked" : true])
        } else {
            COLLECTION_BLOCKED.document(uid).collection(BLOCKED_USERS).document(userUid).setData( ["uid" : userUid, "isBlocked" : false])

        }

    }
   
}




