//
//  NetworkService.swift
//  YITAssignment
//
//  Created by Nikita Koniukh on 12/09/2021.
//

import Foundation

class NetworkService {
    
    // MARK: - Error
    enum Error: Swift.Error {
        case api(Swift.Error)
        case parsing(Swift.Error)
        case missingData
    }
    
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public
    func load<T: Decodable>(url: URL, decoder: JSONDecoder = .init(), completion: @escaping (Result<T, Swift.Error>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            do {
                let response: T = try self.handleResponse(decoder: decoder, data: data, response: urlResponse, error: error)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Private
    private func handleResponse<T: Decodable>(decoder: JSONDecoder = .init(), data: Data?, response: URLResponse?, error: Swift.Error?) throws -> T {
        if let error = error {
            throw Error.api(error)
        }
        
        guard let data = data else {
            throw Error.missingData
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw Error.parsing(error)
        }
    }
}

// MARK: - LocalizedError
extension NetworkService.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .api(let error):
            return NSLocalizedString("Api error: \(error.localizedDescription)", comment: "")
        case .parsing(let error):
            return NSLocalizedString("Parsing error: \(error.localizedDescription)", comment: "")
        case .missingData:
            return NSLocalizedString("Missing data", comment: "")
        }
    }
}
