//
//  EpisodeService.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import Foundation

class EpisodeService {
    func fetchEpisodes(urlArray: [String], completion: @escaping([Episode]?)->Void) {
        var episodesArray = [Episode]()
        for urlString in urlArray {
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                
                // Needs to check errors and response for status code 200
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let episode = try JSONDecoder().decode(Episode.self, from: data)
                    DispatchQueue.main.async {
                        episodesArray.append(episode)
                        if episodesArray.count == urlArray.count {
                            completion(episodesArray)
                        }
                    }
                } catch {
                    print("Failed to decode with error: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        }
    }
}
