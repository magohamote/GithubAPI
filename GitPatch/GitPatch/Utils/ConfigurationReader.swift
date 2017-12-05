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
        if let colorsFilePath = Bundle.main.url(forResource: "languages_colors", withExtension: "json") {
            do {
                let data = try Data(contentsOf: colorsFilePath)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let colorsJson = json as? [String: String] {
                    colors = colorsJson
                    return
                }
            } catch {
                print("error while loading color from JSON file")
            }
        }
        colors = [:]
    }

    func color(forKey key: String) -> UIColor {
        if let color = colors[key] {
            return UIColor(rgb: color)
        }
        return .clear
    }
}
