//
//  NetworkService.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func getJournal(url: String, completion: @escaping(Result <Journal, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func getJournal(url: String, completion: @escaping (Result <Journal, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let journal = try self.decoder.decode(Journal.self, from: data)
                completion(.success(journal))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
}
