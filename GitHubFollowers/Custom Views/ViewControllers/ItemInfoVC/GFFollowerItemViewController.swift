//
//  GFFollowerItemViewController.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/28/22.
//

import UIKit

class GFFollowerItemViewController:  GFItemInfoViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureitems()
    }
    
    private func configureitems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
