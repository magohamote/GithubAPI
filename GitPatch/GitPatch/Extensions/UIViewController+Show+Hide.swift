//
//  UIViewController+Show+Hide.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Errors
    func showError(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading
    func createLoadingView() -> UIView {
        
        let loadingView = UIView(frame: CGRect(origin: view.bounds.origin, size: CGSize(width: view.bounds.width, height: view.bounds.height)))
        loadingView.backgroundColor = .white
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingIndicator.center = loadingView.center
        loadingIndicator.color = .navyBlue
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        return loadingView
    }
}
