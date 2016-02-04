//
//  ViewController.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 1/19/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var status: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.hidesWhenStopped = true
        usernameField.delegate = self
        passwordField.delegate = self
        setupView()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // TODO: conditionally enable login button
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.passwordField {
            self.doLogin()
        }
        return true
    }
    
    func setupView() {
        status.stopAnimating()
        loginButton.enabled = true
        usernameField.enabled = true
        usernameField.text = ""
        passwordField.enabled = true
        passwordField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doLogin() {
        if let username: String = usernameField.text, let password: String = passwordField.text {
            status.startAnimating()
            loginButton.enabled = false
            usernameField.enabled = false
            passwordField.enabled = false
            
            APIClient.sharedInstance.login(username, password: password) { success in
                self.setupView()
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("PostLogin", sender: self)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let errorAlert = UIAlertController(title: "Login Failed", message: "You may have entered invalid credentials, or your account may not have administrative access.", preferredStyle: .Alert)
                        let okayAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        errorAlert.addAction(okayAction)
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    @IBAction func handleLogin(sender: UIButton) {
        doLogin()
    }
}
