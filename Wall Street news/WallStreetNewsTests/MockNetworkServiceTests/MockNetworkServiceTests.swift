

import XCTest
@testable import Wall_Street_news

// MARK: - MockNetworkService

class MockNetworService: NetworkServiceProtocol {
    
    var journal: Journal!
    
    init() {}
    convenience init(journal: Journal?) {
        self.init()
        self.journal = journal
    }
    
    func getJournal(url: String, completion: @escaping (Result<Journal, Error>) -> Void) {
        if let journal = journal {
            completion(.success(journal))
        } else {
            let error = NSError(domain: "", code: 13, userInfo: nil)
            completion(.failure(error))
        }
    }
    
    func getImagesForArticles(articles: [Article], completion: @escaping ([String: Data]) -> Void) {
        var imagesData = [String: Data]()
        for a in articles {
            
            imagesData[a.urlToImage!] = Data()
        }
        completion(imagesData)
    }
}

// MARK: - MockNetworkServiceTests

class MockNetworkServiceTests: XCTestCase {
    
    var networkService: NetworkServiceProtocol!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        networkService = nil
        try super.tearDownWithError()
    }

    func testGetSuccesArticles() {
        var journal = Journal()
        let article = Article(author: "Bar",
                              title: "Fire",
                              description: "Text",
                              url: "someUrl",
                              urlToImage: "urlToImage",
                              publishedAt: "01-01-01",
                              imageData: Data())
        journal.articles?.append(article)
        
        networkService = MockNetworService(journal: journal)
        var catchJournal: Journal?
        
        networkService.getJournal(url: "") { result in
            switch result {
                
            case .success(let journal):
                catchJournal = journal
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertNotEqual(catchJournal?.articles?.count, 0)
        XCTAssertEqual(journal.articles?.count, catchJournal?.articles?.count)
        XCTAssertEqual(journal.articles?.first?.author, catchJournal?.articles?.first?.author)
        XCTAssertNotNil(catchJournal)
    }
    
    func testGetFailure() {
        var journal = Journal()
        let article = Article(author: "Bar",
                              title: "Fire",
                              description: "Text",
                              url: "someUrl",
                              urlToImage: "urlToImage",
                              publishedAt: "01-01-01",
                              imageData: Data())
        journal.articles?.append(article)
        networkService = MockNetworService()
        
        var catchError: Error?
        networkService.getJournal(url: "") { result in
            switch result {
                
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
    
    func testSuccesGetImagesForArticles() {
        let journal = Journal()
        networkService = MockNetworService(journal: journal)
        let firstArticle = Article(author: "Bar",
                              title: "Fire",
                              description: "Text",
                              url: "someUrl",
                              urlToImage: "urlToImage",
                              publishedAt: "01-01-01",
                              imageData: nil)
        let secondArticle = Article(author: "second",
                                    title: "SecondFire",
                                    description: "SecondText",
                                    url: "SecondsomeUrl",
                                    urlToImage: "SecondurlToImage",
                                    publishedAt: "02-02-02",
                                    imageData: nil)
        let articles = [firstArticle, secondArticle]
        
        var catchImagesData: [String: Data]?
        
        networkService.getImagesForArticles(articles: articles) { imagesData in
            catchImagesData = imagesData
        }
        XCTAssertNotNil(catchImagesData)
        XCTAssertEqual(catchImagesData?.first?.value, Data())
    }
}
