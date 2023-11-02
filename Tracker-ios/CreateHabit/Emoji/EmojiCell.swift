//
//  EmojiColorsCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 12.10.2023.
//

import UIKit

final class EmojiCell: UITableViewCell {
    //MARK: - Public variables
    var delegate: EmojiCellDelegate?
    
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 52, height: 52)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.isMultipleTouchEnabled = false
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(EmojiCollectionviewCell.self, forCellWithReuseIdentifier: "emojiCell")
        return collectionView
    }()
    
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    //MARK: - Main function
    func configureCell() {
        selectionStyle = .none
        
        addSubViews()
        configureConstraints()
    }
}

// MARK: - UICollectionViewDataSource
extension EmojiCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCollectionviewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.configureCell(emoji: emoji[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EmojiCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.ypLightGray
        
        delegate?.updateEmoji(with: emoji[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
}

//MARK: - Private functions
private extension EmojiCell {
    func addSubViews() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(emojiCollectionView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 18),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            emojiCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
