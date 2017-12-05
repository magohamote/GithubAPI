//
//  UserDetailsCell.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit

class UserDetailsCell: UITableViewCell {
    
    @IBOutlet var userDetailsView: UIView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var reposCount: UILabel!
    @IBOutlet var starsCount: UILabel!
    @IBOutlet var followersCount: UILabel!
    @IBOutlet var followingCounts: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func config(withUser user: User, data:(repos: Int, stars: Int, followers: Int, following: Int)) {
        userImageView.sd_setImage(with: URL(string: user.avatarUrl)!, completed: nil)
        userImageView.layer.cornerRadius = 5
        userImageView.layer.masksToBounds = true
        
        userDetailsView.layer.cornerRadius = 15
        userDetailsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        userDetailsView.layer.shadowRadius = 2
        userDetailsView.layer.shadowOpacity = 0.1
        
        reposCount.text = "\(data.repos)"
        starsCount.text = "\(data.stars)"
        followersCount.text = "\(data.followers)"
        followingCounts.text = "\(data.following)"
    }
}
