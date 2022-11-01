
import UIKit

//MARK: - Protocols

protocol FullArticleViewProtocol: AnyObject {
    func showFullArticle()
}

protocol FullArticlePresenterProtocol: AnyObject {
    init(view: FullArticleViewProtocol, router: RouterProtocol, urlToArticle: String)
    func doneButtonPressed()
    func showBadInternetConnectionAlert(in viewController: UIViewController)
    func openArticleInSafari()
    func shareLinkOfArticle(viewController: FullArticleViewController)
    func createRequest(completion: (URLRequest) -> Void)
}

class FullArticlePresenter: FullArticlePresenterProtocol {
 
    // MARK: - Properties
    
    weak var view: FullArticleViewProtocol?
    private var router: RouterProtocol
    private var urlToArticle: String?
    
    // MARK: - Initializer
    
    required init(view: FullArticleViewProtocol, router: RouterProtocol, urlToArticle: String) {
        self.view = view
        self.router = router
        self.urlToArticle = urlToArticle
    }
    
    // MARK: - Methods
    
    func doneButtonPressed() {
        router.popViewController()
    }
    
    func showBadInternetConnectionAlert(in viewController: UIViewController) {
        if !NetworkMonitor.shared.isConnected {
            viewController.showInternetConnectionAlert(completion: nil)
        }
    }
    
    func openArticleInSafari() {
        guard let stringUrl = urlToArticle else { return }
        guard let url = URL(string: stringUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    func shareLinkOfArticle(viewController: FullArticleViewController) {
        guard let stringUrl = urlToArticle else { return }
        guard let url = URL(string: stringUrl) else { return }
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        viewController.present(activityViewController, animated: true)
    }
    
    func createRequest(completion: (URLRequest) -> Void) {
        guard let urlToArticle = urlToArticle else { return }
        guard let url = URL(string: urlToArticle) else { return }
        let request = URLRequest(url: url)
        completion(request)
    }
}
