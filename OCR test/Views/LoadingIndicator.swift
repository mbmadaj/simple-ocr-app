//
//  LoadingIndicator.swift
//  OCR test
//
//  Created by Maciej Madaj on 08/08/2019.
//

import UIKit

class LoadingIndicator: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    lazy private var indicator = UIActivityIndicatorView(style: .whiteLarge)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func startAnimating() {
        isHidden = false
        indicator.startAnimating()
    }

    func stopAnimating() {
        indicator.stopAnimating()
        isHidden = true
    }

    private func setup() {
        layer.cornerRadius = 10
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        indicator.centerInSuperview()
        isHidden = true
    }
}
