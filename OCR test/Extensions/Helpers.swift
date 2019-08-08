//
//  Helpers.swift
//  OCR test
//
//  Created by Maciej Madaj on 08/08/2019.
//

import Foundation

func performOnMainThread(closure: @escaping () -> ()) {
    if Thread.isMainThread {
        closure()
    }
    else {
        DispatchQueue.main.async {
            closure()
        }
    }
}
