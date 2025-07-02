//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 08/06/2025.
//

import UIKit

final class CategorySelectionViewController: UIViewController {
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Важное", trackers: []),
        TrackerCategory(title: "Радостные мелочи", trackers: []),
        TrackerCategory(title: "Самочувствие", trackers: []),
        TrackerCategory(title: "Привычки", trackers: []),
        TrackerCategory(title: "Внимательность", trackers: []),
        TrackerCategory(title: "Спорт", trackers: [])
    ]

    var onCategorySelected: ((TrackerCategory) -> Void)?

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Категория"
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

extension CategorySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        onCategorySelected?(selectedCategory)
        dismiss(animated: true)
    }
}
