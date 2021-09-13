//
//  DetailsProvider.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 12/09/2021.
//

import Foundation

class DetailsProvider {
    
    // MARK: - Dependencies
    private let networkService: NetworkService
    
    // MARK: - Init
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    // MARK: - Public
    func episode(with episodeUrl: String, completion: @escaping(Result<Episode, Error>) -> Void) {
        let epiosodeUrl = URL(string: episodeUrl)!
        networkService.load(url: epiosodeUrl) { (result: Result<Episode, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
