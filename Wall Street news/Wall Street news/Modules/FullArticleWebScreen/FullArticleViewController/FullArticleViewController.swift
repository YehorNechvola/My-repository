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
    let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Outlets

    @IBOutlet private weak var articleWebViev: WKWebView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        showFullArticle()
    }
    
    // MARK: - Methods
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}

// MARK: - FullArticleViewProtocol

extension FullArticleViewController: FullArticleViewProtocol {
    
    func showFullArticle() {
        articleWebViev.backgroundColor = .clear
        guard let stringUrl = presenter.urlToArticle else { return }
        guard let urlToArticle = URL(string: stringUrl) else { return }
        let request = URLRequest(url: urlToArticle)
        articleWebViev.load(request)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.activityIndicator.stopAnimating()
        }
    }
}
