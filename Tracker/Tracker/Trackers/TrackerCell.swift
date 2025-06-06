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

    // Пример кнопки (замени на свою)
    private let completeButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        // Добавь кнопку в иерархию, настрой внешний вид и constraints
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tracker: Tracker, isCompleted: Bool) {
        self.tracker = tracker
        // настрой UI, например: цвет, эмоджи, галочка и т.д.
    }

    @objc private func completeButtonTapped() {
        guard let tracker = tracker else { return }
        delegate?.didTapComplete(for: tracker)
    }
}
