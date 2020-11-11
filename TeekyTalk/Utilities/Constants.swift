//
//  Constants.swift
//  TeekyTalk
//
//  Created by umer malik on 21/10/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import Foundation
import Firebase


let AUTH = Auth.auth()
let db = Firestore.firestore()

let COLLECTION_MYCONTACTS   = db.collection("myContacts")
let COLLECTION_USER_IMAGES  = db.collection("userImages")
let COLLECTION_APP_USERS    = db.collection("appUsers")
let COLLECTION_MESSAGES     = db.collection("messages")
let COLLECTION_BLOCKED      = db.collection("blocked")


let RECENT_MESSAGES         = "RECENT_MESSAGES"
let PROFILE_IMAGE           = "PROFILE_IMAGE"
let DOC_ID                  = "DOC_ID"
let BLOCKED_USERS           = "BLOCKED_USERS"
let DETAILS                 = "DETAILS"
