//
//  ArticleCoreDataEntity+CoreDataProperties.swift
//  Wall Street news
//
//  Created by Егор on 31.07.2022.
//
//

import Foundation
import CoreData


extension ArticleCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCoreDataEntity> {
        return NSFetchRequest<ArticleCoreDataEntity>(entityName: "ArticleCoreDataEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var urlToArticle: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var image: Data?

}

extension ArticleCoreDataEntity : Identifiable {

}
