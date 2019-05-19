//
//  NewsFeedViewController.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    let pagingSpinner = UIActivityIndicatorView(style: .gray)
    
    var model: NewsFeedModelDelegate = NewsFeedModel()
    var currentNewsOffset: Int = 0
    let numberOfNewsInPage: Int = 20
    var loadingData: Bool = false
    var loadingMoreData: Bool = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(NewsFeedViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    override func viewDidLoad() {
        currentNewsOffset = 0
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        newsFeedTableView.addSubview(self.refreshControl)
        title = "Новости"
        configurePagingSpinner()
        registerCell()
        loadData(refreshFlag: false)
    }
    
    func configurePagingSpinner() {
        pagingSpinner.color = UIColor(red: 22.0 / 255.0, green: 106.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.stopAnimating()
        newsFeedTableView.tableFooterView = pagingSpinner
        pagingSpinner.isHidden = true
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        currentNewsOffset = 0
        loadData(refreshFlag: true)
    }
    
    func registerCell() {
        self.newsFeedTableView.register(UINib.init(nibName: "NewsFeedCellPrototype", bundle: nil), forCellReuseIdentifier: "NewsFeedCellPrototype")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            loadMoreData()
        }
    }
    
    func disableRefreshControl() {
        refreshControl.isEnabled = false
    }
    
    func enableRefreshControl() {
        refreshControl.isEnabled = false
    }
    
    func hidePagingSpinner() {
        pagingSpinner.isHidden = true
        pagingSpinner.stopAnimating()
        pagingSpinner.hidesWhenStopped = true
    }
    
    func loadMoreData() {
        if !loadingData && !loadingMoreData {
            pagingSpinner.isHidden = false
            loadingMoreData = true
            self.currentNewsOffset += self.numberOfNewsInPage
            model.loadData(refreshFlag: false, pageSize: numberOfNewsInPage, pageOffset: currentNewsOffset) {
                error in
                DispatchQueue.main.async {
                    self.hidePagingSpinner()
                    self.refreshControl.endRefreshing()
                    self.enableRefreshControl()
                    self.loadingMoreData = false
                    if let error = error {
                        self.handleError(error: error)
                    } else {
                        self.currentNewsOffset = 0
                        self.newsFeedTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func loadData(refreshFlag: Bool) {
        if !loadingData {
            loadingData = true
            disableRefreshControl()
            model.loadData(refreshFlag: refreshFlag, pageSize: numberOfNewsInPage, pageOffset: currentNewsOffset) {
                error in
                DispatchQueue.main.async {
                    self.loadingData = false
                    self.refreshControl.endRefreshing()
                    self.enableRefreshControl()
                    if let error = error {
                        self.handleError(error: error)
                    } else {
                        self.currentNewsOffset = 0
                        self.newsFeedTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func stopRefreshControl() {
        refreshControl.endRefreshing()
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
}

extension NewsFeedViewController: UITableViewDelegate { }

extension NewsFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.getArticles().count == 0 {
            refreshControl.isUserInteractionEnabled = false
        } else {
            refreshControl.isUserInteractionEnabled = true
        }
        return model.getArticles().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "NewsFeedCellPrototype", for: indexPath) as! NewsFeedCell
        if indexPath.row < model.getArticles().count {
            let articleInfo = model.getArticles()[indexPath.row]
            if let title = articleInfo.title {
                cell.setTitle(text: title)
            }
            if let textShort = articleInfo.textShort {
                cell.setDescription(text: textShort)
            }
            if let clickCounter = articleInfo.clickCounter {
                cell.setViewsCount(clickCounter as! Int)
            }
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "articleDetailsViewController") as! ArticleDetailsViewController
        CoreDataManager.sharedManager.incrementClickCounter(article: model.getArticles()[indexPath.row])
        updateCellClickCounter(atIndexPath: indexPath)
        if let slug = model.getArticles()[indexPath.row].slug {
            controller.setURLSlug(slug)
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func updateCellClickCounter(atIndexPath: IndexPath) {
        let cell = newsFeedTableView.cellForRow(at: atIndexPath) as! NewsFeedCell
        if let currentClicksCount = model.getArticles()[atIndexPath.row].clickCounter {
            cell.setViewsCount(currentClicksCount as! Int)
        }
    }
}
