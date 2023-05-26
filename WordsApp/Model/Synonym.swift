//
//  Synonym.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//
import Foundation

// MARK: - Syn
public struct Synonym: Codable {
    public let word: String?
    public let score: Int?

    public init(word: String?, score: Int?) {
        self.word = word
        self.score = score
    }
}

