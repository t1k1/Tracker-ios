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
        let first = OnboardingPageViewController(
            image: UIImage(named: "OnboardingImage1"),
            textLabel: NSLocalizedString("mes1", tableName: "LocalizableStr", comment: "")
        )
        let second = OnboardingPageViewController(
            image: UIImage(named: "OnboardingImage2"),
            textLabel: NSLocalizedString("mes2", tableName: "LocalizableStr", comment: "")
        )
        
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
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
