//
//  SearchViewController+UITableView.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 31.05.2023.
//

import Foundation
import UIKit

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as? RecentSearchTableViewCell else {
            return UITableViewCell()
        }
        
        var searchHistory: [History] {
            return viewModel.getSearchHistory().reversed()
        }
        cell.searchLabel.text = searchHistory[indexPath.row].word
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50  // Set the desired height for each cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecentSearchTableViewCell {
            if viewModel.isConnected() {
                let text = cell.searchLabel.text
                searchText = text
                viewModel.checkData(word: text!)
            } else {
                viewModel.delegate?.showErrorMessage(title: "Error", message: "Please check your connection")
            }
        }
    }
    
    
}
