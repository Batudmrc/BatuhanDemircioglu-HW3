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
    
    let spinner = UIActivityIndicatorView(style: .large)
    var spinnerBackgroundView: UIView = UIView()
    var word: String?
   
    var viewModel: DetailViewModelProtocol = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneticImageTapped))
        pronounceImage.isUserInteractionEnabled = true
        pronounceImage.addGestureRecognizer(tapGesture)
        viewModel.fetchWordData(word: word!)
        viewModel.fetchSynData(word: word!)
        setupButtons()
        setupTableView()
        setupCollectionView()
        setupSpinner()
    }
    
    @objc func phoneticImageTapped() {
        viewModel.playPronunciationAudio()
    }
    
    @IBAction func nounTapped(_ sender: Any) {
        updateButtonBorderColor(sender: nounButton)
        viewModel.toggleFilterSection(filter: "Noun")
    }
    
    @IBAction func verbTapped(_ sender: Any) {
        updateButtonBorderColor(sender: verbButton)
        viewModel.toggleFilterSection(filter: "Verb")
    }
    
    @IBAction func adjTapped(_ sender: Any) {
        updateButtonBorderColor(sender: adjButton)
        viewModel.toggleFilterSection(filter: "Adjective")
    }
    
    @IBAction func adverbTapped(_ sender: Any) {
        updateButtonBorderColor(sender: adverbButton)
        viewModel.toggleFilterSection(filter: "Adverb")
    }
    
    func updateButtonBorderColor(sender: UIButton) {
        let isSelected = !viewModel.getSelectedFilters().contains(sender.titleLabel?.text ?? "")
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = isSelected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
            sender.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.black.cgColor
            sender.layer.borderWidth = isSelected ? 2.0 : 1.0
        })
    }
    
    func updateButtonStates() {
        guard viewModel.getIsDataLoaded() else {
            disableAllButtons()
            return
        }
        nounButton.isEnabled = viewModel.getSelectedFilters().firstIndex(of: "Noun") == nil && !viewModel.getNounArray().isEmpty
        verbButton.isEnabled = viewModel.getSelectedFilters().firstIndex(of: "Verb") == nil && !viewModel.getVerbArray().isEmpty
        adjButton.isEnabled = viewModel.getSelectedFilters().firstIndex(of: "Adjective") == nil && !viewModel.getAdjArray().isEmpty
        adverbButton.isEnabled = viewModel.getSelectedFilters().firstIndex(of: "Adverb") == nil && !viewModel.getAdverbArray().isEmpty
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
        viewModel.numberOfSyns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynCollectionViewCell.identifier, for: indexPath) as! SynCollectionViewCell
        
        let syns = viewModel.getSynArray
        if indexPath.row < syns!.count {
            let syn = syns![indexPath.row]
            cell.setup(syn: syn.word!)
        } else {
            navigationController?.popViewController(animated: true)
        }
        return cell
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSelectedFilters().isEmpty ? viewModel.getSections().count : viewModel.getSelectedFilters().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getSelectedFilters().isEmpty {
            return viewModel.getDefinitionsForSection(section).count
        } else {
            let filter = viewModel.getSelectedFilters()[section]
            return viewModel.getDefinitionsForFilter(filter).definitions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeaningsTableViewCell.identifier, for: indexPath) as! MeaningsTableViewCell
        
        var partOfSpeech = ""
        let definitions: [Definition]
        if viewModel.getSelectedFilters().isEmpty {
            definitions = viewModel.getDefinitionsForSection(indexPath.section)
            partOfSpeech = viewModel.getPartOfSpeechForSection(indexPath.section)
        } else {
            let filter = viewModel.getSelectedFilters()[indexPath.section]
            let result = viewModel.getDefinitionsForFilter(filter)
            definitions = result.definitions
            partOfSpeech = result.partOfSpeech
        }
        
        let meaning = definitions[indexPath.row]
        cell.meaningLabel.text = meaning.definition
        cell.countLabel.text = String(indexPath.row + 1)
        if meaning.example == nil {
            cell.exampleLabel.isHidden = true
            cell.exampleTitle.isHidden = true
        } else {
            cell.exampleLabel.text = meaning.example
        }
        cell.selectionStyle = .none
        cell.categoryLabel.text = partOfSpeech
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.lightGray
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 12, width: headerView.frame.width - 32, height: headerView.frame.height - 24))
        
        let sectionTitle: String
        if viewModel.getSelectedFilters().isEmpty {
            sectionTitle = viewModel.getSections()[section]
        } else {
            sectionTitle = viewModel.getSelectedFilters()[section]
        }
        
        titleLabel.text = sectionTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        titleLabel.isHidden = tableView.numberOfRows(inSection: section) == 0
        
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.numberOfRows(inSection: section) == 0 {
            return 0
        } else {
            return 40
        }
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateLabels(wordText: String, phoneticText: String) {
        wordLabel.text = wordText
        phoneticLabel.text = phoneticText
    }
    
    func reloadTableViewData() {
        UIView.transition(with: tableView, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }

    func reloadCollectionViewData() {
        UIView.transition(with: collectionView, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }

    
    func showLoading() {
        spinnerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Apply a blur effect to the background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = spinnerBackgroundView.bounds
        spinnerBackgroundView.addSubview(blurView)
        
        view.addSubview(spinnerBackgroundView)
        spinnerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        spinnerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        spinnerBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinnerBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.white
        spinner.startAnimating()
        spinnerBackgroundView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: spinnerBackgroundView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerBackgroundView.centerYAnchor).isActive = true
    }

    func hideLoading() {
        self.spinner.stopAnimating()
        self.spinnerBackgroundView.removeFromSuperview()
    }
}
