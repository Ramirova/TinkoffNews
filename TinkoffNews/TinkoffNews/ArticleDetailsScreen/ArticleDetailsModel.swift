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
    var article: Article!
    
    func loadArticle(urlSlug: String, completion: @escaping (_ article: Article?, _ error: String?) -> Void) {
        apiClient.loadArticle(urlSlug: urlSlug) {
            article, error in
            guard let article = article else { return }
            self.article = article
            completion(article, error)
            return
        }
    }
    
    func getArticle() -> Article? {
        return article
    }
}
