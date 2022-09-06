//
//  GFTabBarController.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 9/6/22.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    func createSearchNC() -> UINavigationController{
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let searchNC = UINavigationController(rootViewController: searchVC)
        return searchNC
    }

    func createFavoritesNC() ->UINavigationController{
        let favoritesVC = FavoriteListViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let favoritesNC = UINavigationController(rootViewController: favoritesVC)
        return favoritesNC
    }
}
