//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol RouteProtocol {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: String { get }
}

enum RickAndMortyAPI {
    case baseURL
    
    static let manager = NetworkManager.shared
    
    var url: URL {
        switch self {
        case .baseURL:
            return URL(string: "https://rickandmortyapi.com/api/")!
        }
    }
}

extension RickAndMortyAPI {
    enum CharacterRoute: RouteProtocol {
        case id(Int)
        case base([Filter])
        
        var path: String {
            switch self {
            case .id(let id):
                return "character/\(id)"
            case .base(_):
                return "character"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .id(_):
                return nil
            case .base(let filters):
                return filters.map { $0.queryItem() }
            }
        }
        
        var httpMethod: String {
            switch self {
            case .id:
                return "GET"
            case .base:
                return "GET"
            }
        }
        
        static func searchBy(id: Int) async throws -> Character? {
            try await manager.sendRequest(route: Self.id(id), decodeTo: Character.self)
        }
        
        static func searchWith(filters: [Filter]) async throws -> [Character]? {
            struct SearchWithFilterResponse: Decodable {
                let info: Info
                let results: [Character]
            }
            
            let response = try await manager.sendRequest(
                route: Self.base(filters),
                decodeTo: SearchWithFilterResponse.self
            )
            
            return response.results
        }
    }
}

enum Filter {
    case name(String)
    case status(String)
    case species(String)
    case type(String)
    case gender(String)
    case page(Int)
    
    func queryItem() -> URLQueryItem {
        switch self {
        case .name(let name):
            return URLQueryItem(name: "name", value: name)
        case .status(let status):
            return URLQueryItem(name: "status", value: status)
        case .species(let species):
            return URLQueryItem(name: "species", value: species)
        case .type(let type):
            return URLQueryItem(name: "type", value: type)
        case .gender(let gender):
            return URLQueryItem(name: "gender", value: gender)
        case .page(let page):
            return URLQueryItem(name: "page", value: page.formatted())
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL?, with completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func sendRequest<T: Decodable>(route: RouteProtocol, decodeTo type: T.Type) async throws -> T {
        var apiURL = RickAndMortyAPI.baseURL.url.appending(path: route.path)
        
        guard var urlComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = route.queryItems
        
        guard let endpointURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: endpointURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = route.httpMethod
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
    }
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data, NetworkError>) -> Void) {
            guard let url = URL(string: url ?? "") else {
                completion(.failure(.invalidURL))
                return
            }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: url) else {
                    completion(.failure(.noData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(imageData))
                }
            }
        }
}
