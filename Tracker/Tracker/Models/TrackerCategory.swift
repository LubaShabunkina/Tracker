//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Luba Shabunkina on 27/05/2025.
//
import Foundation

struct TrackerCategory: Codable, Equatable {
    let title: String
    let trackers: [Tracker]
}
