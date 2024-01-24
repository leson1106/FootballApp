//
//  DateHelper.swift
//  FootBallApp
//
//  Created by Son Le on 18/01/2024.
//

import Foundation

enum DateHelper {

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static func convert(dateString: String,
                        from format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                        to newFormat: String) -> String {
        formatter.dateFormat = format
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = newFormat
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
}
