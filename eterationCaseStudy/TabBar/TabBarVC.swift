//
//  TabBarVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit

class TabBarVC: UITabBarController {

    let basketVC = BasketVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasketBadge), name: NSNotification.Name("BasketUpdated"), object: nil)
        updateBasketBadge()
    }
    private func setupUI() {
        let viewController1 = HomeVC()
        let viewController2 = basketVC
        let viewController3 = FavoriteVC()
        let viewController4 = ProfileVC()
        
        viewController1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal), tag: 0)
        viewController2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "basketIcon")?.withRenderingMode(.alwaysOriginal), tag: 1)
        viewController3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "favoritesIcon")?.withRenderingMode(.alwaysOriginal), tag: 2)
        viewController4.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profileIcon")?.withRenderingMode(.alwaysOriginal), tag: 3)
        
        viewControllers = [viewController1, viewController2, viewController3, viewController4]
    }



    @objc func updateBasketBadge() {
            let basketItemCount = CoreDataManager.shared.fetchBasketItems().count

            if basketItemCount > 0 {
                self.viewControllers?[1].tabBarItem.badgeValue = String(basketItemCount)
            } else {
                self.viewControllers?[1].tabBarItem.badgeValue = nil
            }
        }
}

