//
//  JournalPresenter.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import Foundation
import Network

//MARK: - Protocols

protocol JournalViewProtocol: AnyObject {
    func succes()
    func failure(_ error: Error)
    func endRefreshingWhenNoUpdates()
}

protocol JournalViewPresenterProtocol: AnyObject {
    init(view: JournalViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, coreDataManager: CoreDataManagerProtocol)
    var journal: Journal? { get set }
    func getJournal()
    func saveArticle(article: Article)
    func getSavedArticles() -> [Int]
    func tapOnArticle(article: Article)
}

class JournalViewPresenter: JournalViewPresenterProtocol {
   
    //MARK: - Properties
    
    weak var view: JournalViewProtocol?
    var router: RouterProtocol?
    private var networkService: NetworkServiceProtocol
    var coreDataManager: CoreDataManagerProtocol
    var journal: Journal?
    
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
                case .success(let downloadedJournal):
                    if self.journal?.articles?.first?.title == downloadedJournal.articles?.first?.title {
                        self.view?.endRefreshingWhenNoUpdates()
                        return
                    }
                    self.journal = downloadedJournal
                    self.view?.succes()
                    self.setImagesToArticle()
                    
                    
                case .failure(let error):
                    self.view?.failure(error)
                }
            }
        }
    }
    
    private func setImagesToArticle() {
        guard let articles = journal?.articles else { return }
        networkService.getImagesForArticles(articles: articles) { [weak self] data in
            var index = 0
            for a in articles {
                for k in data {
                    if a.urlToImage == k.key {
                        self?.journal?.articles![index].imageData = k.value
                    }
                }
                index += 1
            }
            self?.view?.succes()
        }
    }
    
    func saveArticle(article: Article) {
        coreDataManager.saveArticle(article)
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
    
    func tapOnArticle(article: Article) {
        router?.showArticleViewController(article: article)
    }
}
