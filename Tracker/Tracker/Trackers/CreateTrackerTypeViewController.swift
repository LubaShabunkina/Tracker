//
//  CreateTrackerTypeViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 06/06/2025.
//

import UIKit

protocol CreateTrackerTypeViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, in category: TrackerCategory)
}

final class CreateTrackerTypeViewController: UIViewController {

    weak var typeDelegate: CreateTrackerTypeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Создание трекера"
        setupUI()
    }

    private func setupUI() {
        let habitButton = makeButton(title: "Привычка")
        let irregularButton = makeButton(title: "Нерегулярное событие")

        habitButton.addTarget(self, action: #selector(habitTapped), for: .touchUpInside)
        irregularButton.addTarget(self, action: #selector(irregularTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [habitButton, irregularButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func makeButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }

    @objc private func habitTapped() {
        let vc = CreateTrackerViewController(trackerType: .habit)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    @objc private func irregularTapped() {
        let vc = CreateTrackerViewController(trackerType: .irregular)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension CreateTrackerTypeViewController: CreateTrackerViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, in category: TrackerCategory) {
        typeDelegate?.didCreateTracker(tracker, in: category)
        self.dismiss(animated: true)
        
        print("🟢 \(tracker.name) добавлен в категорию \(category.title)")
    }
}
