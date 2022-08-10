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

protocol DeleteArticleInTableViewCellProtocol: AnyObject {
    func deleteArticle(in cell: ArticleTableViewCell)
}

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
    static let identifier = "ArticleTableViewCell"
    var delegate: JournalViewController?
    var deleteArticleDelegate: SavedArticlesUIViewController?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var dateOfArticleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleArticleLabel.sizeToFit()
        selectionStyle = .none
        saveButton.tintColor = .blue
        if Router.currentNavigationController == .second {
            saveButton.setTitle("remove", for: .normal)
            saveButton.tintColor = .red
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.saveArticle(in: self)
        deleteArticleDelegate?.deleteArticle(in: self)
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
