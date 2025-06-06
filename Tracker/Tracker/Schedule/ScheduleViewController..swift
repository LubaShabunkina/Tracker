//
//  ScheduleViewController..swift
//  Tracker
//
//  Created by Luba Shabunkina on 06/06/2025.
//
import UIKit

final class ScheduleViewController: UIViewController {

    private let tableView = UITableView()
    private var selectedDays = Set<Weekday>() // enum Weekday уже у тебя есть

    var onScheduleSelected: (([Weekday]) -> Void)? // колбэк, чтобы вернуть результат

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Расписание"

        setupTableView()
        setupDoneButton()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(Weekday.allCases.count * 54))
        ])
    }

    private func setupDoneButton() {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func didTapDone() {
        onScheduleSelected?(Array(selectedDays).sorted { $0.order < $1.order })
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Weekday.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weekday = Weekday(rawValue: indexPath.row) else {
            return UITableViewCell()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }

        cell.configure(for: weekday, isOn: selectedDays.contains(weekday))
        cell.onToggle = { [weak self] isOn in
            if isOn {
                self?.selectedDays.insert(weekday)
            } else {
                self?.selectedDays.remove(weekday)
            }
        }

        return cell
    }
}
