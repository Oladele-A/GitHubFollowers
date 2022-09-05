//
//  FavoriteListViewController.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 6/11/22.
//

import UIKit

class FavoriteListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        PersistenceManager.retrieveFavorites { result in
            switch result{
                
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                break
            }
        }
    }
}
