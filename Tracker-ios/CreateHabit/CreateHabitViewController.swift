//
//  CreateHabitViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

//MARK: - Protocols
protocol CreateHabitDelegate: AnyObject {
    func updateCategory(category: TrackerCategory)
}

protocol SelectSheduleDelegate: AnyObject {
    func updateShedule(shedule: [WeekDay])
}

protocol TextFieldDelegate: AnyObject {
    func updateHabitName(with name: String?)
}

protocol EmojiCellDelegate: AnyObject {
    func updateEmoji(with emoji: String?)
}

protocol ColorsCellDelegate: AnyObject {
    func updateColor(with color: UIColor?)
}

//MARK: - CreateHabitViewController
final class CreateHabitViewController: UIViewController {
    //MARK: - Public variables
    weak var delegate: TrackerViewControllerDelegate?
    var tableCellNames: Dictionary<Int, [String]>?
    var editTracker: Tracker?
    
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("mes8", tableName: "LocalizableStr", comment: "")
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
        
        button.setTitle(
            NSLocalizedString("cancel", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
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
        
        button.setTitle(
            NSLocalizedString("create", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        button.backgroundColor = UIColor.ypGray
        button.isEnabled = false
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    //MARK: - Private variables
    private var category: TrackerCategory?
    private var sheduleArr: [WeekDay]?
    private var habitName: String?
    private var emoji: String?
    private var color: UIColor?
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        fillSheduleIfRequired()
    }
}

//MARK: - UITableViewDelegate
extension CreateHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CreateHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableCellNames = tableCellNames,
              let section = tableCellNames[section] else {
            return 0
        }
        return section.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let tableCellNames = tableCellNames else { return 0 }
        return tableCellNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "textFieldCell",
                for: indexPath
            ) as? TextFieldCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureCell()
            
            return cell
        } else if indexPath.section == 1 {
            var text = ""
            var description: String? = nil
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "categorySheduleCell",
                for: indexPath
            ) as? CategorySheduleCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                text = NSLocalizedString("category", tableName: "LocalizableStr", comment: "")
                description = category?.header
            } else {
                text = NSLocalizedString("shedule", tableName: "LocalizableStr", comment: "")
                description = stringFromSheduleArr()
            }
            
            cell.configureCell(text: text, description: description)
            
            return cell
            
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "emojiCell",
                for: indexPath
            ) as? EmojiCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.configureCell()
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "colorsCell",
                for: indexPath
            ) as? ColorsCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.configureCell()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 75
        } else {
            return 198
        }
    }
}

//MARK: - CreateHabitDelegate
extension CreateHabitViewController: CreateHabitDelegate {
    func updateCategory(category: TrackerCategory) {
        self.category = category
        changeCreateButton()
        tableView.reloadData()
    }
}

//MARK: - SelectSheduleDelegate
extension CreateHabitViewController: SelectSheduleDelegate {
    func updateShedule(shedule: [WeekDay]) {
        self.sheduleArr = shedule
        changeCreateButton()
        tableView.reloadData()
    }
}

//MARK: - TextFieldDelegate
extension CreateHabitViewController: TextFieldDelegate {
    func updateHabitName(with name: String?) {
        if name == "" {
            self.habitName = nil
        } else {
            self.habitName = name
        }
        changeCreateButton()
    }
}

//MARK: - EmojiCellDelegate
extension CreateHabitViewController: EmojiCellDelegate{
    func updateEmoji(with emoji: String?) {
        self.emoji = emoji
        changeCreateButton()
        tableView.reloadData()
    }
}

//MARK: - ColorsCellDelegate
extension CreateHabitViewController: ColorsCellDelegate {
    func updateColor(with color: UIColor?) {
        self.color = color
        changeCreateButton()
        tableView.reloadData()
    }
}

//MARK: - Private functions
private extension CreateHabitViewController {
    //MARK: - Configurating functions
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite
        
        if let editTracker = editTracker {
            
        }
        
        configureTableView()
        addSubViews()
        configureConstraints()
    }
    
    func configureTableView() {
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(CategorySheduleCell.self, forCellReuseIdentifier: "categorySheduleCell")
        tableView.register(EmojiCell.self, forCellReuseIdentifier: "emojiCell")
        tableView.register(ColorsCell.self, forCellReuseIdentifier: "colorsCell")
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
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            
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
    
    func  fillSheduleIfRequired() {
        guard let tableCellNames = tableCellNames,
              let section = tableCellNames[1] else {
            return
        }
        
        if section.count == 1 {
            sheduleArr = WeekDay.allCases
        }
    }
    
    //MARK: - Private class functions
    func selectCell(indexPath: IndexPath) {
        var viewController: UIViewController?
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let viewModel = SelectCategoryViewModel(delegate: self)
                viewController = SelectCategoryViewController(viewModel: viewModel)
            } else if indexPath.row == 1 {
                viewController = SelectSheduleViewController()
            }
            
            presentSelect(viewController)
        }
    }
    
    func presentSelect(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        if let viewController = viewController as? SelectSheduleViewController {
            viewController.delegate = self
            viewController.currentShedule = sheduleArr
        }
        
        let navigatonViewController = UINavigationController(rootViewController: viewController)
        present(navigatonViewController, animated: true)
    }
    
    func changeCreateButton() {
        if let category = category,
           let sheduleArr = sheduleArr,
           let habitName = habitName,
           let _ = color,
           let _ = emoji,
           let _ = delegate,
           category.header.count > 0,
           habitName.count > 0,
           sheduleArr.count > 0
        {
            
            createButton.backgroundColor = UIColor.ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = UIColor.ypGray
            createButton.isEnabled = false
        }
    }
    
    func stringFromSheduleArr() -> String? {
        guard let arr = sheduleArr else { return nil }
        
        var stringResult = ""
        if arr.count == 7 {
            stringResult = NSLocalizedString("everyDay", tableName: "LocalizableStr", comment: "")
        } else {
            let filter = arr.map { $0.shortDayName }
            stringResult = filter.joined(separator: ", ")
        }
        return stringResult
    }
    
    //MARK: - Buttons functions
    @objc
    func create() {
        if let category = category,
           let sheduleArr = sheduleArr,
           let habitName = habitName,
           let color = color,
           let emoji = emoji,
           let delegate = delegate {
            
            delegate.addNewTracker(
                category: category,
                sheduleArr: sheduleArr,
                habitName: habitName,
                emoji: emoji,
                color: color,
                pinned: false
            )
            
            guard let window = UIApplication.shared.windows.first,
                  let rootViewController = window.rootViewController else {
                assertionFailure("Invalid Configuration")
                return
            }
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func cancel() {
        dismiss(animated: true)
    }
}
