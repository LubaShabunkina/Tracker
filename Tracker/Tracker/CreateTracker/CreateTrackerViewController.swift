//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Luba Shabunkina on 06/06/2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {

    // MARK: - UI

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

    private let optionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var scheduleButton: UIButton = createOptionButton(title: "Расписание")
    private lazy var emojiButton: UIButton = createOptionButton(title: "Emoji")
    private lazy var colorButton: UIButton = createOptionButton(title: "Цвет")
    private var selectedSchedule: [Weekday] = []
    private var selectedEmoji: String?
    
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
    
    private let trackerType: TrackerType

    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupActions()
        
        titleLabel.text = trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        scheduleButton.isHidden = (trackerType == .irregular)
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(optionsStack)
        view.addSubview(createButton)

        optionsStack.addArrangedSubview(scheduleButton)
        optionsStack.addArrangedSubview(emojiButton)
        optionsStack.addArrangedSubview(colorButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),

            optionsStack.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            optionsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(didTapSchedule), for: .touchUpInside)
        emojiButton.addTarget(self, action: #selector(didTapEmoji), for: .touchUpInside)
        colorButton.addTarget(self, action: #selector(didTapColor), for: .touchUpInside)
    }

    private func createOptionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }

    // MARK: - Actions

    @objc private func textFieldDidChange() {
        let isNotEmpty = !(nameTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        createButton.isEnabled = isNotEmpty
        createButton.backgroundColor = isNotEmpty ? .black : .gray
    }

    @objc private func didTapCreate() {
        print("Создать трекер: \(nameTextField.text ?? "")")
        // TODO: собрать трекер и передать обратно
    }

    @objc private func didTapSchedule() {
        print("Открыть экран выбора расписания")
        let scheduleVC = ScheduleViewController()
           scheduleVC.onScheduleSelected = { [weak self] selectedDays in
               // Сохраняем выбранные дни в переменную, можно сразу обновить UI
               self?.selectedSchedule = selectedDays
               print("Выбрано: \(selectedDays.map { $0.displayName })")
           }

           let navVC = UINavigationController(rootViewController: scheduleVC)
           present(navVC, animated: true)
    }

    @objc private func didTapEmoji() {
        let emojiVC = EmojiSelectionViewController()
            emojiVC.onEmojiSelected = { [weak self] selected in
                self?.selectedEmoji = selected
                self?.emojiButton.setTitle("Emoji: \(selected)", for: .normal)
            }

            let navVC = UINavigationController(rootViewController: emojiVC)
            present(navVC, animated: true)
        }
    

    @objc private func didTapColor() {
        print("Открыть экран выбора цвета")
        // TODO: переход на экран выбора цвета
    }
}
