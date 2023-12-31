//
//  SelectSheduleViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

//MARK: - Protocols
protocol SheduleTableCellDelegate: AnyObject {
    func addDay(nameOfDay: WeekDay)
    func removeDay(nameOfDay: WeekDay)
}

final class SelectSheduleViewController: UIViewController {
    //MARK: - Public variables
    weak var delegate: SelectSheduleDelegate?
    var currentShedule: [WeekDay]?
    
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("shedule", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(
            NSLocalizedString("done", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.backgroundColor = UIColor.ypBlack
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        
        return button
    }()
    private lazy var sheduleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = 75
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .ypWhite
        
        return tableView
    }()
    
    //MARK: - Private variables
    private var allDays = WeekDay.allCases
    private var selectedDays: [WeekDay] = []
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
}

//MARK: - UITableViewDataSource
extension SelectSheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = sheduleTableView.dequeueReusableCell(
            withIdentifier: "sheduleTableCell",
            for: indexPath
        ) as? SheduleTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let weekDay = allDays[indexPath.row]
        let switchIsActive = selectedDays.contains(weekDay) ? true : false
        cell.configureCell(weekDay: weekDay, switchIsActive: switchIsActive)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SelectSheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SheduleTableCellDelegate
extension SelectSheduleViewController: SheduleTableCellDelegate {
    func addDay(nameOfDay: WeekDay) {
        selectedDays.append(nameOfDay)
    }
    
    func removeDay(nameOfDay: WeekDay) {
        guard let index = selectedDays.firstIndex(of: nameOfDay) else { return }
        selectedDays.remove(at: index)
    }
}

//MARK: - Private functions
private extension SelectSheduleViewController {
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite
        
        configureTableView()
        addSubViews()
        configureConstraints()
    }
    
    func configureTableView() {
        if let currentShedule = currentShedule {
            selectedDays = currentShedule
        }
        
        sheduleTableView.register(SheduleTableViewCell.self, forCellReuseIdentifier: "sheduleTableCell")
    }
    
    func addSubViews() {
        
        view.addSubview(headerLabel)
        view.addSubview(doneButton)
        view.addSubview(sheduleTableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            
            sheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func done() {
        guard let delegate = delegate else { return }
        delegate.updateShedule(shedule: selectedDays)
        dismiss(animated: true)
    }
}
