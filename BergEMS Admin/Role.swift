//
//  Role.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 2/3/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class Role {
    var id: Int?
    var name: String?
    var description: String?
    
    static func fromJSON(json: JSON) -> Role {
        let role = Role()
        role.id = json["id"].int
        role.name = json["name"].string
        role.description = json["description"].string
        return role
    }
}
