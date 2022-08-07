//
//  TableViewCell.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import UIKit

protocol ArticleTableViewCellProtocol: AnyObject {
    
    func saveArticle(in cell: ArticleTableViewCell)
}

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
    static let identifier = "ArticleTableViewCell"
    var delegate: JournalViewController?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var dateOfArticleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleArticleLabel.sizeToFit()
        selectionStyle = .none
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.saveArticle(in: self)
    }
    
    // MARK: - Methods
    
    func setup(title: String, and date: String, with author: String) {
        titleArticleLabel.text = title
        dateOfArticleLabel.text = date.format()
        authorLabel.text = author
    }
    
    func setup(image: UIImage) {
        articleImageView.image = image
    }
}
