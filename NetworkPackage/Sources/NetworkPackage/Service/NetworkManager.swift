//
//  NetworkManager.swift
//  
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//

import Foundation

public protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, Error>) -> Void)
}

public class NetworkManager: NetworkManagerProtocol {
    
    public static let shared = NetworkManager()
    private init() {}
    
    public func request<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200, response.statusCode <= 299 else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid Response Data", code: 0)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    public func getWord<T: Decodable>(word: String, completion: @escaping(Result<[T], Error>) -> Void) {
        let endpoint = Endpoint<[T]>.getWord(word: word)
        request(endpoint, completion: completion)
    }
    
    public func getSyn<T: Decodable>(word: String, completion: @escaping(Result<[T], Error>) -> Void) {
        let endpoint = Endpoint<[T]>.getSyn(word: word)
        request(endpoint, completion: completion)
    }
}

