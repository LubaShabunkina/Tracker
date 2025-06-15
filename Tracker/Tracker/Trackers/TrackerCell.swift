//
//  TrackerCell.swift
//  Tracker
//
//  Created by Luba Shabunkina on 03/06/2025.
//
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapComplete(for tracker: Tracker)
}
final class TrackerCell: UICollectionViewCell {
    weak var delegate: TrackerCellDelegate?

    private var tracker: Tracker?

    private let completeButton = UIButton()
    
    private let backgroundContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tracker: Tracker, isCompleted: Bool, completedDays: Int) {
        self.tracker = tracker
        backgroundContainer.backgroundColor = UIColor(named: tracker.color) ?? .gray
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        daysLabel.text = "\(completedDays) дней"

        let imageName = isCompleted ? "checkmark" : "plus"
        completeButton.setImage(UIImage(systemName: imageName), for: .normal)
        completeButton.alpha = isCompleted ? 0.5 : 1.0
    }

    private func setupLayout() {
        contentView.addSubview(backgroundContainer)
        backgroundContainer.addSubview(emojiLabel)
        backgroundContainer.addSubview(nameLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(completeButton)

        NSLayoutConstraint.activate([
            backgroundContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundContainer.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -12),

            daysLabel.topAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: 8),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            completeButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    @objc private func completeButtonTapped() {
        guard let tracker = tracker else { return }
        delegate?.didTapComplete(for: tracker)
    }
}
