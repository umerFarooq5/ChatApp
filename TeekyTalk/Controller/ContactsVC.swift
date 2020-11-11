//
//  ViewController.swift
//  TeekyTalk
//
//  Created by umer malik on 04/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher



class ContactsVC: UIViewController, UISearchBarDelegate   {
   
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var myContacts = [User]()
    var filtered = [User]()
    var isFiltering = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureNavigationBar(withTitle: "Contacts", prefersLargeTitles: true)
        setupNavbar()
        setpTableview()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        api.ifUserNotLoggedIn {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        api.getMyContacts { users in
            self.myContacts = users
            self.tableView.reloadData()
        }
    }
    
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBtn))
        
        navigationItem.leftBarButtonItem
            =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddBtn))
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchBar.text?.isEmpty == true {
            isFiltering = false
            tableView.reloadData()
        } else {
            isFiltering = true
            filtered =  myContacts.filter({ $0.name.lowercased().contains(searchText.lowercased() ) })
            tableView.reloadData()
            print(filtered.count)
        }
    }
    
    
    @objc func handleAddBtn() {
        print(" search button pressed")
        let addContactVC = AddContactVC()
        navigationController?.pushViewController(addContactVC, animated: true)
    }
    
    @objc func handleSearchBtn() {
        print(" search button pressed")
        setSearchBarOnSearch()
    }
    
    
    @objc func handlecancelBtn() {
        print(" search button pressed")
        setSearchBarOnCancel()
    }
    
    
    func setSearchBarOnCancel() {
        isFiltering = false
        tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.searchTextField.text = ""
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBtn))
    }
    
    
    func setSearchBarOnSearch() {
        searchBar.sizeToFit()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancelBtn))
        navigationItem.titleView = searchBar
        searchBar.placeholder = "search"
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
}





extension ContactsVC: UITableViewDataSource, UITableViewDelegate   {
    
    func setpTableview() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ContactCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering == false ?  myContacts.count : filtered.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
            
        cell.user = isFiltering == false ? myContacts[indexPath.row] : filtered[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let messageVC = MessageVC()
        messageVC.user =  isFiltering == false ? myContacts[indexPath.row] : filtered[indexPath.row]

        setSearchBarOnCancel()
        searchBar.resignFirstResponder()
        present(messageVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "edit") {  (contextualAction, view, boolValue) in
            
            let editVC = EditVC()
            editVC.user = self.myContacts[indexPath.row] 
            self.navigationController?.pushViewController(editVC, animated: true)
            tableView.setEditing(false, animated: true)
            
            
        }
        contextItem.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    
    
    
    
    
    
    
}
