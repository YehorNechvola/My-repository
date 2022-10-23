

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
    
    private var cashedData: NSCache <NSString, NSData> = {
        let cacher = NSCache <NSString, NSData>()
        let maxCountOfCashedObjects = 11
        cacher.countLimit = maxCountOfCashedObjects
        return cacher
    }()
    
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
        
        for a in articles {
            guard let stringUrl = a.urlToImage else { return }
            
            guard let url = URL(string: stringUrl) else { return }
            
            if let dataFromCasher = cashedData.object(forKey: stringUrl as NSString) {
                imagesData[stringUrl] = dataFromCasher as Data
            } else {
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    do {
                        let data = try Data(contentsOf: url)
                        imagesData[stringUrl] = data
                        self?.cashedData.setObject(data as NSData, forKey: stringUrl as NSString)
                    } catch (let error) {
                        print(error)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(imagesData)
        }
    }
}

