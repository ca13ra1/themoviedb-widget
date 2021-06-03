//
//  Extension.swift
//  themoviedb widgetExtension
//
//  Created by cole cabral on 2021-05-16.
//

import Foundation

extension Media {
    var stringValue: String {
        switch self {
        case .movies:
            return "movies"
        case .tv:
            return "tv"
        case .unknown:
            return "unknown"
        }
    }
}

extension Time {
    var stringValue: String {
        switch self {
        case .week:
            return "week"
        case .day:
            return "day"
        case .unknown:
            return "unknown"
        }
    }
}
