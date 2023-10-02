//
//  ViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.09.2023.
//

import UIKit

class TrackerViewController: UIViewController {
    
    //MARK: - Layout variables
    private lazy var topNavView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var addButton: UIButton = {
        let imageButton = UIImage(named: "PlusIcon")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        
        return button
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.tintColor = UIColor.ypBlue
        datePicker.addTarget(TrackerViewController.self, action: #selector(filterDate), for: .valueChanged)
        
        return datePicker
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var searchController: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        
        search.backgroundImage = UIImage()
        search.layer.borderWidth = 0
        
        return search
    }()
    private lazy var centerImageView: UIImageView = {
        let image = UIImage(named: "CenterImage")
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        configureConstraints()
    }
}

private extension TrackerViewController {
    func addSubViews(){
        view.addSubview(topNavView)
        topNavView.addSubview(addButton)
        topNavView.addSubview(datePicker)
        topNavView.addSubview(titleLabel)
        topNavView.addSubview(searchController)
        
        view.addSubview(centerImageView)
        view.addSubview(centerLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            
            topNavView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topNavView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            topNavView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            topNavView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            addButton.topAnchor.constraint(equalTo: topNavView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),

            datePicker.trailingAnchor.constraint(equalTo: topNavView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: topNavView.topAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 13),

            searchController.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),
            searchController.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchController.trailingAnchor.constraint(equalTo: topNavView.trailingAnchor),
            searchController.heightAnchor.constraint(equalToConstant: 30),

            centerImageView.widthAnchor.constraint(equalToConstant: 80),
            centerImageView.heightAnchor.constraint(equalToConstant: 80),
            centerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            centerLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 8),
            centerLabel.centerXAnchor.constraint(equalTo: centerImageView.centerXAnchor)
        ])
    }
    
    @objc
    func addTracker() {
        print("add")
    }
    
    @objc
    func filterDate() {
        print("date")
    }
}
