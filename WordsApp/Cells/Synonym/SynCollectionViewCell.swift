//
//  TestCollectionViewCell.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 28.05.2023.
//

import UIKit

class SynCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var synLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    static let identifier = String(describing: SynCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 18
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.cornerRadius = 20

    }
}
