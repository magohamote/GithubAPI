//
//  UIView+DrawDot.swift
//  GitPatch
//
//  Created by Rolland Cédric on 07.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import UIKit

extension UIView {
    func drawDot(withLanguage language: String) {
        let xCoord = 4
        let yCoord = 4
        let radius = 8
        let dotPath = UIBezierPath(ovalIn: CGRect(x: xCoord, y: yCoord, width: radius, height: radius))
        let sublayer = CAShapeLayer()
        sublayer.path = dotPath.cgPath
        sublayer.strokeColor = ConfigurationReader.sharedInstance.color(forKey: language).cgColor
        sublayer.fillColor = ConfigurationReader.sharedInstance.color(forKey: language).cgColor
        layer.addSublayer(sublayer)
    }
}
