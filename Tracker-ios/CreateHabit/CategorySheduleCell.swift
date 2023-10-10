//
//  SheduleTextFieldCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

final class CategorySheduleCell: UITableViewCell {
    //MARK: - Layout variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.ypGray
        
        return label
    }()
    private lazy var arrowImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = image
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        return imageView
    }()
    
    //MARK: - Main function
    func configureCell(text: String, description: String?) {
        contentView.backgroundColor = UIColor.ypBackground
        
        addSubViews()
        configureConstraints()
        
        titleLabel.text = text
        
        if let description = description {
            descriptionLabel.text = description
        }
    }
}

//MARK: - Private functions
private extension CategorySheduleCell {
    func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(arrowImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 13),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
