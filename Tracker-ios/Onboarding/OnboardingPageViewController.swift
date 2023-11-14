//
//  OnboardingPageViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 13.11.2023.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    //MARK: - Layout variables
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = """
        Отслеживайте только
        то, что хотите
        """
        
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor.ypBlack
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor.ypBlack
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.textColor = UIColor.ypWhite
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(buttonTouch), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Initialization
    init(indexOfPage: Int) {
        super.init(nibName: nil, bundle: nil)
        
        if indexOfPage == 0 {
            imageView.image = UIImage(named: "OnboardingImage1")
            label.text = """
            Отслеживайте только
            то, что хотите
            """
        } else if indexOfPage == 1 {
            imageView.image = UIImage(named: "OnboardingImage2")
            label.text = """
            Даже если это
            не литры воды и йога
            """
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        configureConstraints()
    }
}

private extension OnboardingPageViewController {
    func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -160),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc
    func buttonTouch() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        UserDefaults.standard.set(true, forKey: "needToShowOnboarding")
        window.rootViewController = TabBarController()
    }
}
