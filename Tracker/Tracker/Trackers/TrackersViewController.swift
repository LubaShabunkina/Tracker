//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 24/05/2025.
//

import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDelegate {
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var selectedDate: Date = Date()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // настрой layout: itemSize, spacing и т.д.
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // зарегай ячейку:
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        return collectionView
    }()
    
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
        emptyImageView.image = UIImage(named: "trackers")
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
        let typeVC = CreateTrackerTypeViewController()
        let navController = UINavigationController(rootViewController: typeVC)
        present(navController, animated: true)
    }
}


extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let isCompleted = completedTrackers.contains { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        
        cell.configure(with: tracker, isCompleted: isCompleted)
        cell.delegate = self // если ты хочешь обрабатывать нажатие на кнопку
        return cell
    }
}
    
    extension TrackersViewController: TrackerCellDelegate {
        func didTapComplete(for tracker: Tracker) {
            let today = selectedDate
            
            if let index = completedTrackers.firstIndex(where: {
                $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: today)
            }) {
                // Удаляем выполненный трекер
                completedTrackers.remove(at: index)
            } else {
                // Добавляем запись о выполнении
                let record = TrackerRecord(id: tracker.id, date: today)
                completedTrackers.append(record)
            }
            
            // Обновляем интерфейс (можно конкретную ячейку, но пока можно просто reloadData)
            collectionView.reloadData()
        }
    }

