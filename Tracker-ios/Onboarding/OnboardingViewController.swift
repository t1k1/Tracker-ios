//
//  OnboardingViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 09.11.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    //MARK: - Layout variables
    private lazy var pages: [UIViewController] = {
        let first = OnboardingPageViewController()
        first.indexOfPage = 0
        let second = OnboardingPageViewController()
        second.indexOfPage = 1
        
        return [first, second]
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.ypBlack
        pageControl.pageIndicatorTintColor = UIColor.ypBlackOpacity30
        
        return pageControl
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
    
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
        
            changeLabel(indexOfPage: currentIndex)
            pageControl.currentPage = currentIndex
        }
    }
}

//MARK: - Private functions
private extension OnboardingViewController {
    func configureViewController() {
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(pageControl)
        view.addSubview(label)
        view.addSubview(button)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -130),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func changeLabel(indexOfPage: Int) {
        if indexOfPage == 0 {
            label.text = """
            Отслеживайте только
            то, что хотите
            """
        } else if indexOfPage == 1 {
            label.text = """
            Даже если это
            не литры воды и йога
            """
        }
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
