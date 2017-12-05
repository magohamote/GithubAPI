//
//  RepoCell.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet var cellFloatingView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var repoDescriptionLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var languageDotView: UIView!
//    @IBOutlet var starsCountLabel: UILabel!
    @IBOutlet var forksCountLabel: UILabel!
    @IBOutlet var updatedAtLabel: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func config(withRepo repo: Repo) {
        cellFloatingView.layer.cornerRadius = 15
        cellFloatingView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellFloatingView.layer.shadowOpacity = 0.1
        cellFloatingView.layer.shadowRadius = 2
        nameLabel.text = repo.name
        languageLabel.text = repo.language
        repoDescriptionLabel.text = repo.repoDescription
//        starsCountLabel.text = "\(repo.stargazersCount)"
        forksCountLabel.text = "\(repo.forksCount)"
        configDot(withLanguage: repo.language)
        updatedAtLabel.text = "Updated on \(configDate(withString: repo.updatedAt))"
    }
    
    func configDate(withString dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date: Date? = dateFormatterGet.date(from: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date!)
    }
    
    func configDot(withLanguage language: String) {
        let xCoord = 4
        let yCoord = 4
        let radius = 8
        let dotPath = UIBezierPath(ovalIn: CGRect(x: xCoord, y: yCoord, width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.strokeColor = ConfigurationReader.sharedInstance.color(forKey: language).cgColor
        layer.fillColor = ConfigurationReader.sharedInstance.color(forKey: language).cgColor
        languageDotView.layer.addSublayer(layer)
    }
}
