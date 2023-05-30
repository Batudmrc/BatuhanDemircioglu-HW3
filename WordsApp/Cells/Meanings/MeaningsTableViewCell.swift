//
//  MeaningsTableViewCell.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 29.05.2023.
//

import UIKit

class MeaningsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var exampleTitle: UILabel!
    static let identifier = String(describing: MeaningsTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


