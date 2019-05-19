//
//  NewsFeedModel.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation
import CoreData

class NewsFeedModel: NewsFeedModelDelegate {
    
    var apiClient: APIClient = APIClient()
    var totalNews: Int? = nil
    var coreDataManager = CoreDataManager.sharedManager
    
    func loadData(refreshFlag: Bool, pageSize: Int, pageOffset: Int, completion: @escaping (_ error: ErrorType?) -> Void) {
        if refreshFlag {
            coreDataManager.deleteNews()
        }
        if totalNews == nil || totalNews! > pageOffset + pageSize {
            apiClient.loadArticles(pageSize: pageSize, pageOffset: pageOffset) {
                responseData, error in
                guard let responseData = responseData else { return }
                for article in responseData.response.news {
                    self.coreDataManager.save(article: article)
                }
                self.totalNews = responseData.response.total
                completion(error)
                return
            }
        }
    }
    
    func getArticles() -> [ArticleDataModel] {
        return self.coreDataManager.fetchAllArticles() ?? [ArticleDataModel]()
    }
}
