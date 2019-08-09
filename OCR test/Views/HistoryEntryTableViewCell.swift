//
//  HistoryEntryTableViewCell.swift
//  OCR test
//
//  Created by Maciej Madaj on 09/08/2019.
//

import UIKit

/// custom cell that is easier to maintain and understand than .subtitle variant
class HistoryEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var currentImageVIew: UIImageView!
    @IBOutlet weak var textFragmentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
