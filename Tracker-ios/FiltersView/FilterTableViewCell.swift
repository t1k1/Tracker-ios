//
//  FilterTableViewCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.11.2023.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    //MARK: - Layout variables
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var checkImageView: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        
        let imageview = UIImageView(image: image)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.isHidden = true
        
        return imageview
    }()
    
    func configureCell(name: String, checkMark: Bool) {
        nameLabel.text = name
        checkImageView.isHidden = !checkMark
        
        contentView.backgroundColor = UIColor.ypBackground
        
        addSubViews()
        configureConstraints()
    }
}

//MARK: - Private functions
private extension FilterTableViewCell {
    func addSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 65),
            
            checkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
