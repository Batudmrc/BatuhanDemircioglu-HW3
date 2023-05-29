//
//  ViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//

import UIKit
import NetworkPackage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    private var originalButtonFrame: CGRect!
    var searchText: String?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchSyn(word: "team")
        setupSearchBar()
        
        tableView.register(UINib(nibName: RecentSearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let text = searchBar.text else {
            return
        }
        searchText = text
        performSegue(withIdentifier: "toDetailVC", sender: nil)
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
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let buttonFrame = view.convert(searchButton.frame, from: searchButton.superview)
            let buttonBottom = buttonFrame.origin.y + buttonFrame.size.height
            
            let keyboardHeight = keyboardSize.height
            let viewHeight = view.frame.size.height
            
            let offsetY = buttonBottom - (viewHeight - keyboardHeight)
            
            if offsetY > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.searchButton.frame.origin.y -= offsetY
                    self.tableView.contentOffset.y += offsetY // Scroll the table view to keep the button visible
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? DetailViewController {
                print("go")
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            self.searchButton.frame = self.originalButtonFrame
        }
    }
    
    deinit {
        // Unregister from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
    
}


