//
//  ColorsCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 12.10.2023.
//

import UIKit

final class ColorsCell: UITableViewCell {
    //MARK: - Public variables
    var delegate: ColorsCellDelegate?
    
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var colorsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 52, height: 52)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(ColorsCollectionviewCell.self, forCellWithReuseIdentifier: "colorCell")
        return collectionView
    }()
    
    private let colors = [UIColor.ypColorSelection1,  UIColor.ypColorSelection2,  UIColor.ypColorSelection3,
                          UIColor.ypColorSelection4,  UIColor.ypColorSelection5,  UIColor.ypColorSelection6,
                          UIColor.ypColorSelection7,  UIColor.ypColorSelection8,  UIColor.ypColorSelection9,
                          UIColor.ypColorSelection10, UIColor.ypColorSelection11, UIColor.ypColorSelection12,
                          UIColor.ypColorSelection13, UIColor.ypColorSelection14, UIColor.ypColorSelection15,
                          UIColor.ypColorSelection16, UIColor.ypColorSelection17, UIColor.ypColorSelection18]
    
    //MARK: - Main function
    func configureCell() {
        selectionStyle = .none
        
        addSubViews()
        configureConstraints()
    }
}

//MARK: - UICollectionViewDataSource
extension ColorsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorsCollectionviewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.configureCell(color: colors[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ColorsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.row]
        
        let cell = collectionView.cellForItem(at: indexPath)
        addBorder(cell: cell, color: selectedColor)
    
        delegate?.updateColor(with: selectedColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
}

//MARK: - Private functions
private extension ColorsCell {
    func addSubViews() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(colorsCollectionView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            colorsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func addBorder(cell: UICollectionViewCell?, color: UIColor?) {
        guard let cell = cell,
              let color = color else {
            return
        }
        
        let layer = cell.layer
        
        layer.borderWidth = 3
        layer.cornerRadius = 8
        layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
}
