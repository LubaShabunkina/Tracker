//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 24/05/2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupEmptyState()
    }

    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }

    private func setupEmptyState() {
        emptyImageView.image = UIImage(named: "empty-placeholder") // добавь эту картинку в Assets
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.contentMode = .scaleAspectFit

        emptyLabel.text = "Что будем отслеживать?"
        emptyLabel.font = UIFont.systemFont(ofSize: 17)
        emptyLabel.textColor = .gray
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emptyImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyImageView.heightAnchor.constraint(equalToConstant: 100),

            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func addButtonTapped() {
        print("Нажата кнопка +")
        // позже тут будет переход к созданию трекера
    }
}
