//
//  ResponseStructures.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation

struct ServerResponseData: Codable {
    var response: ServerResponse
    private enum CodingKeys: String, CodingKey {
        case response
    }
}

struct ServerResponse: Codable {
    var news: [NewsItem]
    var total: Int
    private enum CodingKeys: String, CodingKey {
        case news
        case total
    }
}

struct ServerOneArticleData: Codable {
    var response: NewsItem
    private enum CodingKeys: String, CodingKey {
        case response
    }
}

struct NewsItem: Codable {
    var id: String
    var title: String
    var image: String?
    var lang: String?
    var createdTime: String?
    var deleted: Bool?
    var hidden: Bool?
    var updatedTime: String?
    var slug: String
    var date: String
    var parts: [ArticlePart]?
    var tags: [ArticleTag]?
    var references: [ArticleReference]?
    var disclaimer: String?
    var desktopl: String?
    var desktops: String?
    var desktopl2x: String?
    var desktops2x: String?
    var text: String
    var textshort: String
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case lang
        case createdTime
        case deleted
        case hidden
        case updatedTime
        case slug
        case date
        case parts
        case tags
        case references
        case disclaimer
        case desktopl
        case desktops
        case desktopl2x
        case desktops2x
        case text
        case textshort
    }
}

struct ArticlePart: Codable {
    var id: String
    var title: String
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}

struct ArticleTag: Codable {
    var id: String
    var value: String
    enum CodingKeys: String, CodingKey {
        case id
        case value
    }
}

struct ArticleReference: Codable {
    var id: String
    var title: String
    var text: String
    var referencesshort: String
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text
        case referencesshort
    }
}
