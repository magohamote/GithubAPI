//
//  UserListViewController.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit

class UserListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet var noDataView: UIView!
    
    private var lastUserIndex = 0
    private var storedOffsets = [Int: CGFloat]()
    private let dataSource = UserViewModel(service: Service())
    internal var usersArray = [User]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gitpatch"
        dataSource.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        
        let pop = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: self, action: #selector(pop(_:)))
        navigationItem.rightBarButtonItem = pop
        
        if Reachability.isConnected() {
            showLoadingView()
        }
        downloadData(lastUserIndex: lastUserIndex)
    }
    
    func downloadData(lastUserIndex: Int) {
        if Reachability.isConnected() {
            tableView.alpha = 1
            dataSource.requestUserList(url: "https://api.github.com/users?since=", since: lastUserIndex)
            self.lastUserIndex += 30
            print("downloading")
        } else if let users = dataSource.loadUsers() {
            tableView.alpha = 1
            usersArray = users
            if usersArray.count == 0 {
                tableView.alpha = 0
            } else {
                tableView.reloadData()
            }
            hideLoadingView(tableView: tableView)
        } else {
            tableView.alpha = 0
        }
    }
    
    @objc func pop(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension UserListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier) as? UserCell {
            cell.config(withUser: usersArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: UserViewController.identifier) as? UserViewController {
            vc.user = usersArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == usersArray.count - 5 && Reachability.isConnected() {
            downloadData(lastUserIndex: lastUserIndex)
        }
    }
}

extension UserListViewController: UserViewModelDelegate {
    
    func didReceiveUsersList(users: [User]) {
        usersArray.append(contentsOf: users)
        dataSource.saveUsers(users: usersArray)
        hideLoadingView(tableView: tableView)
    }
    
    func didFailDownloadUsersListWithError(error: Error) {
        hideLoadingView(tableView: tableView)
        showError(withMessage: "An error occured while downloading users list.")
        if usersArray.count == 0 {
            tableView.alpha = 0
        } else {
            tableView.alpha = 1
        }
    }
}
