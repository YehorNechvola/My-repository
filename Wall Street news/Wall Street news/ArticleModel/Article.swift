//
//  Article.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import Foundation

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



