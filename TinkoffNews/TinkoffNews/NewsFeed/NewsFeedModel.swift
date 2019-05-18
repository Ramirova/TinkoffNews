//
//  NewsFeedModel.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation


class NewsFeedModel: NewsFeedModelDelegate {
    
    var apiClient: APIClient = APIClient()
    var articles: [Article] = [Article]()
    var totalNews: Int? = nil
    init() {
        
    }
    
    func loadData(pageSize: Int, pageOffset: Int, completion: @escaping (_ articles: [Article]?, _ error: String?) -> Void) {
        if pageOffset == 0 {
            articles = [Article]()
        }
        if totalNews == nil || totalNews! > pageOffset + pageSize {
            apiClient.loadArticles(pageSize: pageSize, pageOffset: pageOffset) {
                responseData, error in
                guard let responseData = responseData else { return }
                self.articles.append(contentsOf: responseData.response.news)
                self.totalNews = responseData.response.total
                completion(self.articles, error)
                return
            }
        }
    }
    
    func getArticles() -> [Article] {
        return articles
    }
}
