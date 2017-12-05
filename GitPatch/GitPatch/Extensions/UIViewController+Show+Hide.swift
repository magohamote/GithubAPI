//
//  UIViewController+Show+Hide.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Errors
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "An error occured while downloading data", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading
    func showLoadingView() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.tag = 42
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.7
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingIndicator.center = loadingView.center
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingView(tableView: UITableView) {
        tableView.separatorColor = .backgroundGray
        tableView.refreshControl?.endRefreshing()
        self.view.viewWithTag(42)?.removeFromSuperview()
    }
}
