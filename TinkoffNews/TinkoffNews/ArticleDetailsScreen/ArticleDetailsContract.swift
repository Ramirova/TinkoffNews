//
//  ArticleDetailsContract.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 18/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation

protocol ArticleDetailsModelDelegate {
    func loadArticle(urlSlug: String, completion: @escaping (_ article: Article?, _ error: String?) -> Void)
}
