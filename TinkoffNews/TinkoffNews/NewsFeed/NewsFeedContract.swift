//
//  NewsFeedProtocol.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation


protocol NewsFeedModelDelegate {
    func loadData(refreshFlag: Bool, pageSize: Int, pageOffset: Int, completion: @escaping (_ error: ErrorType?) -> Void)
    func getArticles() -> [ArticleDataModel]
}
