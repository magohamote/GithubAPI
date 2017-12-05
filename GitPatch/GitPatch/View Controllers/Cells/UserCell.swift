//
//  UserCell.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var rightArrowImageView: UIImageView!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func config(withUser user: User) {
        userImageView.sd_setImage(with: URL(string: user.avatarUrl)!, completed: nil)
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.layer.masksToBounds = true
        usernameLabel.text = user.login
        usernameLabel.textColor = .anthracite
        rightArrowImageView.image = rightArrowImageView.image?.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.tintColor = .navyBlue
    }
}
