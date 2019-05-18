//
//  NewsFeedCell.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 17/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setDescription(text: String) {
     descriptionLabel.text = text
    }
    
    func setViewsCount(_ count: String) {
        counterLabel.text = count
    }
}
