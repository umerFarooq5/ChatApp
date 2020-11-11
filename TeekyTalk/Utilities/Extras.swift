//
//  Extras.swift
//  TeekyTalk
//
//  Created by umer malik on 04/09/2020.
//  Copyright © 2020 umer malik. All rights reserved.
//

import UIKit
extension UIViewController {
    
    
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        appearance.backgroundColor = .black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        
        navigationController?.navigationBar.barStyle = .default
        
        navigationController?.navigationBar.tintColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
 
    func hideKeyboardWhenTappedAround(addedTo: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addedTo.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        resignFirstResponder()
        self.view.frame.origin.y = 0
        print("tapped GestureRecognizer pressed ")
    }
    
    
    func keyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    // validate an email for the right format
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    
    
    func isValidPassword(password:String?) -> Bool {
        guard password != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    
    
    func showAlert(textToShow: String, com : @escaping() -> (), cancelCom : @escaping() -> ()) {
        let alert = UIAlertController(title: "Error", message: textToShow, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (_) in
            cancelCom()
        }
        let ok = UIAlertAction(title: "ok", style: .default, handler: { _ in
            com()
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

