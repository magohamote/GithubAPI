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
    
    private var storedOffsets = [Int: CGFloat]()
    private let dataSource = UserDataModel()
    private var usersArray = [User](){
        didSet {
            tableView?.reloadData()
        }
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gitpatch"
        dataSource.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingView()
        downloadData()
    }
    
    func downloadData() {
        dataSource.requestData(url: "https://api.github.com/users?since=", since: 0)
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
        }
    }
}

extension UserListViewController: UserDataModelDelegate {
    
    func didReceiveDataUpdate(users: [User]) {
        usersArray = users
        hideLoadingView(tableView: tableView)
    }
    
    func didFailDataUpdateWithError(error: Error) {
        hideLoadingView(tableView: tableView)
        showError()
    }
}
