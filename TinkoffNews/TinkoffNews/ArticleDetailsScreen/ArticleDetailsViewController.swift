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
//    @IBOutlet weak var fullTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlSlug = urlSlug {
            self.model.loadArticle(urlSlug: urlSlug) {
                article, error in
                if article != nil && error == nil {
                    DispatchQueue.main.async {
                        self.titleLabel.text = article?.title
//                        self.fullTextLabel.text = article?.text
                        
                        let data = article?.text.data(using: String.Encoding.unicode)!
                        let attrStr = try? NSAttributedString( // do catch
                            data: data!,
                            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                            documentAttributes: nil)
//                        self.fullTextLabel.attributedText = attrStr
                        self.webView.loadHTMLString(article!.text, baseURL: nil)
                        
                        self.dateLabel.text = self.getFormattedDate(date: article?.date ?? "")
                    }
                }
            }
        }
    }
    
    
    
    func setURLSlug(_ slug: String) {
        urlSlug = slug
    }
    
    func getFormattedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        let dateObj = getDateObj(date: date)
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.string(from: getDateObj(date: date))
    }
    
    func getDateObj(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatterWithoutMilliseconds = DateFormatter()
        dateFormatterWithoutMilliseconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var dateObj = Date()
        if (dateFormatter.date(from: date) != nil) {
            dateObj = dateFormatter.date(from: date)!
        } else {
            dateObj = dateFormatterWithoutMilliseconds.date(from: date)!
        }
        return dateObj
    }
}
