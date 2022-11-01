

import XCTest
import CoreData
@testable import Wall_Street_news

// MARK: - MockCoreDataManager

class MockCoreDataManager: CoreDataManagerProtocol {
    
    static var savedArticles: [Article]?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores { desription, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return persistentContainer
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func saveContext() {
        MockCoreDataManager.savedArticles = fetchArticles()
    }
    
    func saveArticle(_ article: Article) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
        fetchRequest.predicate = NSPredicate(format: "title = %@ ", article.title ?? "nil")
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 0 {
                for object in fetchResult {
                    context.delete(object as! NSManagedObject)
                }
            }
            
        } catch let error {
            print(error)
        }
        
        let articleModel = ArticleModel(context: context)
        articleModel.author = article.author
        articleModel.title = article.title
        articleModel.content = article.description
        articleModel.publishedtAT = article.publishedAt
        articleModel.imageData = article.imageData
        articleModel.urlToArticle = article.url
        saveContext()
    }
    
    func fetchArticles() -> [Article] {
        var articles = [Article]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
        do {
            guard let fetchResult = try context.fetch(fetchRequest) as? [ArticleModel] else { return articles }
            for object in fetchResult {
                let article = Article(author: object.author,
                                      title: object.title,
                                      description: object.content,
                                      url: object.urlToArticle,
                                      urlToImage: "",
                                      publishedAt: object.publishedtAT,
                                      imageData: object.imageData)
                articles.insert(article, at: 0)
            }
        } catch let error {
            print(error)
        }
        return articles
    }
    
    func cleanAllObjects() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
        do {
            guard let fetchResult = try context.fetch(fetchRequest) as? [ArticleModel] else { return }
            for object in fetchResult {
                let objectToDelete: NSManagedObject = object as NSManagedObject
                context.delete(objectToDelete)
            }
            saveContext()
            
        } catch let error {
            print(error)
        }
    }
    
    func deleteArticle(by title: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleEntity")
        fetchRequest.predicate = NSPredicate(format: "title = %@ ", title)
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 0 {
                for object in fetchResult {
                    context.delete(object as! NSManagedObject)
                }
            }
            saveContext()
        } catch let error {
            print(error)
        }
    }
}

// MARK: - CoreDataManagerTests

class CoreDataManagerTests: XCTestCase {

    var coreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        
        coreDataManager = MockCoreDataManager()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
        try super.tearDownWithError()
    }
    
    func testSaveOnlyUniqueArticle() {
        let firstArticle = Article(author: "Baz",
                                   title: "TestTitle",
                                   description: nil,
                                   url: nil,
                                   urlToImage: "testUrl",
                                   publishedAt: "testData",
                                   imageData: nil)
        let secondArticle = Article(author: "Bar",
                                    title: "SecondTitle",
                                    description: "lll",
                                    url: "fakeUrl",
                                    urlToImage: "testUrl",
                                    publishedAt: "testData",
                                    imageData: Data())
        coreDataManager.saveArticle(firstArticle)
        coreDataManager.saveArticle(firstArticle)
        coreDataManager.saveArticle(firstArticle)
        coreDataManager.saveArticle(secondArticle)
        MockCoreDataManager.savedArticles = coreDataManager.fetchArticles()
        XCTAssertNotNil(MockCoreDataManager.savedArticles)
        XCTAssertNotEqual(MockCoreDataManager.savedArticles?.last?.author, MockCoreDataManager.savedArticles?.first?.author)
        XCTAssertNotEqual(MockCoreDataManager.savedArticles?.last?.imageData, MockCoreDataManager.savedArticles?.first?.imageData)
        XCTAssertEqual(MockCoreDataManager.savedArticles?.count, 2)
        
    }
    
    func testCleanAllObjects() {
        let firstArticle = Article(author: "Baz",
                                   title: "TestTitle",
                                   description: nil,
                                   url: nil,
                                   urlToImage: "testUrl",
                                   publishedAt: "testData",
                                   imageData: nil)
        let secondArticle = Article(author: "Bar",
                                    title: "SecondTitle",
                                    description: "lll",
                                    url: "fakeUrl",
                                    urlToImage: "testUrl",
                                    publishedAt: "testData",
                                    imageData: Data())
        coreDataManager.saveArticle(firstArticle)
        coreDataManager.saveArticle(secondArticle)
        coreDataManager.cleanAllObjects()
        XCTAssertEqual(MockCoreDataManager.savedArticles?.count, 0)
        XCTAssertNotEqual(MockCoreDataManager.savedArticles?.count, 1)
    }
    
    func testDeleteArticle() {
        let firstArticle = Article(author: "Baz",
                                   title: "TestTitle",
                                   description: nil,
                                   url: nil,
                                   urlToImage: "testUrl",
                                   publishedAt: "testData",
                                   imageData: nil)
        let secondArticle = Article(author: "Bar",
                                    title: "SecondTitle",
                                    description: "lll",
                                    url: "fakeUrl",
                                    urlToImage: "testUrl",
                                    publishedAt: "testData",
                                    imageData: Data())
        coreDataManager.saveArticle(firstArticle)
        coreDataManager.saveArticle(secondArticle)
        XCTAssertEqual(MockCoreDataManager.savedArticles?.count, 2)
        coreDataManager.deleteArticle(by: firstArticle.title ?? "")
        XCTAssertEqual(MockCoreDataManager.savedArticles?.count, 1)
        coreDataManager.deleteArticle(by: secondArticle.title ?? "")
        XCTAssertEqual(MockCoreDataManager.savedArticles?.count, 0)
    }
}
