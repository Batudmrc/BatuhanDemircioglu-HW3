//
//  DetailViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 27.05.2023.
//

import UIKit
import NetworkPackage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var pronounceImage: UIImageView!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var nounButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var verbButton: UIButton!
    @IBOutlet weak var adjButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adverbButton: UIButton!
    var nounArray: [Definition] = []
    var verbArray: [Definition] = []
    var adjArray: [Definition] = []
    var adverbArray: [Definition] = []
    var combinedArray: [Definition] = []
    var wordArray: [WordElement]?
    var sections: [String] = ["Noun", "Verb", "Adjective", "Adverb"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWord(word: "home")
        setupButtons()
        setupTableView()
        setupCollectionView()
        
    }
    
    @IBAction func nounTapped(_ sender: Any) {
        print("abc")
    }
    
    @IBAction func verbTapped(_ sender: Any) {
        
    }
    
    @IBAction func adjTapped(_ sender: Any) {
        
    }
    
    @IBAction func adverbTapped(_ sender: Any) {
        
    }
    
    func setupCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: SynCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SynCollectionViewCell.identifier)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 3
            flowLayout.minimumLineSpacing = 12
        }
    }
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib(nibName: MeaningsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MeaningsTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    func fetchWord(word: String) {
        NetworkManager.shared.getWord(word: word) { [weak self] (result: Result<[WordElement], Error>) in
            switch result {
            case .success(let wordArray):
                self?.wordArray = wordArray
                self?.processMeanings()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    //print(self!.verbArray[0].definition)
                }
            case .failure(let error):
                print("Word API Failure:", error)
            }
        }
    }
    
    func processMeanings() {
        nounArray.removeAll()
        verbArray.removeAll()
        adjArray.removeAll()
        adverbArray.removeAll()
        
        for word in wordArray ?? [] {
            if let meanings = word.meanings {
                for meaning in meanings {
                    if let partOfSpeech = meaning.partOfSpeech, let definitions = meaning.definitions {
                        switch partOfSpeech {
                        case "noun":
                            nounArray.append(contentsOf: definitions)
                        case "verb":
                            verbArray.append(contentsOf: definitions)
                        case "adjective":
                            adjArray.append(contentsOf: definitions)
                        case "adverb":
                            adverbArray.append(contentsOf: definitions)
                        default:
                            break
                        }
                    }
                }
            }
        }
        print(verbArray)
        combinedArray = nounArray + verbArray + adjArray + adverbArray
    }
    
    
    
    func fetchSyn(word: String) {
        NetworkManager.shared.getSyn(word: word) { (result: Result<[Synonym], Error>) in
            switch result {
            case .success(let syn):
                print("Synonym API Success:", syn)
            case .failure(let error):
                print("Synonym API Failure:", error)
            }
        }
    }
    
    func setupButtons() {
        let boldFont = UIFont.boldSystemFont(ofSize: 16) // Adjust the font size as needed
        
        verbButton.titleLabel?.font = boldFont
        nounButton.titleLabel?.font = boldFont
        adjButton.titleLabel?.font = boldFont
        adverbButton.titleLabel?.font = boldFont
        
        verbButton.layer.borderWidth = 1
        verbButton.layer.cornerRadius = 18
        verbButton.layer.borderColor = UIColor.gray.cgColor
        verbButton.backgroundColor = UIColor.white
        verbButton.titleLabel?.textColor = UIColor.black
        
        nounButton.layer.borderWidth = 1
        nounButton.layer.cornerRadius = 20
        nounButton.layer.borderColor = UIColor.gray.cgColor
        nounButton.backgroundColor = UIColor.white
        nounButton.titleLabel?.textColor = UIColor.black
        
        adjButton.layer.borderWidth = 1
        adjButton.layer.cornerRadius = 18
        adjButton.layer.borderColor = UIColor.gray.cgColor
        adjButton.backgroundColor = UIColor.white
        adjButton.titleLabel?.textColor = UIColor.black
        
        adverbButton.layer.borderWidth = 1
        adverbButton.layer.cornerRadius = 20
        adverbButton.layer.borderColor = UIColor.gray.cgColor
        adverbButton.backgroundColor = UIColor.white
        adverbButton.titleLabel?.textColor = UIColor.black
        
        verbButton.isHighlighted = false
        nounButton.isHighlighted = false
        adjButton.isHighlighted = false
        adverbButton.isHighlighted = false
    }
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynCollectionViewCell.identifier, for: indexPath) as! SynCollectionViewCell
        return cell
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return nounArray.count
        case 1:
            return verbArray.count
        case 2:
            return adjArray.count
        case 3:
            return adverbArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeaningsTableViewCell.identifier, for: indexPath) as! MeaningsTableViewCell
        
        var meaning: Definition?
        var partOfSpeech: String = ""
        
        switch indexPath.section {
        case 0:
            meaning = nounArray[indexPath.row]
            partOfSpeech = "Noun"
        case 1:
            meaning = verbArray[indexPath.row]
            partOfSpeech = "Verb"
        case 2:
            meaning = adjArray[indexPath.row]
            partOfSpeech = "Adjective"
        case 3:
            meaning = adverbArray[indexPath.row]
            partOfSpeech = "Adverb"
        default:
            break
        }
        
        cell.countLabel.text = String(indexPath.row + 1)
        cell.meaningLabel.text = meaning?.definition
        cell.categoryLabel.text = partOfSpeech
        
        if let example = meaning?.example {
            cell.exampleLabel.text = example
            cell.exampleTitle.isHidden = false
            cell.exampleLabel.isHidden = false
        } else {
            cell.exampleTitle.isHidden = true
            cell.exampleLabel.isHidden = true
        }
        
        return cell
    }
    
}
