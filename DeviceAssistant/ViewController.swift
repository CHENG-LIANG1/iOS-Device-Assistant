//
//  ViewController.swift
//  DeviceAssistant
//
//  Created by 梁程 on 2022/2/14.
//

import UIKit
class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "bgColor")
        let color = UIColor.init(patternImage: image!)
        view.backgroundColor = color
        
        let homeVC = HomeViewController()
        let SettingsVC = SettingsViewController()
        
        homeVC.tabBarItem = UITabBarItem.init(title: "Device", image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray), tag: 0)
        
        homeVC.tabBarItem.selectedImage = UIImage(named: "home.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.darkTab)
        
        SettingsVC.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray), tag: 0)
        SettingsVC.tabBarItem.selectedImage = UIImage(named: "profile.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(K.darkTab)
        
        
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .white

        
        let selectedColor   = K.darkTab
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .black)], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .black)], for: .normal)
        
        let controllerArray = [homeVC, SettingsVC]
        self.viewControllers = controllerArray.map{(UINavigationController.init(rootViewController: $0))}
    }
}
