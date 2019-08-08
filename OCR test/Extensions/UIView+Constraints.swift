//
//  UIView+Constraints.swift
//  OCR test
//
//  Created by Maciej Madaj on 08/08/2019.
//

import UIKit

extension UIView {
    func centerInSuperview() {
        guard let superview = superview else {
            return
        }

        superview.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
        ])
    }

    func setConstrainsFor(size: CGSize) {
        addConstraints([
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.width),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.height)
        ])
    }
}
