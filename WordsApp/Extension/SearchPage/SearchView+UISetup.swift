//
//  SearchView+UISetup.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 31.05.2023.
//

import Foundation
import UIKit

extension SearchViewController {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let containsWhitespace = text.rangeOfCharacter(from: .whitespaces) != nil
        if containsWhitespace {
            return false
        }
        return true
    }
    
    func setupUI() {
        setupTableView()
        setupSearchBar()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: RecentSearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func setupSearchBar() {
        originalButtonFrame = searchButton.frame
        searchBar.delegate = self
        searchBar.placeholder = "Enter a word"
        searchBar.backgroundImage = UIImage() // Remove background image
        searchBar.searchBarStyle = .minimal // Apply minimal style
        searchBar.tintColor = .black // Set tint color for cursor and cancel button
        // Add padding to the left side of the search bar's leftBarButtonItem
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = searchTextField.leftView {
                searchTextField.leftViewMode = .always
                searchTextField.autocorrectionType = .no
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: leftView.frame.height)) // Adjust padding width here
                searchTextField.leftView = paddingView
                searchTextField.backgroundColor = .white
                paddingView.addSubview(leftView)
            }
        }
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOpacity = 0.3
        // Customize search bar text field
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black // Set text color
            textField.font = UIFont.systemFont(ofSize: 16) // Set font
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 8 // Set corner radius
            textField.layer.masksToBounds = true
            textField.autocorrectionType = .no
            // Clip to bounds
        }
    }
}
