//
//  TestCollectionViewCell.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 28.05.2023.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var cardView: UIView!
    static let identifier = String(describing: TestCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 18
        cardView.layer.borderColor = UIColor.gray.cgColor

        cardView.layer.cornerRadius = 20
        //button.layer.borderWidth = 1
        //button.layer.cornerRadius = 18
        //button.layer.borderColor = UIColor.gray.cgColor
        //button.backgroundColor = UIColor.white
        //button.titleLabel?.textColor = UIColor.black
        
    }
}
