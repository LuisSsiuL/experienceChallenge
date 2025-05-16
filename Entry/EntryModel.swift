//
//  EntryModel.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 09/05/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Entry {
    var category: String
    var time: Date
    var image: Data?
    var note: String = ""
    
    init(category: String, time: Date, note: String = "") {
        self.category = category
        self.time = time
        self.note = note
    }
}

@Model
final class Car {
    var plate: String
    var type: String
    var entry: [Entry]
    
    init(plate: String, type: String, entry: [Entry] = []) {
        self.plate = plate
        self.type = type
        self.entry = entry
    }
    
    var mostRecentEntry: Date {
        entry.max(by: { $0.time < $1.time })?.time ?? Date()
    }
    
    var dayGroup: Date {
        return Calendar.current.startOfDay(for: mostRecentEntry)
    }
    
    var groupedEntries: [Date: [Entry]] {
        Dictionary(grouping: entry, by: { $0.time })
                .mapValues { $0.sorted(by: { $0.time > $1.time }) } // Sort by most recent first
    }
}


