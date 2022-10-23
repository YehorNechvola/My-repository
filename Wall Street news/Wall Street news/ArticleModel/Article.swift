

import Foundation

//MARK: - Models model for the received data

struct Journal: Codable {
    
    var articles: [Article]?
}

struct Article: Codable, Hashable {
    
    var author: String?
    var title, description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var imageData: Data?
}



