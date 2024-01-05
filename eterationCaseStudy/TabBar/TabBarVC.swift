//
//  TabBarVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateBasketBadge()
    }
    
    private func setupUI() {
        let viewController1 = HomeVC()
        let viewController2 = BasketVC()
        let viewController3 = FavoriteVC()
        let viewController4 = ProfileVC()
        
        
        viewController1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        viewController2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "basketIcon"), tag: 1)
        viewController3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "favoritesIcon"), tag: 2)
        viewController4.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profileIcon"), tag: 3)
        
        
        viewControllers = [viewController1, viewController2, viewController3, viewController4]
    }
    
    func updateBasketBadge() {
        // Sepetinizdeki ürün sayısını hesaplayın. Örneğin:
        let basketItemCount = 5
        
        if basketItemCount > 0 {
            self.viewControllers?[1].tabBarItem.badgeValue = String(basketItemCount)
        } else {
            self.viewControllers?[1].tabBarItem.badgeValue = nil
        }
    }
}

