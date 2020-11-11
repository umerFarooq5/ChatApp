//
//  ViewController.swift
//  TeekyTalk
//
//  Created by umer malik on 04/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setpTableview()
        setupNavbar()
    }
    
    
    
    
    @objc func handleSearchBtn() {
        print(" search button pressed")
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancelBtn))
    }
    
    @objc func handlecancelBtn() {
        print(" search button pressed")
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBtn))
    }
}


extension ContactsVC: UITableViewDataSource, UITableViewDelegate   {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
        cell.selectionStyle = .none
        return cell
        
    }
    
    func setupNavbar() {
        configureNavigationBar(withTitle: "Contacts", prefersLargeTitles: true)
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBtn))
    }
    
    func setpTableview() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ContactCell.self, forCellReuseIdentifier: "cell")
        
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        
       
    }
    
   
    
    
}
