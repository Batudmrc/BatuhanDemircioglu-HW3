//
//  DetailViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 27.05.2023.
//

import UIKit
import NetworkPackage
import AVFoundation

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
    var word: String?
    var selectedFilter: String?
    var nounArray: [Definition] = []
    var verbArray: [Definition] = []
    var adjArray: [Definition] = []
    var adverbArray: [Definition] = []
    var combinedArray: [Definition] = []
    var wordArray: [WordElement]?
    var synArray: [Synonym]?
    var sections: [String] = ["Noun", "Verb", "Adjective", "Adverb"]
    var isDataLoaded: Bool = false
    var audioPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneticImageTapped))
        pronounceImage.isUserInteractionEnabled = true
        pronounceImage.addGestureRecognizer(tapGesture)
        fetchWord(word: word!)
        fetchSyn(word: word!)
        setupButtons()
        setupTableView()
        setupCollectionView()
        
    }
    
    @objc func phoneticImageTapped() {
        playPronunciationAudio()
        print("abc")
    }
    
    func updatePhoneticsImageViewVisibility() {
        // Check if the wordArray contains data
        guard let wordArray = wordArray else {
            pronounceImage.isHidden = true
            return
        }
        
        var audioURL: URL?
        
        // Look for a valid pronunciation URL in different indices of phonetics
        for phonetic in wordArray[0].phonetics ?? [] {
            if let audioURLString = phonetic.audio,
               let url = URL(string: audioURLString) {
                audioURL = url
                pronounceImage.isHidden = false
                break
            }
        }
        
        // Check if a valid audio URL was found
        if audioURL != nil {
            // Valid audio URL found, show the phoneticsImageView
            pronounceImage.isHidden = false
        } else {
            // No valid audio URL found, hide the phoneticsImageView
            pronounceImage.isHidden = true
        }
    }
    
    
    func playPronunciationAudio() {
        // Check if the wordArray contains data
        guard let wordArray = wordArray else {
            return
        }
        
        var audioURL: URL?
        
        // Look for a valid pronunciation URL in different indices of phonetics
        for phonetic in wordArray[0].phonetics ?? [] {
            if let audioURLString = phonetic.audio,
               let url = URL(string: audioURLString) {
                audioURL = url
                break
            }
        }
        
        // Check if a valid audio URL was found
        if let finalAudioURL = audioURL {
            // Create an AVPlayer with the audio URL
            let playerItem = AVPlayerItem(url: finalAudioURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer?.play()
        } else {
            // No valid audio URL found, hide the phoneticsImageView
            pronounceImage.isHidden = true
        }
    }
    
    
    
    @IBAction func nounTapped(_ sender: Any) {
        print("abc")
        updateButtonBorderColor(sender: nounButton)
        toggleFilterSection(filter: "Noun")
    }
    
    @IBAction func verbTapped(_ sender: Any) {
        updateButtonBorderColor(sender: verbButton)
        toggleFilterSection(filter: "Verb")
    }
    
    @IBAction func adjTapped(_ sender: Any) {
        updateButtonBorderColor(sender: adjButton)
        toggleFilterSection(filter: "Adjective")
    }
    
    @IBAction func adverbTapped(_ sender: Any) {
        updateButtonBorderColor(sender: adverbButton)
        toggleFilterSection(filter: "Adverb")
    }
    
    func toggleFilterSection(filter: String) {
        if selectedFilter == filter {
            selectedFilter = nil
        } else {
            selectedFilter = filter
        }
        
        
        UIView.transition(with: tableView, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
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
        // Automatic resize the cell's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(UINib(nibName: MeaningsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MeaningsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
    }
    func onDataLoaded() {
        isDataLoaded = true
        updateButtonStates()
    }
    
    func fetchWord(word: String) {
        NetworkManager.shared.getWord(word: word) { [weak self] (result: Result<[WordElement], Error>) in
            switch result {
            case .success(let wordArray):
                self?.wordArray = wordArray
                self?.processMeanings()
                DispatchQueue.main.async {
                    self?.wordLabel.text = word.capitalized
                    self?.phoneticLabel.text = wordArray[0].phonetic
                    self!.onDataLoaded()
                    self?.tableView.reloadData()
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
    }
    
    func updateButtonBorderColor(sender: UIButton) {
        let borderWidth: CGFloat = 2.0
        let blackColor = UIColor.black.cgColor
        let blueColor = UIColor.blue.cgColor
        
        // Check if the selected button's border color is already blue
        let isAlreadySelected = sender.layer.borderColor == blueColor
        
        // Reset all button border colors and widths
        UIView.animate(withDuration: 0.3) {
            self.nounButton.layer.borderColor = blackColor
            self.nounButton.layer.borderWidth = 1.0
            self.verbButton.layer.borderColor = blackColor
            self.verbButton.layer.borderWidth = 1.0
            self.adjButton.layer.borderColor = blackColor
            self.adjButton.layer.borderWidth = 1.0
            self.adverbButton.layer.borderColor = blackColor
            self.adverbButton.layer.borderWidth = 1.0
        }
        
        // Set the border color and width of the selected button with animation
        UIView.animate(withDuration: 0.3) {
            if isAlreadySelected {
                sender.layer.borderColor = blackColor
                sender.layer.borderWidth = 1.0
            } else {
                sender.layer.borderColor = blueColor
                sender.layer.borderWidth = borderWidth
            }
        }
    }
    
    func fetchSyn(word: String) {
        NetworkManager.shared.getSyn(word: word) { (result: Result<[Synonym], Error>) in
            switch result {
            case .success(let syn):
                print("Synonym API Success:", syn)
                self.synArray = syn
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
        verbButton.layer.borderColor = UIColor.black.cgColor
        verbButton.backgroundColor = UIColor.white
        verbButton.titleLabel?.textColor = UIColor.black
        
        nounButton.layer.borderWidth = 1
        nounButton.layer.cornerRadius = 20
        nounButton.layer.borderColor = UIColor.black.cgColor
        nounButton.backgroundColor = UIColor.white
        nounButton.titleLabel?.textColor = UIColor.black
        
        adjButton.layer.borderWidth = 1
        adjButton.layer.cornerRadius = 18
        adjButton.layer.borderColor = UIColor.black.cgColor
        adjButton.backgroundColor = UIColor.white
        adjButton.titleLabel?.textColor = UIColor.black
        
        adverbButton.layer.borderWidth = 1
        adverbButton.layer.cornerRadius = 20
        adverbButton.layer.borderColor = UIColor.black.cgColor
        adverbButton.backgroundColor = UIColor.white
        adverbButton.titleLabel?.textColor = UIColor.black
        
        verbButton.isHighlighted = false
        nounButton.isHighlighted = false
        adjButton.isHighlighted = false
        adverbButton.isHighlighted = false
        
        disableAllButtons()
        
    }
    
    func updateButtonStates() {
        guard isDataLoaded else {
            // Data is not yet loaded, disable all buttons
            disableAllButtons()
            return
        }
        
        nounButton.isEnabled = selectedFilter != "Noun" && !nounArray.isEmpty
        verbButton.isEnabled = selectedFilter != "Verb" && !verbArray.isEmpty
        adjButton.isEnabled = selectedFilter != "Adjective" && !adjArray.isEmpty
        adverbButton.isEnabled = selectedFilter != "Adverb" && !adverbArray.isEmpty
        
        // Update button appearance based on enabled/disabled state
        updateButtonAppearance(nounButton)
        updateButtonAppearance(verbButton)
        updateButtonAppearance(adjButton)
        updateButtonAppearance(adverbButton)
    }
    func disableAllButtons() {
        nounButton.isEnabled = false
        verbButton.isEnabled = false
        adjButton.isEnabled = false
        adverbButton.isEnabled = false
        
        // Update button appearance for all buttons
        updateButtonAppearance(nounButton)
        updateButtonAppearance(verbButton)
        updateButtonAppearance(adjButton)
        updateButtonAppearance(adverbButton)
    }
    
    func updateButtonAppearance(_ button: UIButton) {
        let isEnabled = button.isEnabled
        let borderColor: UIColor = isEnabled ? .black : .gray
        let borderWidth: CGFloat = isEnabled ? 1.0 : 0.0
        
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = borderWidth
    }
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynCollectionViewCell.identifier, for: indexPath) as! SynCollectionViewCell
        //cell.synLabel.text = synArray![indexPath.row].word
        return cell
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedFilter != nil ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filter = selectedFilter {
            switch filter {
            case "Noun":
                return nounArray.count
            case "Verb":
                return verbArray.count
            case "Adjective":
                return adjArray.count
            case "Adverb":
                return adverbArray.count
            default:
                return 0
            }
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeaningsTableViewCell.identifier, for: indexPath) as! MeaningsTableViewCell
        
        if let filter = selectedFilter {
            var meaning: Definition?
            var partOfSpeech: String = ""
            
            switch filter {
            case "Noun":
                meaning = nounArray[indexPath.row]
                partOfSpeech = "Noun"
            case "Verb":
                meaning = verbArray[indexPath.row]
                partOfSpeech = "Verb"
            case "Adjective":
                meaning = adjArray[indexPath.row]
                partOfSpeech = "Adjective"
            case "Adverb":
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
        } else {
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let filter = selectedFilter {
            return filter
        } else {
            return sections[section]
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.lightGray
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 12, width: headerView.frame.width - 32, height: headerView.frame.height - 24))
        
        if let filter = selectedFilter {
            titleLabel.text = filter
        } else {
            titleLabel.text = sections[section]
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        
        if tableView.numberOfRows(inSection: section) == 0 {
            titleLabel.isHidden = true
        } else {
            titleLabel.isHidden = false
        }
        
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let filter = selectedFilter {
            if filter == sections[section] && tableView.numberOfRows(inSection: section) == 0 {
                return 0
            }
        } else {
            if tableView.numberOfRows(inSection: section) == 0 {
                return 0
            }
        }
        return 40
    }
    
    
}
