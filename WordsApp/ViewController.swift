//
//  ViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//

import UIKit
import NetworkPackage

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWord(word: "cow")
        fetchSyn(word: "food")
    }
    func fetchWord(word: String) {
        NetworkManager.shared.getWord(word: word) { (result: Result<[WordElement], Error>) in
            switch result {
            case .success(let word):
                print("Word API Success:")
            case .failure(let error):
                print("Word API Failure:", error)
            }
        }
    }
    
    func fetchSyn(word: String) {
        NetworkManager.shared.getSyn(word: word) { (result: Result<[Synonym], Error>) in
            switch result {
            case .success(let word):
                print("Synonym API Success:", word)
            case .failure(let error):
                print("Synonym API Failure:", error)
            }
        }
    }
}

