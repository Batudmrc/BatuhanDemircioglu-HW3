//
//  DetailViewModel.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 31.05.2023.
//

import Foundation
import NetworkPackage
import AVFoundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    var numberOfSyns: Int { get }
    var getSynArray: [Synonym]? { get }
    
    func fetchWordData(word: String)
    func fetchSynData(word: String)
    func processMeanings()
    func playPronunciationAudio()
    func getDefinitionsForSection(_ section: Int) -> [Definition]
    func getPartOfSpeechForSection(_ section: Int) -> String
    func getDefinitionsForFilter(_ filter: String) -> (definitions: [Definition], partOfSpeech: String)
    func getSelectedFilters() -> [String]
    func getSections() -> [String]
    func getNounArray() -> [Definition]
    func getVerbArray() -> [Definition]
    func getAdjArray() -> [Definition]
    func getAdverbArray() -> [Definition]
    func toggleFilterSection(filter: String)
    func onDataLoaded()
    func getIsDataLoaded() -> Bool
}

protocol DetailViewModelDelegate: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadTableViewData()
    func reloadCollectionViewData()
    func updateLabels(wordText: String, phoneticText: String)
    func showErrorMessage(title: String, message: String)
    func updateButtonStates()
}

final class DetailViewModel {
    weak var delegate: DetailViewModelDelegate?
    var nounArray: [Definition] = []
    var verbArray: [Definition] = []
    var adjArray: [Definition] = []
    var adverbArray: [Definition] = []
    var combinedArray: [Definition] = []
    var wordArray: [WordElement]?
    var synArray: [Synonym] = []
    var audioPlayer: AVPlayer?
    var isDataLoaded: Bool = false
    var sections: [String] = ["Noun", "Verb", "Adjective", "Adverb"]
    var selectedFilters: [String] = []
    
    func fetchWord(word: String) {
        DispatchQueue.main.async {
            self.delegate?.showLoading()
        }
        NetworkManager.shared.getWord(word: word) { [weak self] (result: Result<[WordElement], Error>) in
            switch result {
            case .success(let wordArray):
                self?.wordArray = wordArray
                self?.processMeanings()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self?.delegate?.updateLabels(wordText: word.capitalized, phoneticText: wordArray[0].phonetic ?? "no phonetics found")
                    self?.onDataLoaded()
                    print(word.capitalized)
                    self?.delegate?.reloadTableViewData()
                    self?.delegate?.hideLoading() // Hide loading animation after a slight delay
                }
            case .failure(let error):
                print("Word API Failure:", error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.delegate?.showErrorMessage(title: "Error", message: "Failed to fetch word. Please try again later.")
                    self?.delegate?.hideLoading() // Hide loading animation after a slight delay
                }
            }
        }
    }
    
    func fetchSyn(word: String) {
        NetworkManager.shared.getSyn(word: word) { [weak self] (result: Result<[Synonym], Error>) in
            switch result {
            case .success(let syn):
                print("Synonym API Success:", syn)
                self?.synArray = syn
                DispatchQueue.main.async {
                    self?.delegate?.reloadCollectionViewData()
                }
            case .failure(let error):
                print("Synonym API Failure:", error)
                DispatchQueue.main.async {
                    // Display an error message to the user
                    self!.delegate?.showErrorMessage(title: "Error", message: "Cant Fetch Syn Data")
                }
            }
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {    
    func getIsDataLoaded() -> Bool {
        return isDataLoaded
    }
    
    func getVerbArray() -> [Definition] {
        return verbArray
    }
    
    func getAdjArray() -> [Definition] {
        return adjArray
    }
    
    func getAdverbArray() -> [Definition] {
        return adverbArray
    }
    
    func onDataLoaded() {
        isDataLoaded = true
        delegate?.updateButtonStates()
    }
    
    func getNounArray() -> [Definition] {
        return nounArray
    }
    
    func toggleFilterSection(filter: String) {
        if selectedFilters.contains(filter) {
            selectedFilters.removeAll { $0 == filter }
        } else {
            selectedFilters.append(filter)
        }
        self.delegate?.reloadTableViewData()
    }
    
    func getSelectedFilters() -> [String] {
        return selectedFilters
    }
    
    func getSections() -> [String] {
        return sections
    }
    
    func getDefinitionsForFilter(_ filter: String) -> (definitions: [Definition], partOfSpeech: String) {
        var partOfSpeech: String = ""
        
        switch filter {
        case "Noun":
            partOfSpeech = "Noun"
            return (definitions: nounArray, partOfSpeech: partOfSpeech)
        case "Verb":
            partOfSpeech = "Verb"
            return (definitions: verbArray, partOfSpeech: partOfSpeech)
        case "Adjective":
            partOfSpeech = "Adjective"
            return (definitions: adjArray, partOfSpeech: partOfSpeech)
        case "Adverb":
            partOfSpeech = "Adverb"
            return (definitions: adverbArray, partOfSpeech: partOfSpeech)
        default:
            return (definitions: [], partOfSpeech: "")
        }
    }
    
    func getPartOfSpeechForSection(_ section: Int) -> String {
        switch section {
        case 0:
            return "Noun"
        case 1:
            return "Verb"
        case 2:
            return "Adjective"
        case 3:
            return "Adverb"
        default:
            return "-"
        }
    }
    
    func getDefinitionsForSection(_ section: Int) -> [Definition] {
        switch section {
        case 0:
            return nounArray
        case 1:
            return verbArray
        case 2:
            return adjArray
        case 3:
            return adverbArray
        default:
            return []
        }
    }
    
    var getSynArray: [Synonym]? {
        return synArray
    }
    
    var numberOfSyns: Int {
        if synArray.count <= 5 {
            return synArray.count
        } else {
            return 5
        }
    }

    func playPronunciationAudio() {
        guard let wordArray = wordArray else {
            return
        }
        var audioURL: URL?
        for phonetic in wordArray[0].phonetics ?? [] {
            if let audioURLString = phonetic.audio,
               let url = URL(string: audioURLString) {
                audioURL = url
                break
            }
        }
        if let finalAudioURL = audioURL {
            let playerItem = AVPlayerItem(url: finalAudioURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer?.play()
        } else {
            self.delegate?.showErrorMessage(title: "Error", message: "No audio file found.")
        }
    }
    
    func fetchWordData(word: String) {
        fetchWord(word: word)
    }
    
    func fetchSynData(word: String) {
        fetchSyn(word: word)
    }
    // Put definitions to related array as their partOfSpeech
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
}

