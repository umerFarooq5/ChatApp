//
//  TestVC.swift
//  TeekyTalk
//
//  Created by umer malik on 05/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Firebase

class RecentMessagesVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView  = UITableView()
    var chats = [Conversation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        setupTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        api.recentMessages { conversation in
            self.chats = conversation
            self.tableView.reloadData()
        }
    }
    
    
    func constraints() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    
}



extension RecentMessagesVC {
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentMessageCell.self, forCellReuseIdentifier: "cell")
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecentMessageCell
        cell.conversation = chats[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageVC = MessageVC()
        messageVC.modalPresentationStyle = .fullScreen
        
        messageVC.user = chats[indexPath.row].user
        present(messageVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let currentUid = AUTH.currentUser?.uid else {return}
        let docId = chats[indexPath.row].message.DOC_ID
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            api.deleteMessages(currentUid: currentUid, docId: docId)
            chats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
    }
    
    
    
    
}
