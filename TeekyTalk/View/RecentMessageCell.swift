//
//  RecentMessageCell.swift
//  TeekyTalk
//
//  Created by umer malik on 18/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

//
//  ContactCell.swift
//  TeekyTalk
//
//  Created by umer malik on 04/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Kingfisher 

class RecentMessageCell: UITableViewCell {
    
    var conversation : Conversation? {
        didSet {
            configure()
        }
    }

    
    func configure() {
        
        guard let message = conversation else {return}
        
        contactLbl.text = message.message.message
        let image = message.user.PROFILE_IMAGE
       
        let date = message.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
                
        timeLbl.text = dateFormatter.string(from: date)
        self.contactImg.kf.setImage(with:  URL(string: image), placeholder: UIImage(named: "adduser"))

    }
    
    
    let contactLbl : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    let timeLbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "time"
        lbl.textAlignment = .center
        return lbl
    }()
  
      
  
  
    let contactImg : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .green
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        
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
        contactLbl.anchor(top: topAnchor, left: contactImg.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 20, paddingRight: 60, width: nil, height: nil)

        contactLbl.addSubview(timeLbl)
        timeLbl.anchor(bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
}
