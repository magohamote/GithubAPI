//
//  UserListViewController.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var noDataLabel: UILabel?
    
    private var loadingView: UIView?
    
    private let animationDuration = 0.5
    private let userPageSize = 30
    private var lastUserIndex = 0
    
    private let dataSource = UserViewModel()
    
    private var usersArray = [User]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gitpatch"
        noDataLabel?.alpha = 0
        
        dataSource.delegate = self
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        
        let pop = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: self, action: #selector(pop(_:)))
        navigationItem.rightBarButtonItem = pop
        
        if Reachability.isConnected() {
            loadingView = createLoadingView()
        }
        downloadData()
    }
    
   private func downloadData() {
        if Reachability.isConnected() {
            showTableHideLabel()
            dataSource.requestUserList(since: lastUserIndex)
            lastUserIndex += userPageSize
        
        } else if let users = dataSource.loadUsers() {
            usersArray = users
            usersArray.count == 0 ? hideTableShowLabel() : tableView?.reloadData()
            hideLoadingView()
        } else {
            hideTableShowLabel()
        }
    }
    
    @objc private func pop(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func hideTableShowLabel() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.noDataLabel?.alpha = 1
            self.tableView?.alpha = 0
        })
    }
    
    private func showTableHideLabel() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.noDataLabel?.alpha = 0
            self.tableView?.alpha = 1
        })
    }
    
    private func hideLoadingView() {
        loadingView?.removeFromSuperview()
        tableView?.refreshControl?.endRefreshing()
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier) as? UserCell else {
            return UITableViewCell()
        }
        
        cell.config(withUser: usersArray[safe: indexPath.row])
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: UserViewController.identifier) as? UserViewController {
            vc.user = usersArray[safe: indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == usersArray.count - 5 && Reachability.isConnected() {
            downloadData()
        }
    }
}

extension UserListViewController: UserViewModelDelegate {
    
    func didReceiveUsersList(users: [User]) {
        usersArray.append(contentsOf: users)
        dataSource.saveUsers(users: usersArray)
        hideLoadingView()
    }
    
    func didFailDownloadUsersListWithError(error: Error) {
        hideLoadingView()
        showError(withMessage: "An error occured while downloading users list.")
        if usersArray.count == 0 {
            hideTableShowLabel()
        } else {
            showTableHideLabel()
        }
    }
}
