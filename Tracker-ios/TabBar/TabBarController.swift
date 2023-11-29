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
        delegate = self
        
        setupView()
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", tableName: "LocalizableStr", comment: ""),
            image: UIImage(named: "TabBarTrackerIcon"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", tableName: "LocalizableStr", comment: ""),
            image: UIImage(named: "TabBarStatisticsIcon"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}

//MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let viewController = viewController as? StatisticsViewController {
            viewController.updateRecords()
        }
        
        return true
    }
}

private extension TabBarController {
    func setupView() {
        view.backgroundColor = UIColor.ypWhite
        tabBar.layer.borderWidth = 0.2
        tabBar.layer.borderColor = UIColor.ypBlack.cgColor
    }
}
