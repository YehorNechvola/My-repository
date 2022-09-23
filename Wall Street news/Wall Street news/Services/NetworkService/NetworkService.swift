//
//  NetworkService.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import Foundation
import UIKit

//MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func getJournal(url: String, completion: @escaping(Result <Journal, Error>) -> Void)
    func getImagesForArticles(articles: [Article]) -> [Data]
}

class NetworkService: NetworkServiceProtocol {
    
    //MARK: - Properties
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    //MARK: - Methods
    
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
    func getImagesForArticles(articles: [Article]) -> [Data] {
        let queue = DispatchQueue(label: "imagesQueue", qos: .userInteractive, attributes: .concurrent)
        var images = [Data]()
        queue.sync {
            articles.forEach { article in
                guard let urlToImage = article.urlToImage else { return }
                guard let url = URL(string: urlToImage) else { return }
                do {
                    let imageData = try Data(contentsOf: url)
                    images.append(imageData)
                } catch {
                    print(error)
                }
            }
        }
        return images
    }
}
