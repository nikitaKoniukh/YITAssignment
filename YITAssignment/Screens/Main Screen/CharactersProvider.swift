//
//  CharactersProvider.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 12/09/2021.
//

import Foundation

class CharactersProvider {
    
    // MARK: - Constants
    enum Constants {
        static let charactersUrl = URL(string: "https://rickandmortyapi.com/api/character")!
    }
    
    // MARK: - Dependencies
    private let networkService: NetworkService
    
    // MARK: - Init
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    // MARK: - Public
    func characters(completion: @escaping(Result<Characters, Error>) -> Void) {
        networkService.load(url: Constants.charactersUrl) { (result: Result<Characters, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
