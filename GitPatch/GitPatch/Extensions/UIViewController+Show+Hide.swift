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
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading
    func showLoadingView() {
        let loadingView = UIView(frame: view.bounds)
        loadingView.tag = 42
        loadingView.backgroundColor = .white
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingIndicator.center = loadingView.center
        loadingIndicator.color = .navyBlue
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        
        view.addSubview(loadingView)
    }
    
    func hideLoadingView(tableView: UITableView) {
        tableView.separatorColor = .backgroundGray
        tableView.refreshControl?.endRefreshing()
        UIView.animate(withDuration: 0.25, animations: {
            self.view.viewWithTag(42)?.alpha = 0
        }, completion: { _ in
            self.view.viewWithTag(42)?.removeFromSuperview()
        })
    }
}
