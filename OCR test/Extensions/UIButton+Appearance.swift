//
//  UIButton+Appearance.swift
//  OCR test
//
//  Created by Maciej Madaj on 07/08/2019.
//

import UIKit

extension UIButton {

    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                layer.borderColor = UIColor.gray.cgColor
                imageView?.tintColor = UIColor.gray
            }
            else {
                layer.borderColor = UIColor.black.cgColor
                imageView?.tintColor = UIColor.black
            }
        }
    }

    func style(borderWidth: CGFloat = 4) {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = frame.width/2
    }
}
