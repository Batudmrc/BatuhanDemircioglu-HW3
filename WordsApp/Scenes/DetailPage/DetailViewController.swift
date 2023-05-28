//
//  DetailViewController.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 27.05.2023.
//

import UIKit

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        collectionView.register(UINib(nibName: TestCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TestCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.scrollDirection = .vertical
                    flowLayout.minimumInteritemSpacing = 3
                    flowLayout.minimumLineSpacing = 12
                }
        
        
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.identifier, for: indexPath) as! TestCollectionViewCell
        return cell
    }
    
    
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        return cell
    }
    
    
}
