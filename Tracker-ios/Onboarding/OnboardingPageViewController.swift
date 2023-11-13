//
//  OnboardingPageViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 13.11.2023.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    //MARK: - Public variables
    var indexOfPage: Int?

    //MARK: - Layout variables
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let indexOfPage = indexOfPage else { return }
        
        if indexOfPage == 0 {
            imageView.image = UIImage(named: "OnboardingImage1")
        } else if indexOfPage == 1 {
            imageView.image = UIImage(named: "OnboardingImage2")
        }
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
