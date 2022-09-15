//
//  WallStreetNewsTests.swift
//  WallStreetNewsTests
//
//  Created by Егор on 12.09.2022.
//

import XCTest
@testable import Wall_Street_news

class MockView: JournalViewProtocol {
    func succes() {
    }
    
    func failure(_ error: Error) {
    }
    
    func endRefreshingWhenNoUpdates() {
    }
}

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
}

class JournalPresenterTests: XCTestCase {
    
    var view: MockView!
    var presenter: JournalViewPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    var journal: Journal!
    
    override func setUpWithError() throws {
        let navigationControllers = [UINavigationController(), UINavigationController()]
        let assemblyBuilder = AssemblyBuilder()
        router = Router(navigationControllers: navigationControllers, assemblyBuilder: assemblyBuilder)
        coreDataManager = CoreDataManager()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        networkService = nil
        router = nil
        coreDataManager = nil
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
        view = MockView()
        networkService = MockNetworService(journal: journal)
        presenter = JournalViewPresenter(view: view, router: router, networkService: networkService, coreDataManager: coreDataManager)
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
        view = MockView()
        networkService = MockNetworService()
        presenter = JournalViewPresenter(view: view, router: router, networkService: networkService, coreDataManager: coreDataManager)
        
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
}
