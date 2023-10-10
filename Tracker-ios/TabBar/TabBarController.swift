//
//  TabBarViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 02.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ypWhite
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TabBarTrackerIcon"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "TabBarStatisticsIcon"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}
