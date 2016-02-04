//
//  APIClient.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 1/19/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    var username: String?
    var password: String?
    var token: String?
    var tokenExpiration: NSDate?
    var server = "api2.bergems.org"
    
    static var sharedInstance = APIClient()
    
    func login(username: String, password: String, completion: (success: Bool) -> Void) {
        self.username = username
        self.password = password
        
        self.refreshToken(completion)
    }
    
    func getApiBase() -> String {
        return "\(getServerBase())/api/"
    }
    
    func getServerBase() -> String {
        return "https://\(self.server)"
    }
    
    func getHttpHeaders() -> [String:String] {
        if self.token != nil {
            return [
                "Authorization": self.token!
            ]
        } else {
            return [String:String]()
        }
    }
    
    func refreshToken(completion: (success: Bool) -> Void) {
        if let pass = self.password as String!, let user = self.username as String! {
            let url = "\(getApiBase())/accounts/login"
            let params = [
                "username": user,
                "password": pass
            ]
            Alamofire.request(.POST, url, parameters: params, encoding: .JSON).responseJSON { response in
                if let data = response.result.value {
                    if let id = data["id"] as! String? {
                        self.token = id
                        completion(success: true)
                        return
                    }
                }
                completion(success: false)
            }
        }
    }

    func getAccounts(completion: (success: Bool, accounts: [Account]) -> Void) {
        Alamofire.request(.GET, "\(getApiBase())/accounts", headers: getHttpHeaders()).responseJSON { response in
            if response.response?.statusCode == 200 {
                if let data = response.result.value {
                    let json = JSON(data)
                    var accounts = [Account]()
                    for (_, item) in json {
                        accounts.append(Account.fromJSON(item))
                    }
                    completion(success: true, accounts: accounts)
                    return
                }
                completion(success: false, accounts: [Account]())
            } else {
                completion(success: false, accounts: [Account]())
            }
        }
    }

    func getAccount(id: Int, completion: (success: Bool, account: Account?) -> Void) {
        Alamofire.request(.GET, "\(getApiBase())/accounts/\(id)", headers: getHttpHeaders()).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)
                completion(success: false, account: Account.fromJSON(json))
                return
            }
            completion(success: false, account: nil)
        }
    }

    func deleteAccount(id: Int, completion: (success: Bool) -> Void) {
        Alamofire.request(.DELETE, "\(getApiBase())/accounts/\(id)", headers: getHttpHeaders()).responseJSON { response in
            completion(success: response.result.isSuccess)
        }
    }

    func createAccount(account: Account, completion: (success: Bool, account: Account?) -> Void) {
        if let username = account.username as String!, let password = account.password as String!, let email = account.email as String! {
            let params = [
                "username": username,
                "password": password,
                "email": email
            ]
            Alamofire.request(.POST, "\(getApiBase())/accounts", headers: getHttpHeaders(), parameters: params, encoding: .JSON).responseJSON { response in
                if let data = response.result.value {
                    let json = JSON(data)
                    completion(success: true, account: Account.fromJSON(json))
                    return
                }
                completion(success: false, account: nil)
            }
        }
    }
    
    func getRoles(completion: (success: Bool, roles: [Role]) -> Void) {
        Alamofire.request(.GET, "\(getApiBase())/accounts/roles", headers: getHttpHeaders()).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)
                var roles = [Role]()
                for (_, item) in json {
                    roles.append(Role.fromJSON(item))
                }
                completion(success: true, roles: roles)
                return
            }
            completion(success: false, roles: [Role]())
        }
    }
    
    func getAccountRoles(account: Account, completion: (success: Bool, roles: [Role]) -> Void) {
        if let id = account.id as Int! {
            Alamofire.request(.GET, "\(getApiBase())/accounts/\(id)/roles", headers: getHttpHeaders()).responseJSON { response in
                if let data = response.result.value {
                    let json = JSON(data)
                    var roles = [Role]()
                    for (_, item) in json {
                        roles.append(Role.fromJSON(item))
                    }
                    completion(success: true, roles: roles)
                    return
                }
                completion(success: false, roles: [Role]())
            }
        }
    }
    
    func addAccountRole(account: Account, role: Role, completion: (success: Bool) -> Void) {
        if let id = account.id as Int!, let roleId = role.id as Int! {
            let params = [
                "roleId": roleId
            ]
            Alamofire.request(.POST, "\(getApiBase())/accounts/\(id)/roles", headers: getHttpHeaders(), parameters: params, encoding: .JSON).responseJSON { response in
                completion(success: response.result.isSuccess)
            }
        } else {
            completion(success: false)
        }
    }
    
    func removeAccountRole(account: Account, role: Role, completion: (success: Bool) -> Void) {
        if let id = account.id as Int!, let roleId = role.id as Int! {
            Alamofire.request(.DELETE, "\(getApiBase())/accounts/\(id)/roles/\(roleId)", headers: getHttpHeaders()).responseJSON { response in
                completion(success: response.result.isSuccess)
            }
        } else {
            completion(success: false)
        }
    }
}