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
        vonfigurePagingSpinner()
        registerCell()
        loadData()
    }
    
    func vonfigurePagingSpinner() {
        pagingSpinner.color = UIColor(red: 22.0 / 255.0, green: 106.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.stopAnimating()
        newsFeedTableView.tableFooterView = pagingSpinner
        pagingSpinner.isHidden = true
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        currentNewsOffset = 0
        loadData()
    }
    
    func registerCell() {
        self.newsFeedTableView.register(UINib.init(nibName: "NewsFeedCellPrototype", bundle: nil), forCellReuseIdentifier: "NewsFeedCellPrototype")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
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
            model.loadData(pageSize: numberOfNewsInPage, pageOffset: currentNewsOffset) {
                articles, error in
                DispatchQueue.main.async {
                    self.hidePagingSpinner()
                    self.refreshControl.endRefreshing()
                    self.enableRefreshControl()
                    self.loadingMoreData = false
                    if error == nil && articles != nil {
                        self.newsFeedTableView.reloadData()
                        
                    }
                }
            }
        }
    }
    
    func loadData() {
        if !loadingData {
            loadingData = true
            disableRefreshControl()
            model.loadData(pageSize: numberOfNewsInPage, pageOffset: currentNewsOffset) {
                articles, error in
                
                DispatchQueue.main.async {
                    self.loadingData = false
                    self.refreshControl.endRefreshing()
                    self.enableRefreshControl()
                    if error == nil && articles != nil {
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
}

extension NewsFeedViewController: UITableViewDelegate {
    
}

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
        let articleInfo = model.getArticles()[indexPath.row]
        cell.setTitle(text: articleInfo.title)
        cell.setDescription(text: articleInfo.textshort)
        cell.setViewsCount(articleInfo.desktops ?? "0")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "articleDetailsViewController") as! ArticleDetailsViewController
        controller.setURLSlug(model.getArticles()[indexPath.row].slug)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}
