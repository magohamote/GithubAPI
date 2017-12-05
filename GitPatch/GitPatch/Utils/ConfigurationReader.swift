//
//  ConfigurationReader.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit

class ConfigurationReader {
    
    private var colors:[String: String]
    
    static let sharedInstance = ConfigurationReader()
    
    init() {
        let styleFilePath = Bundle.main.url(forResource: "colorsfilename", withExtension: "json")
        do {
            let data = try Data(contentsOf: styleFilePath!)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let json = json as? [String: String] {
                colors = json
                return
            }
        } catch {
            print("error while loading color from JSON file")
        }
        colors = [:]
    }

    func color(forKey key: String) -> UIColor {
        if let color = colors[key] {
            return UIColor(rgb: color)
        }
        return UIColor.blue
    }
}
