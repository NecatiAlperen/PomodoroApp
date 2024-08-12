//
//  TabbarController.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 12.08.2024.
//

import UIKit

final class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    private func setupTabbar() {
        tabBar.backgroundColor = .systemGray3
        
        let vcFirst = TimerViewController()
        let vcSecond = SettingsViewController()
        
        vcFirst.tabBarItem.image = UIImage(systemName: "timer")
        vcSecond.tabBarItem.image = UIImage(systemName: "gearshape")
        vcFirst.tabBarItem.title = "Timer"
        vcSecond.tabBarItem.title = "Settings"
        
        
        tabBar.tintColor = .label
        setViewControllers([vcFirst,vcSecond], animated: true)
    }
}
