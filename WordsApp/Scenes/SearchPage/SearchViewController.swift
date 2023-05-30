//
//  ViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    private var originalButtonFrame: CGRect!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var searchText: String?
    
    var viewModel: SearchViewModelProtocol = SearchViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTableView()
        setupSearchBar()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let text = searchBar.text, !text.isEmpty else {
            // Search text is empty, show an error message to the user
            viewModel.delegate?.showErrorMessage(title: "Empty Search", message: "Please enter a word to search.")
            return
        }
        searchText = text
        viewModel.checkData(word: text)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.word = searchText
                print("go")
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as? RecentSearchTableViewCell else {
            return UITableViewCell()
        }
        let word = "Aarhus" // Replace with actual data
        cell.setup(word: word)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50  // Set the desired height for each cell
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check if the replacement text contains any whitespace
        let containsWhitespace = text.rangeOfCharacter(from: .whitespaces) != nil
        if containsWhitespace {
            return false
        }
        return true
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToDetailScreen() {
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    func showLoading() {
        activityIndicator.alpha = 0.0 // Set initial alpha to 0.0
        self.activityIndicator.center = self.view.center
        UIView.animate(withDuration: 0.3) {
            self.activityIndicator.alpha = 1.0
        }
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}


