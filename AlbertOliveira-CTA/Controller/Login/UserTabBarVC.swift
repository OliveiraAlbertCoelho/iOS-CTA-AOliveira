//
//  UserTabBarVC.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class UserTabBarVC: UITabBarController {
    
    lazy var SearchViewController: UINavigationController = {
        let searchVC = SearchVC()
        searchVC.userInfo = AppUser(from: FirebaseAuthService.manager.currentUser!)
        return UINavigationController(rootViewController: searchVC)
    }()
    lazy var FavoritesViewController: UINavigationController = {
        let favoriteVC = FavoriteVC()
        favoriteVC.userInfo = AppUser(from: FirebaseAuthService.manager.currentUser!)
        return UINavigationController(rootViewController: favoriteVC)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass.circle.fill"), tag: 0)
        FavoritesViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart.circle"), tag: 0)
        self.viewControllers = [SearchViewController,FavoritesViewController]
    }
}
