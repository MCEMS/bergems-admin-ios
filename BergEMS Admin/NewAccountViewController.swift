//
//  NewAccountViewController.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 1/22/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveNewAccount(sender: UIBarButtonItem) {
        let account = Account()
        account.username = usernameField.text
        account.password = passwordField.text
        account.email = emailField.text
        account.save() { success, account in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let errorController = UIAlertController(title: "Error", message: "Could not create account", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorController.addAction(okayAction)
                    self.navigationController?.presentViewController(errorController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
}
