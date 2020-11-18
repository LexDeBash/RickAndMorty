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

struct Episode: Decodable {
    let name: String
    let date: String
    let episode: String
    let characters: [String]
    
    var description: String {
        """
    episode: \(name)
    date: \(date)
    """
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case date = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}

enum URLS: String {
    case rickandmortyapi = "https://rickandmortyapi.com/api/character"
}
