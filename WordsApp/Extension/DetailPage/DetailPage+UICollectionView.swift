//
//  DetailPage+UICollectionView.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 31.05.2023.
//

import Foundation
import UIKit

extension DetailViewController {
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
}
