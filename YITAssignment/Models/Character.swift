//
//  Character.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import Foundation

struct Characters: Codable {
    var results: [Character]
}

struct Character: Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var location: Location
    var image: String
    var episode: [String]
}

struct Location: Codable {
    var name: String
}
