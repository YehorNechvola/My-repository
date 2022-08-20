//
//  TableViewCell.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import UIKit


protocol ArticleTableViewCellProtocol: AnyObject {
    func saveArticle(in cell: ArticleTableViewCell)
    func saveTagOfPressedButton(sender: UIButton)
}

protocol DeleteArticleInTableViewCellProtocol: AnyObject {
    func deleteArticle(in cell: ArticleTableViewCell)
}

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
    static let identifier = "ArticleTableViewCell"
    weak var delegate: JournalViewController?
    weak var deleteArticleDelegate: SavedArticlesUIViewController?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleArticleLabel: UILabel!
    @IBOutlet private weak var dateOfArticleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupRemoveButton()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        setButtonStateByTap()
        delegate?.saveTagOfPressedButton(sender: saveButton)
        delegate?.saveArticle(in: self)
        deleteArticleDelegate?.deleteArticle(in: self)
    }
    
    // MARK: - Methods
    
    func setup(title: String, date: String, author: String) {
        titleArticleLabel.text = title
        dateOfArticleLabel.text = date.format()
        authorLabel.text = author
    }
    
    func setup(image: UIImage) {
        articleImageView.image = image
    }
    
    private func setButtonStateByTap() {
        if Router.currentNavigationController == .first {
            saveButton.tintColor = .green
            saveButton.setTitle("saved", for: .normal)
        }
    }
    
    func handleStateOfSaveButtons(with tags: [Int]) {
        if tags.contains(saveButton.tag) {
            saveButton.tintColor = .green
            saveButton.setTitle("saved", for: .normal)
        } else {
            saveButton.tintColor = .blue
            saveButton.setTitle("save", for: .normal)
        }
    }
    
    func setTag(by indexPath: IndexPath) {
        saveButton.tag = indexPath.row
    }
    
    private func setupRemoveButton() {
        if Router.currentNavigationController == .second {
            saveButton.setTitle("remove", for: .normal)
            saveButton.tintColor = .red
        }
    }
    
    private func setupUI() {
        titleArticleLabel.sizeToFit()
        selectionStyle = .none
        saveButton.tintColor = .blue
    }
}
