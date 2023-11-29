//
//  FiltesViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.11.2023.
//

import UIKit

protocol FiltesViewControllerDelegate: AnyObject {
    func changeCurrentFilter(_ filter: Filter)
}

final class FiltesViewController: UIViewController {
    weak var delegate: FiltesViewControllerDelegate?
    var currentFiler: Filter?
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .ypBlack
        label.text = NSLocalizedString("filters", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "filterTableViewCell")
        tableView.separatorColor = .ypGray
        tableView.backgroundColor = .ypWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 75
        
        return tableView
    }()
    
    private let allFilters = Filter.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
}

extension FiltesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "filterTableViewCell",
            for: indexPath
        ) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        
        let filter = allFilters[indexPath.row]
        
        cell.configureCell(name: filter.localizedString, checkMark: currentFiler == filter)
        
        return cell
    }
}

extension FiltesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? FilterTableViewCell {
            delegate?.changeCurrentFilter(allFilters[indexPath.row])
            dismiss(animated: true) }
    }
}

private extension FiltesViewController {
    func setUpView() {
        view.backgroundColor = .ypWhite
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
