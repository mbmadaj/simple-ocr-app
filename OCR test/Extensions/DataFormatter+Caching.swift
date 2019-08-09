//
//  DataFormatter+Caching.swift
//  OCR test
//
//  Created by Maciej Madaj on 09/08/2019.
//

import Foundation

private var cachedFormatters = [String : DateFormatter]()

extension DateFormatter {
    static func cached(withFormat format: String) -> DateFormatter {
        if let cachedFormatter = cachedFormatters[format] {
            return cachedFormatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        cachedFormatters[format] = formatter
        return formatter
    }
}
