//
//  AddNewTrackerViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

final class AddNewTrackerViewController: UIViewController {
    //MARK: - Public variables
    weak var delegate: TrackerViewControllerDelegate?
    
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("mes7", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var createHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(
            NSLocalizedString("habit", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
        button.addTarget(self, action: #selector(createHabit), for: .touchUpInside)
        button.backgroundColor = UIColor.ypBlack
        button.layer.cornerRadius = 16
        
        return button
    }()
    private lazy var createEventButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(
            NSLocalizedString("irregularEvent", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
        button.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        button.backgroundColor = UIColor.ypBlack
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
}

//MARK: - Private functions
private extension AddNewTrackerViewController {
    func setUpView() {
        view.backgroundColor = UIColor.white
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(createEventButton)
        view.addSubview(createHabitButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            
            createHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            createEventButton.leadingAnchor.constraint(equalTo: createHabitButton.leadingAnchor),
            createEventButton.trailingAnchor.constraint(equalTo: createHabitButton.trailingAnchor),
            createEventButton.topAnchor.constraint(equalTo: createHabitButton.bottomAnchor, constant: 16),
            createEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func createHabit() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = delegate
        createHabitViewController.tableCellNames = [
            0: ["textField"],
            1: ["category","shedule"],
            2: ["emoji"],
            3: ["colors"]
        ]
        
        let navigatonViewController = UINavigationController(rootViewController: createHabitViewController)
        present(navigatonViewController, animated: true)
    }
    
    @objc
    func createEvent() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = delegate
        createHabitViewController.tableCellNames = [
            0: ["textField"],
            1: ["category"],
            2: ["emoji"],
            3: ["colors"]
        ]
        
        let navigatonViewController = UINavigationController(rootViewController: createHabitViewController)
        present(navigatonViewController, animated: true)
    }
}
