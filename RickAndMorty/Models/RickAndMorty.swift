//
//  Character.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

struct RickAndMorty: Decodable {
    let results: [Character]
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
}

struct Origin: Decodable {
    let name: String
}

struct Location: Decodable {
    let name: String
}

enum URLS: String {
    case rickandmortyapi = "https://rickandmortyapi.com/api/character"
}
