//
//  ColorsCollectionviewCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 12.10.2023.
//

import UIKit

final class ColorsCollectionviewCell: UICollectionViewCell {
    //MARK: - Layout variables
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    //MARK: - Main function
    func configureCell(color: UIColor) {
        colorView.backgroundColor = color

        addSubViews()
        configureConstraints()
    }
}

//MARK: - Private function
private extension ColorsCollectionviewCell {
    func addSubViews() {
        contentView.addSubview(colorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}

