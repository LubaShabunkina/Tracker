//
//  Untitled.swift
//  Tracker
//
//  Created by Luba Shabunkina on 06/06/2025.
//

import UIKit

final class ScheduleCell: UITableViewCell {

    private let dayLabel = UILabel()
    private let toggleSwitch = UISwitch()

    var onToggle: ((Bool) -> Void)?

    private var currentWeekday: Weekday?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false

        toggleSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)

        contentView.addSubview(dayLabel)
        contentView.addSubview(toggleSwitch)

        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(for weekday: Weekday, isOn: Bool) {
        currentWeekday = weekday
        dayLabel.text = weekday.displayName
        toggleSwitch.isOn = isOn
    }

    @objc private func switchToggled() {
        onToggle?(toggleSwitch.isOn)
    }
}
