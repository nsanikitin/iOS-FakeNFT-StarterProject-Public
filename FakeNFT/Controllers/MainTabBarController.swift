//
//  MainTabBarController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 18.06.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().unselectedItemTintColor = .invertedSystemBackground
        let profileViewController = UIViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "Profile"), tag: 0)
        
        let catalogViewController = UIViewController()
        catalogViewController.tabBarItem = UITabBarItem(title: "Каталог", image: UIImage(named: "CatalogTabBar"), tag: 1)
        
        let cartViewController = UIViewController()
        cartViewController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named: "BasketTabBar"), tag: 2)
        
        let statsViewController = UIViewController()
        statsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "Statistics"), tag: 3)
        
        viewControllers = [profileViewController, catalogViewController, cartViewController, statsViewController]
    }
}

