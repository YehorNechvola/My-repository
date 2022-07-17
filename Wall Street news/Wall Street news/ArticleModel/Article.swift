//
//  Article.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import Foundation

struct Journal: Codable {
    
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}

struct Article: Codable {
    
    var source: Source?
    var author: String?
    var title, description: String?
    var url: String
    var urlToImage: String
    var publishedAt: String?
    var content: String?
    
    enum CoddingKeys: String, CodingKey {
        case source, author, title, description, publishedAt, content
    }
}

struct Source: Codable {
    var id, name: String?
}

