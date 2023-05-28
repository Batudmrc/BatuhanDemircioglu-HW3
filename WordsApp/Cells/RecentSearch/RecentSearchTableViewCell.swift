//
//  RecentSearchTableViewCell.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 27.05.2023.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchLabel: UILabel!
    static let identifier = String(describing: RecentSearchTableViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setup(word: String) {
        self.searchLabel.text = word
    }
}
