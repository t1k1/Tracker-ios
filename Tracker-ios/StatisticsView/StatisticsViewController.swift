//
//  StatisticsViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 02.10.2023.
//

import UIKit

class StatisticsViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("statistics", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var centerImageView: UIImageView = {
        let image = UIImage(named: "CenterImageStatistics")
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("mes14", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var completedTrackersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var completedTrackersResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var completedTrackersTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("mes15", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypBlack
        label.textAlignment = .left
        
        return label
    }()
    
    private let recordStore = TrackerRecordStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        updateRecords()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setGradientBorder()
    }
    
    func updateRecords() {
        guard let completedTrackers = try? recordStore.fetchTrackerRecords() else { return }
        completedTrackersResultLabel.text = String(completedTrackers.count)
        
        let isHidden = completedTrackers.count > 0
        centerImageView.isHidden = isHidden
        centerLabel.isHidden = isHidden
        completedTrackersView.isHidden = !isHidden
    }
}

private extension StatisticsViewController {
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(centerImageView)
        view.addSubview(centerLabel)
        
        view.addSubview(completedTrackersView)
        completedTrackersView.addSubview(completedTrackersResultLabel)
        completedTrackersView.addSubview(completedTrackersTitleLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            centerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerImageView.widthAnchor.constraint(equalToConstant: 80),
            centerImageView.heightAnchor.constraint(equalToConstant: 80),
            
            centerLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 8),
            centerLabel.centerXAnchor.constraint(equalTo: centerImageView.centerXAnchor),
            
            completedTrackersView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            completedTrackersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completedTrackersView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completedTrackersView.heightAnchor.constraint(equalToConstant: 90),
            
            completedTrackersResultLabel.topAnchor.constraint(equalTo: completedTrackersView.topAnchor, constant: 12),
            completedTrackersResultLabel.leadingAnchor.constraint(equalTo: completedTrackersView.leadingAnchor, constant: 12),
            completedTrackersResultLabel.trailingAnchor.constraint(equalTo: completedTrackersView.trailingAnchor, constant: -12),
            completedTrackersResultLabel.heightAnchor.constraint(equalToConstant: 41),
            
            completedTrackersTitleLabel.bottomAnchor.constraint(equalTo: completedTrackersView.bottomAnchor, constant: -12),
            completedTrackersTitleLabel.leadingAnchor.constraint(equalTo: completedTrackersView.leadingAnchor, constant: 12),
            completedTrackersTitleLabel.trailingAnchor.constraint(equalTo: completedTrackersView.trailingAnchor, constant: -12),
            completedTrackersTitleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setGradientBorder() {
        let border = CAGradientLayer()
        border.frame = completedTrackersView.bounds
        border.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        border.startPoint = CGPoint(x: 0, y: 0.5)
        border.endPoint = CGPoint(x: 1, y: 0.5)
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: completedTrackersView.bounds, cornerRadius: 16).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = 1
        
        border.mask = mask
        
        completedTrackersView.layer.addSublayer(border)
    }
    
}
