//
//  CoreDataManager.swift
//  Wall Street news
//
//  Created by Егор on 01.08.2022.
//

import CoreData
import UIKit

// MARK: CoreDataManagerProtocol

protocol CoreDataManagerProtocol: AnyObject {
    var persistentContainer: NSPersistentContainer { get set }
    var context: NSManagedObjectContext { get set }
    func saveContext()
    func saveArticle(_ article: Article, with image: UIImage)
    func fetchArticles() -> [Article]
    func cleanAllObjects()
    func deleteArticle(by title: String)
}

class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: - Properties
    
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
    
    // MARK: Methods
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func saveArticle(_ article: Article, with image: UIImage) {
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
        articleModel.imageData = image.pngData()
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
