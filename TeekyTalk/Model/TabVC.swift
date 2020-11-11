//
//  TabVC.swift
//  TeekyTalk
//
//  Created by umer malik on 04/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  contactsVC = ContactsVC()
        contactsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let recentMessagesVC = RecentMessagesVC()
        recentMessagesVC.tabBarItem = UITabBarItem(title: "messages", image: UIImage(named: "mail"), selectedImage: UIImage(named: "mail"))
        recentMessagesVC.tabBarItem.imageInsets =  UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem = UITabBarItem(title: "settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings"))
        settingsVC.tabBarItem.imageInsets =  UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        
        let viewControllerList = [contactsVC ,recentMessagesVC, settingsVC]
        viewControllers = viewControllerList
        
       // Put every viewController in a navigation bar
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
        
        contactsVC.configureNavigationBar(withTitle: "Contacts", prefersLargeTitles: true)
        recentMessagesVC.configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        settingsVC.configureNavigationBar(withTitle: "settings", prefersLargeTitles: true)
        
        tabBar.tintColor = .yellow
        tabBar.unselectedItemTintColor = .white
        tabBar.barTintColor = .black
        
//        recentMessagesVC.tabBarItem.badgeValue = "123"
    }
    
    
}
