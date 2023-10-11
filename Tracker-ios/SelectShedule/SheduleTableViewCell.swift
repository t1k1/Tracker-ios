//
//  SheduleTableViewCell.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 04.10.2023.
//

import UIKit

final class SheduleTableViewCell: UITableViewCell {
    //MARK: - Public functions
    weak var delegate: SheduleTableCellDelegate?
    
    //MARK: - Layout variables
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var switcherView: UISwitch = {
        let switcherView = UISwitch(frame: .zero)
        switcherView.translatesAutoresizingMaskIntoConstraints = false
        
        switcherView.setOn(false, animated: true)
        switcherView.onTintColor = UIColor.ypBlue
        switcherView.addTarget(self, action: #selector(swicherChanged), for: .valueChanged)
        
        return switcherView
    }()
    
    //MARK: - Private variables
    private var weekDay: WeekDay?
    
    //MARK: - Main function
    func configureCell(weekDay: WeekDay, switchIsActive: Bool) {
        nameLabel.text = weekDay.dayName
        switcherView.isOn = switchIsActive
        self.weekDay = weekDay
        
        addSubViews()
        configureConstraints()
    }
}

//MARK: - Private functions
private extension SheduleTableViewCell {
    func addSubViews() {
        contentView.backgroundColor = UIColor.ypBackground
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(switcherView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 65),
            
            switcherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcherView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc
    func swicherChanged(_ sender : UISwitch) {
        guard let weekDay = weekDay,
              let delegate = delegate else {
            return
        }
        
        if sender.isOn {
            delegate.addDay(nameOfDay: weekDay)
        } else {
            delegate.removeDay(nameOfDay: weekDay)
        }
    }
}
