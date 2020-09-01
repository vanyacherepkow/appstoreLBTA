//
//  BaseTabBarController.swift
//  AppStoreLBTA
//
//  Created by Иван on 19.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
        createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
        createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
        createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search")
        ]
        
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController{
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        navController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
