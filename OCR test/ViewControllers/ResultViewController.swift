//
//  ResultViewController.swift
//  OCR test
//
//  Created by Maciej Madaj on 07/08/2019.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!

    private var image: UIImage?
    private var result: String?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func instantiate(image: UIImage?, result: String?) {
        self.image = image
        self.result = result
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = image
        if let result = result, result.isEmpty == false {
            resultTextView.text = result
        }
        else {
            resultTextView.text = "no_text_detected".localized
        }
    }
}
