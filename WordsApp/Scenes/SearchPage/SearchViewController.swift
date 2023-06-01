//
//  ViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var originalButtonFrame: CGRect!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var searchText: String?
    
    var viewModel: SearchViewModelProtocol = SearchViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        viewModel.loadHistory(context: context)
        reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkUtils.checkConnection(in: self) {
            NetworkUtils.retryButtonTapped(in: self)
        }
        viewModel.delegate = self
        setupUI()
        viewModel.loadHistory(context: context)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let text = searchBar.text, !text.isEmpty else {
            viewModel.delegate?.showErrorMessage(title: "Empty Search", message: "Please enter a word to search.")
            return
        }
        if viewModel.isConnected() {
            searchText = text
            viewModel.saveHistory(word: text, context: context)
            viewModel.checkData(word: text)
        } else {
            viewModel.delegate?.showErrorMessage(title: "Error", message: "Please check your connection")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.word = searchText
            }
        }
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
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        overlayView.addSubview(spinner)
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.3) {
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    
    func hideLoading() {
        if let overlayView = view.subviews.first(where: { $0.backgroundColor?.isEqual(UIColor.black.withAlphaComponent(0.4)) ?? false }) {
            UIView.animate(withDuration: 0.3, animations: {
                overlayView.alpha = 0.0
            }) { (_) in
                overlayView.removeFromSuperview()
            }
        }
    }
    
}


