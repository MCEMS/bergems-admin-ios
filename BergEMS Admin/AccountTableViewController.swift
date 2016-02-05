//
//  AccountTableViewController.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 1/19/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    var accounts: [Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        handleRefresh()
    }
    
    func handleRefresh() {
        APIClient.sharedInstance.getAccounts() { success, accounts in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.accounts = accounts
                    self.tableView.reloadData()
                    let indexSet = NSMutableIndexSet()
                    indexSet.addIndex(0)
                    self.tableView.reloadSections(indexSet, withRowAnimation: .None)
                    self.tableView.endUpdates()
                    self.refreshControl?.endRefreshing()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let errorAlert = UIAlertController(title: "Error", message: "There was an error fetching accounts.", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    errorAlert.addAction(okayAction)
                    self.presentViewController(errorAlert, animated: false, completion: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! AccountTableViewCell
        cell.accountNameLabel.text = accounts[indexPath.row].username
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AccountDetail" {
            let vc = segue.destinationViewController as! AccountDetailViewController
            if let cell = sender as? AccountTableViewCell {
                let indexPath = tableView.indexPathForCell(cell)!
                vc.account = accounts[indexPath.row]
            }
        } 
    }
}
