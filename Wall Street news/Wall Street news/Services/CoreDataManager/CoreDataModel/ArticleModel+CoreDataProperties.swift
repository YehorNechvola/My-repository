//
//  ArticleModel+CoreDataProperties.swift
//  Wall Street news
//
//  Created by Егор on 06.08.2022.
//
//

import Foundation
import CoreData


extension ArticleModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleModel> {
        return NSFetchRequest<ArticleModel>(entityName: "ArticleEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var publishedtAT: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToArticle: String?

}

extension ArticleModel : Identifiable {

}
