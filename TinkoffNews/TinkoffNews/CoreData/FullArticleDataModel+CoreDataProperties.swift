//
//  FullArticleDataModel+CoreDataProperties.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 19/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//
//

import Foundation
import CoreData


extension FullArticleDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullArticleDataModel> {
        return NSFetchRequest<FullArticleDataModel>(entityName: "FullArticleDataModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var slug: String?

}
