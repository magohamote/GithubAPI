//
//  UITableViewHeaderFooterView+BigTitle.swift
//  GitPatch
//
//  Created by Rolland Cédric on 08.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {
    func bigHeader(withTitle title: String) -> UITableViewHeaderFooterView {
        contentView.backgroundColor = .backgroundGray
        let labelHeight: CGFloat = 34
        let headerLabel = UILabel(frame: CGRect(x: 20, y: bounds.height/2 - labelHeight/2 - 5 , width: bounds.width - 40, height: labelHeight))
        headerLabel.text = title
        headerLabel.font = UIFont(name: "Roboto-Medium", size: 25)
        headerLabel.textColor = .anthracite
        addSubview(headerLabel)
        return self
    }
}
