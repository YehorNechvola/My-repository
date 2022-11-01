

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
        
        addPopGestureRecognizer()
        showFullArticle()
        articleWebViev.scrollView.subviews.forEach { $0.isUserInteractionEnabled = false }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.showBadInternetConnectionAlert(in: self)
        setupActivityIndicator()
    }
    
    // MARK: - Methods
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    private func addPopGestureRecognizer() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction private func doneButtonPressed(_ sender: UIButton) {
        presenter.doneButtonPressed()
    }
    
    @IBAction private func safariButtonPressed(_ sender: UIButton) {
        presenter.openArticleInSafari()
    }
    
    @IBAction private func shareButtonPressed(_ sender: UIButton) {
        presenter.shareLinkOfArticle(viewController: self)
    }
}

// MARK: - FullArticleViewProtocol

extension FullArticleViewController: FullArticleViewProtocol {
    
    func showFullArticle() {
        articleWebViev.navigationDelegate = self
        articleWebViev.backgroundColor = .clear
        presenter.createRequest { [weak self] request in
            self?.articleWebViev.load(request)
        }
    }
}

// MARK: - WKNavigationDelegate

extension FullArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FullArticleViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
