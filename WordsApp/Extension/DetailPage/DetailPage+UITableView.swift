//
//  DetailPage+UITableView.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 31.05.2023.
//

import Foundation
import UIKit

extension DetailViewController {
    func setupTableView() {
        // Automatic resize the cell's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib(nibName: MeaningsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MeaningsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
}
