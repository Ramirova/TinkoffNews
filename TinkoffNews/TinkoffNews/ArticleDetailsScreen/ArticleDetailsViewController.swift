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
                DispatchQueue.main.async {
                    if let error = error {
                        self.handleError(error: error)
                    } else {
                        self.configureView()
                    }
                }
            }
        }
    }
    
    func handleError(error: ErrorType) {
        switch error {
        case .noInternetConnection:
            self.showAlert(title: Constants.noInternetConnectionErrorTitle, message: Constants.noInternetConnectionErrorTitle)
        case .serverError:
            self.showAlert(title: Constants.serverErrorTitle, message: Constants.serverErrorMessage)
        default:
            self.showAlert(title: "Простите, возникла ошибка", message: "")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
