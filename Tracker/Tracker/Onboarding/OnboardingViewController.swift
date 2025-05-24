//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 24/05/2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private var pages: [OnboardingPageViewController] = []
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let pageControl = UIPageControl()
    private let actionButton = UIButton(type: .system)

    private var currentIndex = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            actionButton.isHidden = currentIndex != pages.count - 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageViewController()
        setupPageControl()
        setupActionButton()
    }

    private func setupPages() {
        pages = [
            OnboardingPageViewController(imageName: "onboarding1", titleText: "Отслеживайте только то, что хотите", subtitleText: ""),
            OnboardingPageViewController(imageName: "onboarding2", titleText: "Даже если это не литры воды и йога", subtitleText: ""),
        ]
    }

    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupActionButton() {
        actionButton.setTitle("Вот это технологии!", for: .normal)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapAction() {
        // TODO: переход на главный экран
        print("Переход на главный экран")
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingPageViewController),
              index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingPageViewController),
              index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let visibleVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let index = pages.firstIndex(of: visibleVC) {
            currentIndex = index
        }
    }
}
