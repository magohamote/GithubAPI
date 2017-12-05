//
//  UserViewController.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var user: User?
    
    private let repoDataSource = RepoDataModel()
    private let userDetailsDataSource = UserDetailsDataModel()
    private var reposArray = [Repo](){
        didSet {
            tableView.reloadData()
        }
    }
    
    private var userData = (repos: 0, stars: 0, followers: 0, following: 0)
    private var userDataUpdated = (repos: false, stars: false, followers: false, following: false)
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else {
            showError()
            return
        }
        
        title = user.login
        setDs()
        downloadData(withUser: user)
    }
    
    func setDs() {
        tableView.delegate = self
        tableView.dataSource = self
        repoDataSource.delegate = self
        userDetailsDataSource.delegate = self
    }
    
    func downloadData(withUser user: User) {
        repoDataSource.requestData(url: user.reposUrl)
        userDetailsDataSource.requestAmountOfFollowers(url: user.followersUrl)
        userDetailsDataSource.requestAmountOfStars(url: user.starredUrl.replacingOccurrences(of: "{/owner}{/repo}", with: ""))
        userDetailsDataSource.requestAmountOfFollowing(url: user.followingUrl.replacingOccurrences(of: "{/other_user}", with: ""))
    }
}

extension UserViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return reposArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsCell.identifier) as? UserDetailsCell, let user = user {
                cell.config(withUser: user, data: userData)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier) as? RepoCell {
                cell.config(withRepo: reposArray[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        default:
            let header = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
            header.contentView.backgroundColor = .backgroundGray
            let labelHeight:CGFloat = 34
            let headerLabel = UILabel(frame: CGRect(x: 20, y: header.frame.height/2 - labelHeight/2 - 5 , width: self.view.frame.width - 40, height: labelHeight))
            headerLabel.text = "Repositories"
            headerLabel.font = UIFont(name: "Roboto-Medium", size: 25)
            headerLabel.textColor = .anthracite
            header.addSubview(headerLabel)
            return header
        }
    }
}

extension UserViewController: RepoDataModelDelegate {
    func didReceiveDataUpdate(repos: [Repo]) {
        reposArray = repos
        userData.repos = reposArray.count
        if userDataUpdated.stars && userDataUpdated.followers && userDataUpdated.following {
            updateUserCell()
        } else {
            userDataUpdated.repos = true
        }
    }
    
    func didFailDataUpdateWithError(error: Error) {
        showError()
    }
}

extension UserViewController: UserDetailsDataModelDelegate {
    func didReceiveAmountOfFollowing(following: Int) {
        userData.following = following
        if userDataUpdated.repos && userDataUpdated.stars && userDataUpdated.followers {
            updateUserCell()
        } else {
            userDataUpdated.following = true
        }
    }
    
    func didReceiveAmountOfFollowers(followers: Int) {
        userData.followers = followers
        if userDataUpdated.repos && userDataUpdated.stars && userDataUpdated.followers {
            updateUserCell()
        } else {
            userDataUpdated.followers = true
        }
    }
    
    func didReceiveAmountOfStars(stars: Int) {
        userData.stars = stars
        if userDataUpdated.repos && userDataUpdated.followers && userDataUpdated.following {
            updateUserCell()
        } else {
            userDataUpdated.stars = true
        }
    }
    
    func updateUserCell() {
        tableView.beginUpdates()
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func didFailWithError(error: Error) {
        showError()
    }
}
