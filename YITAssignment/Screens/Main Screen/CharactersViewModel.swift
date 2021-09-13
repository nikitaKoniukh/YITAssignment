//
//  CharactersViewModel.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 12/09/2021.
//

import Foundation

class CharactersViewModel {
    
    // MARK: - Dependencies
    private let charactersProvider: CharactersProvider
    
    // MARK: - Init
    init(charactersProvider: CharactersProvider = .init()) {
        self.charactersProvider = charactersProvider
    }
    
    // MARK: - Private
    private var cashCharacters: [Character] = []
    
    // MARK: - Output
    var characters: [Character] = []
    var update: (() -> Void)?
    var error: ((Error) -> Void)?
    
    // MARK: - Input
    func loadCharacters() {
        charactersProvider.characters { result in
            switch result {
            case .success(let characters):
                self.characters = characters.results
                self.cashCharacters = characters.results
                self.update?()
            case .failure(let error):
                self.error?(error)
            }
        }
    }
    
    func filterCharacters(with searchText: String)  {
        if searchText.isEmpty == false {
            characters = cashCharacters.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        } else {
            characters = cashCharacters
        }
        update?()
    }
}
