//
//  GFRepoItemViewController.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/28/22.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
}

class GFRepoItemViewController: GFItemInfoViewController{
    
    weak var delegate: GFRepoItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGithubProfile(for: user)
    }
}
