//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/10/22.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseID = "followerCell"
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    let padding:CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower:Follower){
        usernameLabel.text = follower.login
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
            guard let self = self  else { return }
            DispatchQueue.main.async { self.avatarImageView.image = image }
        }
    }
    
    private func configure(){
        
        addSubviews(avatarImageView, usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor), //so that height and width of the imageView will be the same for every screen size
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
