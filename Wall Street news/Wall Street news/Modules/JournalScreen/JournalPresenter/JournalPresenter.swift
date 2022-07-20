//
//  JournalPresenter.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import UIKit

protocol JournalViewProtocol: AnyObject {
    func succes()
    func failure(_ error: Error)
}

protocol JournalViewPresenterProtocol: AnyObject {
    init(view: JournalViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol)
    var router: RouterProtocol? { get set }
    var journal: Journal? { get set }
    var images: [UIImage] { get set }
}

class JournalViewPresenter: JournalViewPresenterProtocol {
   
    weak var view: JournalViewProtocol?
    var router: RouterProtocol?
    private var networkService: NetworkServiceProtocol!
    var journal: Journal?
    var images: [UIImage] = []
    
    required init(view: JournalViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        getJournal()
    }
    
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
            let url = URL(string: i.urlToImage)
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                images.append(image!)
                
            } catch {
                print(error)
            }
        }
        return images
    }
}
