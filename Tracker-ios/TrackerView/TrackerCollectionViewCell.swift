//
//  TrackerCollectionViewCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 06.10.2023.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    //MARK: - Public variables
    weak var delegate: TrackerCellDelegate?
    var menuView: UIView {
        return colorView
    }
    
    //MARK: - Layout variables
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.ypBackgroundSecond
        label.layer.cornerRadius = 12
        
        return label
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypWhite
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("mes6", tableName: "LocalizableStr", comment: "")
        label.textColor = UIColor.ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 11))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTap), for: .touchUpInside)
        button.tintColor = UIColor.ypWhite
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        return button
    }()
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 16
        
        return colorView
    }()
    private lazy var quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    private lazy var pinImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.image = UIImage(named: "PinImage")
        image.isHidden = false
        
        return image
    }()
    
    //MARK: - Private variables
    private var isCompleted: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    private var selectedDate: Date?
    
    //MARK: - Main function
    func configureCell(
        tracker: Tracker,
        isCompleted: Bool,
        daysCount: Int,
        indexPath: IndexPath,
        selectedDate: Date,
        pinned: Bool
    ) {
        
        self.prepareForReuse()
        
        self.isCompleted = isCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
        self.selectedDate = selectedDate
        
        changePlusButton()
        daysLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("days count", comment: "Число дней"),
            daysCount
        )
        
        colorView.backgroundColor = tracker.color
        plusButton.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        pinImageView.isHidden = !pinned
        
        addSubViews()
        configureConstraints()
        
    }
}

//MARK: - Private functions
private extension TrackerCollectionViewCell {
    func addSubViews() {
        contentView.addSubview(colorView)
        colorView.addSubview(nameLabel)
        colorView.addSubview(emojiLabel)
        colorView.addSubview(pinImageView)
        contentView.addSubview(quantityStackView)
        quantityStackView.addArrangedSubview(daysLabel)
        quantityStackView.addArrangedSubview(plusButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 26),
            emojiLabel.heightAnchor.constraint(equalToConstant: 26),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            
            pinImageView.heightAnchor.constraint(equalToConstant: 12),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            pinImageView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 18),
            pinImageView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            quantityStackView.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            quantityStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            quantityStackView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            quantityStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func changePlusButton() {
        if isCompleted {
            plusButton.alpha = 0.5
            plusButton.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 11)), for: .normal)
        } else {
            plusButton.alpha = 1
            plusButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 11)), for: .normal)
        }
    }
    
    @objc
    func plusButtonTap() {
        
        guard let trackerId = trackerId,
              let indexPath = indexPath,
              let selectedDate = selectedDate else {
            return
        }
        
        if selectedDate > Date() {
            return
        }
        
        isCompleted = !isCompleted
        changePlusButton()
        delegate?.updateTrackerRecord(id: trackerId, isCompleted: isCompleted, indexPath: indexPath)
    }
}
