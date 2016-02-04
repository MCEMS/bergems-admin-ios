//
//  AccountDetailViewController.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 1/19/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var account: Account = Account()
    var availableRoles = [Role]()
    var activeRolesIds = [Int]()
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var roleTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = account.username
        deleteButton.enabled = account.username != APIClient.sharedInstance.username
        
        self.roleTable.dataSource = self
        self.roleTable.delegate = self
        
        self.refreshRoles()
    }
    
    func refreshRoles() {
        APIClient.sharedInstance.getRoles() { success, roles in
            if success {
                self.availableRoles = roles
                self.roleTable.reloadData()
            }
        }
        APIClient.sharedInstance.getAccountRoles(self.account) { success, roles in
            if success {
                self.activeRolesIds = [Int]()
                for role in roles {
                    self.activeRolesIds.append(role.id!)
                }
                self.roleTable.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.roleTable.dequeueReusableCellWithIdentifier("roleCell") as! RoleTableViewCell
        let role = self.availableRoles[indexPath.row]
        
        cell.nameLabel.text = role.name
        cell.descriptionLabel.text = role.description
        
        if (self.activeRolesIds.contains(role.id!)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableRoles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Roles"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let role = self.availableRoles[indexPath.row]
        if self.activeRolesIds.contains(role.id!) {
            APIClient.sharedInstance.removeAccountRole(self.account, role: role) { success in
                if success {
                    self.refreshRoles()
                }
            }
        } else {
            APIClient.sharedInstance.addAccountRole(self.account, role: role) { success in
                if success {
                    self.refreshRoles()
                }
            }
        }
    }
    
    func doDeletion(action: UIAlertAction) {
        self.account.delete() { success in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let errorController = UIAlertController(title: "Error", message: "There was a problem deleting the account", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorController.addAction(okayAction)
                    self.presentViewController(errorController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func deleteAccount(sender: UIBarButtonItem) {
        let confirmationController = UIAlertController(title: "Are you sure?", message: "You cannot undo this action", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .Destructive, handler: doDeletion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        confirmationController.addAction(confirmAction)
        confirmationController.addAction(cancelAction)
        presentViewController(confirmationController, animated: true, completion: nil)
    }
}
