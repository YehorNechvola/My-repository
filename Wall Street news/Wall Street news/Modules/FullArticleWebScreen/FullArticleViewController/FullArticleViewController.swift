//
//  FullArticleViewController.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import UIKit
import WebKit

class FullArticleViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: FullArticlePresenterProtocol!
    
    // MARK: - Outlets

    @IBOutlet private weak var articleWebViev: WKWebView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showFullArticle()
    }
}

// MARK: - FullArticleViewProtocol

extension FullArticleViewController: FullArticleViewProtocol {
    
    func showFullArticle() {
        guard let stringUrl = presenter.urlToArticle else { return }
        guard let urlToArticle = URL(string: stringUrl) else { return }
        let request = URLRequest(url: urlToArticle)
        articleWebViev.load(request)
    }
}
