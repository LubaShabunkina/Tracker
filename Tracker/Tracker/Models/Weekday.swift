//
//  Weekday.swift
//  Tracker
//
//  Created by Luba Shabunkina on 27/05/2025.
//
import Foundation


enum Weekday: Int, CaseIterable, Codable {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday

    var displayName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }

    var order: Int { self.rawValue }
}
