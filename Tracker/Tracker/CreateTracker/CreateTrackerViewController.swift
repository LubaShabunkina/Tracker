//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 06/06/2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {

    // MARK: - Data

    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️","😱", "😇", "😡", "🥶","🤔","🙌","🍔", "🥦","🏓", "🥇", "🎸", "🏝", "😪"]
    private let colors: [UIColor] = [
        .systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPink, .systemPurple,
        .systemTeal, .systemYellow, .brown, .magenta, .cyan, .darkGray,
        .systemIndigo, .lightGray, .systemGray,  .systemFill, .black
    ]

    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?

    private var selectedSchedule: [Weekday] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?

    private let trackerType: TrackerType

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var scheduleButton: UIButton = createOptionButton(title: "Расписание")

    private let emojiTitleLabel = CreateTrackerViewController.sectionLabel(text: "Emoji")
    private let colorTitleLabel = CreateTrackerViewController.sectionLabel(text: "Цвет")

    private let emojiCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 52, height: 52)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private let colorCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 52, height: 52)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupCollectionView()
        setupLayout()
        setupActions()
        updateCreateButtonState()
    }

    private func setupNavigation() {
        navigationItem.title = trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(didTapCancel))
    }

    private func setupCollectionView() {
        emojiCollection.dataSource = self
        emojiCollection.delegate = self
        emojiCollection.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")

        colorCollection.dataSource = self
        colorCollection.delegate = self
        colorCollection.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, nameTextField, scheduleButton, emojiTitleLabel, emojiCollection, colorTitleLabel, colorCollection, createButton].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),

            scheduleButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 50),

            emojiTitleLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 40),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            emojiCollection.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 8),
            emojiCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiCollection.heightAnchor.constraint(equalToConstant: 120),

            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 24),
            colorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            colorCollection.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 8),
            colorCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollection.heightAnchor.constraint(equalToConstant: 120),

            createButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private static func sectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(didTapSchedule), for: .touchUpInside)
    }

    private func createOptionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title + "  >", for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }

    private func updateCreateButtonState() {
        let isValid = !(nameTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty && selectedEmoji != nil && selectedColor != nil && (trackerType == .irregular || !selectedSchedule.isEmpty)

        createButton.isEnabled = isValid
        createButton.backgroundColor = isValid ? .black : .gray
    }

    @objc private func didTapCancel() {
        dismiss(animated: true)
    }

    @objc private func didTapCreate() {
        print("Создать трекер: \(nameTextField.text ?? "")")
        // TODO: собрать и передать Tracker
    }

    @objc private func didTapSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.onScheduleSelected = { [weak self] selectedDays in
            self?.selectedSchedule = selectedDays
            self?.updateCreateButtonState()
        }
        let navVC = UINavigationController(rootViewController: scheduleVC)
        present(navVC, animated: true)
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollection ? emojis.count : colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            cell.setEmoji(emojis[indexPath.item], isSelected: indexPath == selectedEmojiIndex)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            cell.setColor(colors[indexPath.item], isSelected: indexPath == selectedColorIndex)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollection {
            selectedEmojiIndex = indexPath
            selectedEmoji = emojis[indexPath.item]
        } else {
            selectedColorIndex = indexPath
            selectedColor = colors[indexPath.item]
        }
        updateCreateButtonState()
        collectionView.reloadData()
    }
}

