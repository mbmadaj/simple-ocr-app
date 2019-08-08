//
//  String+Localize.swift
//  OCR test
//
//  Created by Maciej Madaj on 08/08/2019.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
