//
//  TrackerHeaderColletcionviewCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 06.10.2023.
//

import UIKit

final class TrackerHeaderColletcionviewCell: UICollectionReusableView {    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor.ypBlack
        label.frame = bounds
        
        return label
    }()
    
    func configureCell(header: String) {
        headerLabel.text = header
        
        addSubViews()
        configureConstraints()
    }
}

private extension TrackerHeaderColletcionviewCell {
    func addSubViews() {
        addSubview(headerLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerLabel.heightAnchor.constraint(equalToConstant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
