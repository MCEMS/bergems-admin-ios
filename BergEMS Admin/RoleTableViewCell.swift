//
//  RoleTableViewCell.swift
//  BergEMS Admin
//
//  Created by Ben Burwell on 2/3/16.
//  Copyright © 2016 Muhlenberg College EMS. All rights reserved.
//

import UIKit

class RoleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
