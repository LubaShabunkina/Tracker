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
    private var visibleCategories: [TrackerCategory] = []
    
    
    private func updateVisibleCategories() {
        let calendarWeekday = Calendar.current.component(.weekday, from: selectedDate)
        let weekdayIndex = (calendarWeekday + 5) % 7 + 1
        visibleCategories = categories.map { category in
            let trackersForDay = category.trackers.filter {
                $0.schedule.contains { $0.rawValue == weekdayIndex }
            }
            return TrackerCategory(title: category.title, trackers: trackersForDay)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 9
        let itemWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 90)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacing, bottom: 16, right: spacing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupEmptyState()
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        updateUI()
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
    
    private func updateUI() {
        updateVisibleCategories()
        collectionView.reloadData()
        
        let isEmpty = visibleCategories.allSatisfy { $0.trackers.isEmpty }
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
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
        let createVC = CreateTrackerViewController(trackerType: .habit)
        createVC.delegate = self
        let navVC = UINavigationController(rootViewController: createVC)
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateUI()
    }
}


extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompleted = completedTrackers.contains { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.configure(with: tracker, isCompleted: isCompleted, completedDays: completedDays)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath
        ) as? HeaderView else {
            return UICollectionReusableView()
        }
        
        let category = visibleCategories[indexPath.section]
        header.configure(with: category.title)
        return header
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func didTapComplete(for tracker: Tracker) {
        let today = selectedDate
        
        if let index = completedTrackers.firstIndex(where: {
            $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            
            completedTrackers.remove(at: index)
        } else {
            
            let record = TrackerRecord(id: tracker.id, date: today)
            completedTrackers.append(record)
        }
        
        collectionView.reloadData()
    }
}


extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, in category: TrackerCategory) {
        print("🟢 Данные пришли в TrackersViewController: \(tracker.name)")
        
        if let index = categories.firstIndex(where: { $0.title == category.title }) {
            var updatedCategory = categories[index]
            updatedCategory.trackers.append(tracker)
            categories[index] = updatedCategory
        } else {
            
            let newCategory = TrackerCategory(title: category.title, trackers: [tracker])
            categories.append(newCategory)
        }
        updateUI()
    }
}

