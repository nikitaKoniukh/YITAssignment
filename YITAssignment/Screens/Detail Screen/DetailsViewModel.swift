//
//  DetailsViewModel.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 12/09/2021.
//

import UIKit

class DetailsViewModel {
    // MARK: - Dependencies
    private let detailsProvider: DetailsProvider
    
    // MARK: - Init
    init(detailsProvider: DetailsProvider = .init()) {
        self.detailsProvider = detailsProvider
    }
    
    // MARK: - Output
    var episodes: [Episode] = []
    var update: (() -> Void)?
    var error: ((Error) -> Void)?
    
    // MARK: - Input
    func loadEpisodes(with episodesArray: [String]) {
        for (index, episode) in episodesArray.enumerated() {
            detailsProvider.episode(with: episode) { result in
                switch result {
                case .success(let e):
                    self.episodes.append(e)
                    if index + 1 == episodesArray.count {
                        self.update?()
                    }
                case .failure(let error):
                    self.error?(error)
                }
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion( UIImage(data: data)!)
            }
        }
    }
    
    // MARK: - Private
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
