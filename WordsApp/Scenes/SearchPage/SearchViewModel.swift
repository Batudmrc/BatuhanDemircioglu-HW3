//
//  SearchViewModel.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 30.05.2023.
//

import Foundation
import NetworkPackage


protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    func checkData(word: String)
    func numberOfItemsInSection(_ section: Int) -> Int
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
    func numberOfItemsInSection(_ section: Int) -> Int {
        return 5
    }
    
    func checkData(word: String) {
        checkWrittenWord(word: word)
    }
}
