//
//  Character.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

struct RickAndMorty: Decodable {
    let info: Info
    let results: [Result]
}

struct Info: Decodable {
    let pages: Int
    let next: String?
    let prev: String?
}

struct Result: Decodable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    
    var description: String {
        """
    Name: \(name)
    Status: \(status)
    Species: \(species)
    Gender: \(gender)
    Origin: \(origin.name)
    Location: \(location.name)
    """
    }
}

struct Location: Decodable {
    let name: String
}

enum URLS: String {
    case rickandmortyapi = "https://rickandmortyapi.com/api/character"
}
