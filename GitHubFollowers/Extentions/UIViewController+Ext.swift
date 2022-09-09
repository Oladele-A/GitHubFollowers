//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/8/22.
//

import UIKit
import SafariServices

extension UIViewController{
    
    func presentAlertOnMainThread(title:String, message:String, buttonTitle:String){
        DispatchQueue.main.async {
            let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
