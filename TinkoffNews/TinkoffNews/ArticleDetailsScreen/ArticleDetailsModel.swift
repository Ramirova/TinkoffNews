//
//  ArticleDetailsModel.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 18/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation

class ArticleDetailsModel: ArticleDetailsModelDelegate {
    
    let apiClient: APIClient = APIClient()
    
    var coreDataManager = CoreDataManager.sharedManager
    
    func loadArticle(urlSlug: String, completion: @escaping (_ error: String?) -> Void) {
        apiClient.loadArticle(urlSlug: urlSlug) {
            articleInfo, error in
            guard let articleInfo = articleInfo else { return }
            self.coreDataManager.saveFullArticle(article: articleInfo)
            completion(error)
            return
        }
    }
    
    func getArticle(slug: String) -> FullArticleDataModel? {
        return self.coreDataManager.getFullArticleInfo(articleSlug: slug)
    }
}
