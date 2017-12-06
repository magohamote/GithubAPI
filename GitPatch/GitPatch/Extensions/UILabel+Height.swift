//
//  UILabel+Height.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import UIKit

extension UILabel {
    func retrieveTextHeight () -> CGFloat {
        if let text = text {
            let attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font])
            
            let rect = attributedText.boundingRect(with: CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            
            return ceil(rect.size.height)
        }
        return 0
    }
}
