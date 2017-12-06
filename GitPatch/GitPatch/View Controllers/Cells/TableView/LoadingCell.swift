//
//  LoadingCell.swift
//  GitPatch
//
//  Created by Rolland Cédric on 06.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func config() {
        activityIndicator.startAnimating()
    }
}
