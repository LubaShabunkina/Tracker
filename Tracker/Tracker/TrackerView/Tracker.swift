//
//  Tracker.swift
//  Tracker
//
//  Created by Luba Shabunkina on 27/05/2025.
//

import Foundation

struct Tracker: Codable, Equatable {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [Weekday]
}
