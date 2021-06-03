//
//  Helpers.swift
//  themoviedb
//
//  Created by cole cabral on 2021-05-16.
//

import Foundation

func timeFormat(_ date: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let formattedDate = formatter.date(from: date) ?? Date()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: formattedDate)
}
