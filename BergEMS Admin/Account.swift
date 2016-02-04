//
//  Account.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 1/19/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account {
    var id: Int?
    var username: String?
    var email: String?
    var password: String?
    
    func delete(completion: (success: Bool) -> Void) {
        if let id: Int = self.id! as Int {
            APIClient.sharedInstance.deleteAccount(id, completion: completion)
        }
    }
    
    func save(completion: (success: Bool, account: Account?) -> Void) {
        // create
        if id == nil && username != nil && password != nil {
            APIClient.sharedInstance.createAccount(self, completion: completion)
        }
        
        // update
        if id != nil {
            print("update existing account not implemented")
        }
    }
    
    static func fromJSON(json: JSON) -> Account {
        let account = Account()
        account.id = json["id"].int
        account.username = json["username"].string
        account.email = json["email"].string
        return account
    }
}
