//
//  CharacterService.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 01/09/2021.
//

import UIKit

class CharacterService {
    
    func fetchCharacters(completion: @escaping([Character]?)->Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            // Needs to check errors and response for status code 200
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let characters = try JSONDecoder().decode(Characters.self, from: data)
                DispatchQueue.main.async {
                    completion(characters.results)
                }
            } catch {
                print("Failed to decode with error: \(error)")
                completion(nil)
            }
            
        }
        task.resume()
        
    }
    
  
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion( UIImage(data: data)!)
            }
        }
    }
}
