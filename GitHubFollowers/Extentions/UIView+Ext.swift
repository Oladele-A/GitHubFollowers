//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 9/11/22.
//

import UIKit

extension UIView{
    
    func addSubviews(_ views: UIView...){
        for view in views{
            addSubview(view)
        }
    }
}
