//
//  DetailPage+UISetup.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 1.06.2023.
//

import Foundation
import UIKit

extension DetailViewController {
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
    
    func disableAllButtons() {
        nounButton.isEnabled = false
        verbButton.isEnabled = false
        adjButton.isEnabled = false
        adverbButton.isEnabled = false
    }
    
    func setupSpinner() {
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
}
