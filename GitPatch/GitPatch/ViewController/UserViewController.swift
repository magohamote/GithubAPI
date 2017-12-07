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
    
    private var userDetails: User?
    private var isDownloadingRepos = false
    private var isDownloadingFollowers = false
    private var followersArray = [User]()
    private let repoDataSource = RepoViewModel()
    private let userDetailDataSource = UserDetailViewModel()
    private let followerDataSource = FollowerViewModel()
    private var storedOffsets = [Int: CGFloat]()
    private var reposArray = [Repo](){
        didSet {
            updateSection(section: 2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
            showError(withMessage: "An error occured while presenting user details.")
            return
        }
        
        title = user.login
        setDs()
        if Reachability.isConnected() {
            downloadData(withUser: user)
        }
    }
    
    func setDs() {
        tableView.delegate = self
        tableView.dataSource = self
        repoDataSource.delegate = self
        followerDataSource.delegate = self
        userDetailDataSource.delegate = self
    }
    
    func downloadData(withUser user: User) {
        isDownloadingRepos = true
        isDownloadingFollowers = true
        repoDataSource.requestUserRepos(url: user.reposUrl)
        userDetailDataSource.requestUserDetails(url: user.url)
        followerDataSource.requestUserFollowers(url: user.followersUrl)
    }
    
    func updateSection(section: Int) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

extension UserViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            if reposArray.count == 0 {
                return 1
            }
            return reposArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsCell.identifier) as? UserDetailsCell, let imageUrl = user?.avatarUrl {
                cell.config(withUser: userDetails, imageUrl: imageUrl)
                return cell
            }
        case 1:
            if followersArray.count == 0 {
                if Reachability.isConnected() && isDownloadingFollowers {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier) as? LoadingCell {
                        cell.config()
                        return cell
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: NoDataCell.identifier) as? NoDataCell, let username = user?.login {
                        cell.config(withUsername: username, dataType: "follower")
                        return cell
                    }
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: FollowerCollectionCell.identifier) as? FollowerCollectionCell {
                    return cell
                }
            }
        case 2:
            if reposArray.count == 0 {
                if Reachability.isConnected() && isDownloadingRepos {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier) as? LoadingCell {
                        cell.config()
                        return cell
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: NoDataCell.identifier) as? NoDataCell, let username = user?.login {
                        cell.config(withUsername: username, dataType: "repository")
                        return cell
                    }
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier) as? RepoCell {
                    cell.config(withRepo: reposArray[indexPath.row])
                    return cell
                }
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

extension UserViewController: RepoViewModelDelegate {
    func didReceiveRepos(repos: [Repo]) {
        isDownloadingRepos = false
        reposArray = repos
        updateSection(section: 0)
    }
    
    func didFailDownloadReposWithError(error: Error) {
        isDownloadingRepos = false
        showError(withMessage: "An error occured while downloading repositories.")
    }
}

extension UserViewController: UserDetailViewModelDelegate {
    func didReceiveUserDetails(user: User) {
        self.userDetails = user
        updateSection(section: 0)
    }
    
    func didFailDownloadUserDetailsWithError(error: Error) {
        showError(withMessage: "An error occured while downloading user details.")
    }
}

extension UserViewController: FollowerViewModelDelegate {
    func didReceiveUsersFollowers(followers: [User]) {
        isDownloadingFollowers = false
        followersArray = followers
        updateSection(section: 1)
    }
    
    func didFailDownloadFollowersWithError(error: Error) {
        isDownloadingFollowers = false
        showError(withMessage: "An error occured while downloading followers.")
    }
}
