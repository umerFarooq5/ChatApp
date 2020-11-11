//
//  ContactCell.swift
//  TeekyTalk
//
//  Created by umer malik on 04/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Kingfisher
class ContactCell: UITableViewCell {
    
    var user : User? {
        didSet {
            configure()

        }
    }
    
    
    func configure() {
        contactLbl.text = user?.name
        guard let uid = user?.userUid else { return }
        api.getImages(uid: uid) { (user) in
            self.contactImg.kf.setImage(with:  URL(string: user.PROFILE_IMAGE), placeholder: UIImage(named: "adduser"))
        }
    }
    
    
    let contactLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "name"
        lbl.textAlignment = .center
        return lbl
    }()
  
    let contactImg : UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()

    
    
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)

    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.yellow
    selectedBackgroundView = backgroundView
    constraints()
   
  
    
    
    }

    
    
    
    
    
     func constraints() {
      
        
        addSubview(contactImg)
        contactImg.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(contactLbl)
        contactLbl.anchor(top: topAnchor, left: contactImg.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)

      
    }
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
}
