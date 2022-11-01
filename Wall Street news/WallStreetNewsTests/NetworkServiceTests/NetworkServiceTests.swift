

import XCTest
@testable import Wall_Street_news

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    
    
    override func setUpWithError() throws {
        networkService = NetworkService()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        networkService = nil
        try super.tearDownWithError()
    }
    
    func testGetSucces() {
        
        var journal: Journal?
        var error: Error?
        let expectation = expectation(description: "expectation" + #function)
        networkService.getJournal(url: URLAdresses.articleURL) { result in
            switch result {
            case .success(let downloadedJournal):
                journal = downloadedJournal
            case .failure(let catchedError):
                error = catchedError
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2) { error in
            if error != nil {
                XCTFail()
            }
        }
        
        XCTAssertNil(error)
        XCTAssertNotNil(journal)
    }
    
    func testWhenUrlInvalid() {
        let url = "12345"
        var journal: Journal?
        var error: Error?
        let expectation = expectation(description: "expectation" + #function)
        
        networkService.getJournal(url: url) { result in
            switch result {
            case .success(let downloadedJournal):
                journal = downloadedJournal
            case .failure(let catchedError):
                error = catchedError
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if error != nil {
                XCTFail()
            }
        }
        XCTAssertNil(journal)
        XCTAssertNotNil(error)
    }
}
