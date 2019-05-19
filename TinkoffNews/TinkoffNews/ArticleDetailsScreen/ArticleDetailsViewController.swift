//
//  ArticleDetailsScreen.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 18/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {
    
    let model: ArticleDetailsModelDelegate = ArticleDetailsModel()
    var urlSlug: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if let urlSlug = urlSlug {
            self.model.loadArticle(urlSlug: urlSlug) {
                error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.configureView()
                    }
                }
            }
        }
    }
    
    func configureView() {
        if let slug = urlSlug {
            if let article = model.getArticle(slug: slug) {
                self.titleLabel.text = article.title
                if let text = article.text {
                    self.webView.loadHTMLString(text, baseURL: nil)
                }
                self.dateLabel.text = article.date ?? ""
            }
        }
    }
    
    func setURLSlug(_ slug: String) {
        urlSlug = slug
    }
}
