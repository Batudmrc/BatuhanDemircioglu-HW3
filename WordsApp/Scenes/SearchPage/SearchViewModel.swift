//
//  SearchViewModel.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 30.05.2023.
//

import Foundation
import NetworkPackage
import CoreData

protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    func checkData(word: String)
    func numberOfItemsInSection(_ section: Int) -> Int
    func saveHistory(word: String, context: NSManagedObjectContext)
    func getSearchHistory() -> [History]
    func loadHistory(context: NSManagedObjectContext)
    func isConnected() -> Bool
}

protocol SearchViewModelDelegate: AnyObject {
    func reloadData()
    func showErrorMessage(title: String, message: String)
    func navigateToDetailScreen()
    func showLoading()
    func hideLoading()
}

final class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    var service: NetworkManagerProtocol?
    var context: NSManagedObjectContext?
    private var searchHistory: [History] = []
    // Check if the written word has a response, if it has navigate user to the detail view
    func checkWrittenWord(word: String) {
        self.delegate?.showLoading()
        NetworkManager.shared.getWord(word: word) { [weak self] (result: Result<[WordElement], Error>) in
            DispatchQueue.main.async {
                self?.delegate?.hideLoading()
            }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.delegate?.navigateToDetailScreen()
                }
            case .failure(let error):
                print("Failure:", error)
                DispatchQueue.main.async {
                    self?.delegate?.showErrorMessage(title: "Error", message: "This word does not exist.")
                }
            }
        }
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    // Load search history from Core Data and reload the table view.
    func loadHistory(context: NSManagedObjectContext) {
        let request: NSFetchRequest<History> = History.fetchRequest()
        do {
            searchHistory = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func isConnected() -> Bool {
        return NetworkUtility.checkNetworkConnectivity()
    }
    
    func getSearchHistory() -> [History] {
        return searchHistory
    }
    // Save searchHistory to the CoreData
    func saveHistory(word: String, context: NSManagedObjectContext) {
        let newHistory = History(context: context)
        newHistory.word = word
        searchHistory.append(newHistory)
        do {
            try context.save()
        } catch {
            print("Failed to save search history: \(error)")
        }
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        let uniqueWords = Set(searchHistory.compactMap { $0.word })
        if uniqueWords.count > 5 {
            return 5
        } else {
            return uniqueWords.count
        }
    }
    
    func checkData(word: String) {
        checkWrittenWord(word: word)
    }
}
