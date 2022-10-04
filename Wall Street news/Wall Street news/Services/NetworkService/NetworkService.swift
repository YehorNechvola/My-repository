//
//  NetworkService.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import Foundation

//MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func getJournal(url: String, completion: @escaping(Result <Journal, Error>) -> Void)
    func getImagesForArticles(articles: [Article], completion: @escaping ([String: Data]) -> Void)
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
    
    func getImagesForArticles(articles: [Article], completion: @escaping ([String: Data]) -> Void) {
        var imagesData = [String: Data]()
        let dispatchGroup = DispatchGroup()
        
        articles.forEach { article in
            guard let stringUrl = article.urlToImage else { return }
            
            guard let url = URL(string: stringUrl) else { return }
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let data = try Data(contentsOf: url)
                    imagesData[stringUrl] = data
                } catch (let error) {
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(imagesData)
        }
    }
}
