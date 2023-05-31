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
    var searchHistory = [History]()
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
        viewModel.delegate = self
        setupUI()
        viewModel.loadHistory(context: context)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let text = searchBar.text, !text.isEmpty else {
            viewModel.delegate?.showErrorMessage(title: "Empty Search", message: "Please enter a word to search.")
            return
        }
        searchText = text
        viewModel.saveHistory(word: text, context: context)
        viewModel.checkData(word: text)
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
    func loadHistory() {
        let request: NSFetchRequest<History> = History.fetchRequest()
        do {
            searchHistory = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
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
        activityIndicator.alpha = 0.0
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


