//
//  JournalPresenter.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import UIKit

//MARK: - Protocols

protocol JournalViewProtocol: AnyObject {
    func succes()
    func failure(_ error: Error)
}

protocol JournalViewPresenterProtocol: AnyObject {
    init(view: JournalViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, coreDataManager: CoreDataManagerProtocol)
    func getJournal()
    func saveArticle(article: Article, image: UIImage)
    func getSavedArticles() -> [Int]
    var router: RouterProtocol? { get set }
    var journal: Journal? { get set }
    var images: [UIImage] { get set }
}

class JournalViewPresenter: JournalViewPresenterProtocol {
   
    //MARK: - Properties
    
    weak var view: JournalViewProtocol?
    var router: RouterProtocol?
    private var networkService: NetworkServiceProtocol
    var coreDataManager: CoreDataManagerProtocol
    var journal: Journal?
    var images: [UIImage] = []
    
    //MARK: Initializer
    
    required init(view: JournalViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        getJournal()
    }
    
    //MARK: - Methods
    func getJournal() {
        networkService.getJournal(url:URLAdresses.articleURL) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let journal):
                    self.journal = journal
                    self.images = self.getImages(from: self.journal!)
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error)
                }
            }
        }
    }
    
   private func getImages(from journal: Journal) -> [UIImage] {
        var images = [UIImage]()
        
        for i in journal.articles! {
            guard let url = URL(string: i.urlToImage ?? "") else { return images }
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                images.append(image!)
                
            } catch {
                print(error)
            }
        }
        return images
    }
    
    func saveArticle(article: Article, image: UIImage) {
        coreDataManager.saveArticle(article, with: image)
    }
    
    func getSavedArticles() -> [Int] {
        var indicies: [Int] = []
        var index = 0
        guard let downloadedArticles = journal?.articles else { return indicies }
        let savedArticles = coreDataManager.fetchArticles()
        
        for i in downloadedArticles {
            for a in savedArticles {
                if i.title == a.title {
                    indicies.append(index)
                }
            }
            index += 1
        }
        return indicies
    }
}
