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
    
    private var userData = (repos: 0, stars: 0, followers: 0, following: 0)
    private var followersArray = [User]()
    private let repoDataSource = RepoDataModel()
    private let userDetailsDataSource = UserDetailsDataModel()
    private var storedOffsets = [Int: CGFloat]()
    private var reposArray = [Repo](){
        didSet {
            tableView.reloadData()
        }
    }
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return reposArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsCell.identifier) as? UserDetailsCell, let user = user {
                cell.config(withUser: user, data: userData)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FollowerCollectionCell.identifier) as? FollowerCollectionCell {
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier) as? RepoCell {
                cell.config(withRepo: reposArray[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let tableViewCell = cell as? FollowerCollectionCell else { return }
            tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? FollowerCollectionCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
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
        case 1:
            return bigHeader(withTitle: "Followers")
        case 2:
            return bigHeader(withTitle: "Repositories")
        default:
            return UITableViewHeaderFooterView()
        }
    }
    
    func bigHeader(withTitle title: String) -> UITableViewHeaderFooterView {
        let header = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        header.contentView.backgroundColor = .backgroundGray
        let labelHeight:CGFloat = 34
        let headerLabel = UILabel(frame: CGRect(x: 20, y: header.frame.height/2 - labelHeight/2 - 5 , width: view.frame.width - 40, height: labelHeight))
        headerLabel.text = title
        headerLabel.font = UIFont(name: "Roboto-Medium", size: 25)
        headerLabel.textColor = .anthracite
        header.addSubview(headerLabel)
        return header
    }
}

extension UserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionCell.identifier, for: indexPath) as? UserCollectionCell {
            cell.config(withUser: followersArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension UserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: UserViewController.identifier) as? UserViewController {
            vc.user = followersArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UserViewController: RepoDataModelDelegate {
    func didReceiveDataUpdate(repos: [Repo]) {
        reposArray = repos
        userData.repos = reposArray.count
        updateUserCell()
    }
    
    func didFailDataUpdateWithError(error: Error) {
        showError()
    }
}

extension UserViewController: UserDetailsDataModelDelegate {
    func didReceiveAmountOfFollowing(following: Int) {
        userData.following = following
        updateUserCell()
    }
    
    func didReceiveFollowers(followers: [User]) {
        userData.followers = followers.count
        followersArray = followers
        updateFollowersCollection()
        updateUserCell()
    }
    
    func didReceiveAmountOfStars(stars: Int) {
        userData.stars = stars
        updateUserCell()
    }
    
    func updateUserCell() {
        tableView.beginUpdates()
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func updateFollowersCollection() {
        tableView.beginUpdates()
        let indexPath = IndexPath(item: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func didFailWithError(error: Error) {
        showError()
    }
}
