//
//  APIClient.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation

class APIClient {
    
    func loadArticles(pageSize: Int, pageOffset: Int, completion: @escaping (_ serverResponseData: ServerResponseData?, _ error: String?) -> Void) {
        let params = ["pageSize" : String(pageSize), "pageOffset": String(pageOffset)]
        let urlComp = NSURLComponents(string: Constants.baseURL + Constants.getArticles)!
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        var urlRequest = URLRequest(url: urlComp.url!)
        
        urlRequest.setValue(String(pageSize), forHTTPHeaderField: "pageSize")
        urlRequest.setValue(String(pageOffset), forHTTPHeaderField: "pageOffset")
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data else { return }
            
            guard let serverResponse = try? JSONDecoder().decode(ServerResponseData.self, from: data) else {
                completion(nil, "Ошибка парсинга docflow ServerResponseData")
                return
            }
            completion(serverResponse, nil)
        }
        task.resume()
    }
    
    func loadArticle(urlSlug: String, completion: @escaping (_ article: Article?, _ error: String?) -> Void) {
        let params = ["urlSlug" : urlSlug]
        let urlComp = NSURLComponents(string: Constants.baseURL + Constants.getArticle)!
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        let urlRequest = URLRequest(url: urlComp.url!)
        print(urlRequest)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data else { return }
            
            guard let serverResponse = try? JSONDecoder().decode(ServerOneArticleData.self, from: data) else {
                completion(nil, "Ошибка парсинга docflow ServerOneArticleData")
                return
            }
            completion(serverResponse.response, nil)
        }
        task.resume()
    }
}
