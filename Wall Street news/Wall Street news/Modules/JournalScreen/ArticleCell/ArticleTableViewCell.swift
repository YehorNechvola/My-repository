//
//  TableViewCell.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
    static let identifier = "ArticleTableViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var dateOfArticleLabel: UILabel!
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleArticleLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func setup(title: String, and date: String) {
        titleArticleLabel.text = title
        dateOfArticleLabel.text = date
    }
    
    func setup(image: UIImage) {
        articleImageView.image = image
    }
}
