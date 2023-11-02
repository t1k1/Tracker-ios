//
//  EmojiCollectionviewCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 12.10.2023.
//

import UIKit

final class EmojiCollectionviewCell: UICollectionViewCell {
    //MARK: - Layout variables
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.frame = bounds

        return label
    }()
    
    //MARK: - Main function
    func configureCell(emoji: String) {
        emojiLabel.text = emoji
        layer.cornerRadius = 16
        
        addSubViews()
        configureConstraints()
    }
}

//MARK: - Private function
private extension EmojiCollectionviewCell {
    func addSubViews() {
        addSubview(emojiLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
    }
}

