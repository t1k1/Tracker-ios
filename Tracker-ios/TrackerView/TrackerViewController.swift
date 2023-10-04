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
    private lazy var stackViewForSearch: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 14
        
        return stackView
    }()
    private lazy var searchField: UISearchTextField = {
        let search = UISearchTextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        
//        search.backgroundColor = UIColor.ypBackground
//        search.textColor = UIColor.ypBlack
//        search.layer.cornerRadius = 16
        search.delegate = self
//        search.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.ypBackground
//        ]
//        let attributesPlaceholder = NSAttributedString(string: "Поиск", attributes: attributes)
//        search.attributedPlaceholder = attributesPlaceholder
        
        return search
    }()
    private lazy var cancelSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Отмена", for: .normal)
        button.tintColor = UIColor.ypBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.isHidden = true
        
        return button
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
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        collectionViewLayout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    //MARK: - Private variables
    ///Список категорий и вложенных в них трекеров
    var categories: [TrackerCategory] = []
    ///трекеры, которые были «выполнены» в выбранную дату,
    var completedTrackers: [TrackerRecord] = []
    ///чтобы при поиске и/или изменении дня недели отображался другой набор трекеров
    var visibleCategories: [TrackerCategory] = []
    ///для хранения текущей даты в
    var currentDate: Date?

    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
}

private extension TrackerViewController {
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews(){
        view.addSubview(topNavView)
        view.addSubview(collectionView)

        topNavView.addSubview(addButton)
        topNavView.addSubview(datePicker)
        topNavView.addSubview(titleLabel)
        topNavView.addSubview(stackViewForSearch)
        
        stackViewForSearch.addArrangedSubview(searchField)
        stackViewForSearch.addArrangedSubview(cancelSearchButton)
        
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

            stackViewForSearch.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor),
            stackViewForSearch.trailingAnchor.constraint(equalTo: topNavView.trailingAnchor),
            stackViewForSearch.heightAnchor.constraint(equalToConstant: 30),
            stackViewForSearch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topNavView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

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
        let navigatonViewController = UINavigationController(rootViewController: AddNewTrackerViewController())
        present(navigatonViewController, animated: true)
    }
    
    @objc
    func filterDate() {
        print("date")
    }
}

extension TrackerViewController: UITextFieldDelegate {
    
}
