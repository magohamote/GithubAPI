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
        if let text = self.text {
            let attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font:self.font])
            
            let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            
            return ceil(rect.size.height)
        }
        return 0
    }
}
