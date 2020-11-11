//
//  Message.swift
//  TeekyTalk
//
//  Created by umer malik on 07/10/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import Firebase

struct Message {
    
    var message    : String
    var DOC_ID      : String
    let toId       : String
    let fromId     : String
    var timestamp  : Timestamp!
    var user       : User?
    
    let isFromCurrentUser : Bool
    
    init(dictionary: [String : Any]) {
        self.message   = dictionary["message"]     as? String ?? ""
        self.DOC_ID     = dictionary["DOC_ID"]       as? String ?? ""
        self.toId      = dictionary["toId"]        as? String ?? ""
        self.fromId    = dictionary["fromId"]      as? String ?? ""
        self.timestamp = dictionary["timestamp"]   as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == AUTH.currentUser?.uid
    }
    
    
}


struct Conversation {
    let message: Message
    let user: User
}


struct Blocked {
    let userUid : String
    let isBlocked : Bool 
    
    init(dictionary: [String : Any]) {
        self.userUid   = dictionary["userUid"]     as? String ?? ""
        self.isBlocked   = dictionary["isBlocked"]     as? Bool ?? false
        
    }
    
}

