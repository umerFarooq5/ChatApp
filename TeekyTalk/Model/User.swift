//
//  File.swift
//  TeekyTalk
//
//  Created by umer malik on 20/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let name             : String
    let email            : String
    let PROFILE_IMAGE     : String
    let DOC_ID            : String
    let userUid          : String
    
    init(user: [String : Any]) {

        self.name = user["names"] as? String ?? ""
        self.email = user["email"] as? String ?? ""
        self.PROFILE_IMAGE = user["PROFILE_IMAGE"] as? String ?? ""
        self.DOC_ID = user["DOC_ID"] as? String ?? ""
        self.userUid = user["userUid"] as? String ?? ""

    }
}






