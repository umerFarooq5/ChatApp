//
//  MessageCell.swift
//  TeekyTalk
//
//  Created by umer malik on 16/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UICollectionViewCell {
    
    var bubbleLeftAnchor : NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    var messagess : Message? {
        didSet {
                configure()
        }
    }
    

    let label : UITextView = {
        let lbl = UITextView()
        lbl.backgroundColor = .clear
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        return lbl
    }()
    
    
    var bubble : UIView = {
        let lbl = UIView()
        lbl.layer.cornerRadius = 5
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(bubble)
        bubble.addSubview(label)
        
        bubble.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 10 , paddingLeft: 50, paddingBottom: 20)
        bubble.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        label.anchor(top: bubble.topAnchor, left: bubble.leftAnchor, bottom: bubble.bottomAnchor, right: bubble.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)

        bubbleLeftAnchor =   bubble.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
        bubbleRightAnchor =  bubble.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        label.text  =  messagess?.message
        bubble.backgroundColor =   messagess?.isFromCurrentUser == true  ? .gray : .blue
        
        guard let messagess = messagess else {return}
            
        if  messagess.fromId == Auth.auth().currentUser?.uid  {
        
            bubbleLeftAnchor.isActive = false
            bubbleRightAnchor.isActive = true
                
            } else {
                
                bubbleRightAnchor.isActive = false
                bubbleLeftAnchor.isActive = true
            }
        }
    
    
    
}
