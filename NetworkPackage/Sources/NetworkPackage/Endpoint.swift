//
//  Endpoint.swift
//  
//
//  Created by Batuhan Demircioğlu on 26.05.2023.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    
    func request() -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Endpoint<T: Decodable> {
    case getWord(word: String)
    case getSyn(word: String)
}

extension Endpoint: EndpointProtocol  {
    var baseURL: String {
        switch self {
        case .getWord(_):
            return "https://api.dictionaryapi.dev"
        case .getSyn(_):
            return "https://api.datamuse.com"
        }
    }
    
    var path: String {
        switch self {
        case .getWord(let word):
            return "/api/v2/entries/en/\(word)"
        case .getSyn(let word):
            return "/words?rel_syn=\(word)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWord:
            return .get
        case .getSyn:
            return .get
        }
    }
    var header: [String : String]? {
        return nil
    }
    
    func request() -> URLRequest {
        let urlString = baseURL + path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        print(request)
        return request
    }

}
