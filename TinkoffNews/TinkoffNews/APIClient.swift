//
//  APIClient.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation

class APIClient {
    
    
    func loadArticles(pageSize: Int, pageOffset: Int, completion: @escaping (_ serverResponseData: ServerResponseData?, _ error: ErrorType?) -> Void) {
        var urlRequest = getURLRequest(params: ["pageSize" : String(pageSize), "pageOffset": String(pageOffset)], urlString: Constants.baseURL + Constants.getArticles)
        urlRequest.setValue(String(pageSize), forHTTPHeaderField: "pageSize")
        urlRequest.setValue(String(pageOffset), forHTTPHeaderField: "pageOffset")
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data else {
                if response == nil {
                    completion(nil, .noInternetConnection)
                    return
                }
                return
            }
            guard let serverResponse = try? JSONDecoder().decode(ServerResponseData.self, from: data) else {
                completion(nil, .jsonParsongError)
                return
            }
            completion(serverResponse, nil)
        }
        task.resume()
    }
    
    func loadArticle(urlSlug: String, completion: @escaping (_ article: NewsItem?, _ error: ErrorType?) -> Void) {
        let task = URLSession.shared.dataTask(with: getURLRequest(params: ["urlSlug": urlSlug], urlString: Constants.baseURL + Constants.getArticle)) {(data, response, error) in
            guard let data = data else {
                if response == nil {
                    completion(nil, .noInternetConnection)
                    return
                }
                return
            }
            guard let serverResponse = try? JSONDecoder().decode(ServerOneArticleData.self, from: data) else {
                completion(nil, .jsonParsongError)
                return
            }
            completion(serverResponse.response, nil)
        }
        task.resume()
    }
    
    func getURLRequest(params: [String: String], urlString: String) -> URLRequest {
        let urlComp = NSURLComponents(string: urlString)!
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        return URLRequest(url: urlComp.url!)
    }
}
