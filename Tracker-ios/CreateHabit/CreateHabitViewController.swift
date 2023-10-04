//
//  CreateHabitViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

protocol CreateHabitDelegate: AnyObject {
    func updateCategory(category: TrackerCategory)
}

protocol SelectSheduleDelegate: AnyObject {
    func updateShedule(shedule: [WeekDay])
}

final class CreateHabitViewController: UIViewController {
    private struct const {
        static let tableCellNames = [["textField"],["category","shedule"]]
    }
    
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 75
        tableView.backgroundColor = UIColor.ypWhite
        
        return tableView
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Отменить", for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        
        return button
    }()
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        button.backgroundColor = UIColor.ypGray
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    //MARK: - Private variables
    private var category: TrackerCategory?
    private var sheduleArr: [WeekDay]?
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
}

private extension CreateHabitViewController {
    func setUpView() {
        view.backgroundColor = UIColor.white
        
        configureTableView()
        addSubViews()
        configureConstraints()
    }
    
    func configureTableView() {
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(CategorySheduleCell.self, forCellReuseIdentifier: "categorySheduleCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor)
        ])
    }
    
    @objc
    func create() {
        
    }
    
    @objc
    func cancel() {
        dismiss(animated: true)
    }
    
    func selectCell(indexPath: IndexPath) {
        var viewController: UIViewController?
        
        if indexPath.row == 0 {
            viewController = SelectCategoryViewController()
        } else if indexPath.row == 1 {
            viewController = SelectSheduleViewController()
        }
        
        presentSelect(viewController)
    }
    
    func presentSelect(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        if let viewController = viewController as? SelectCategoryViewController {
            viewController.delegate = self
        } else if let viewController = viewController as? SelectSheduleViewController {
            viewController.delegate = self
        }
    
        let navigatonViewController = UINavigationController(rootViewController: viewController)
        present(navigatonViewController, animated: true)
    }
    
    func presentSelectCategory() {
        let selectCategoryViewController = SelectCategoryViewController()
        selectCategoryViewController.delegate = self
        let navigatonViewController = UINavigationController(rootViewController: selectCategoryViewController)
        present(navigatonViewController, animated: true)
    }
    
    func presentSelectShedule() {
        let selectSheduleViewController = SelectSheduleViewController()
        selectSheduleViewController.delegate = self
        let navigatonViewController = UINavigationController(rootViewController: selectSheduleViewController)
        present(navigatonViewController, animated: true)
    }
}

extension CreateHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CreateHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return const.tableCellNames[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return const.tableCellNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "textFieldCell",
                for: indexPath
            ) as? TextFieldCell else {
                return UITableViewCell()
            }
            cell.configureCell()
            
            return cell
        } else {
            var text = ""
            var description: String? = nil
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "categorySheduleCell",
                for: indexPath
            ) as? CategorySheduleCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                text = "Категория"
                description = category?.header
            } else {
                text = "Расписание"
                description = stringFromSheduleArr()
            }

            cell.configureCell(text: text, description: description)
            
            return cell
        }
    }
    
    func stringFromSheduleArr() -> String? {
        guard let arr = sheduleArr else { return nil }
        
        var stringResult = ""
        if arr.count == 7 {
            stringResult = "Каждый день"
        } else {
            let filter = arr.map { $0.shortDayName }
            stringResult = filter.joined(separator: ", ")
        }
        return stringResult
    }
}

extension CreateHabitViewController: CreateHabitDelegate {
    func updateCategory(category: TrackerCategory) {
        self.category = category
        tableView.reloadData()
    }
}

extension CreateHabitViewController: SelectSheduleDelegate {
    func updateShedule(shedule: [WeekDay]) {
        self.sheduleArr = shedule
        tableView.reloadData()
    }
}
