//
//  SelectCategoryViewController.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

//MARK: - Protocols
protocol CreateNewCategoryDelegate: AnyObject {
    func createNewCategory(category: String)
}

final class SelectCategoryViewController: UIViewController {
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("categories", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
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
        
        label.text = NSLocalizedString("mes10", tableName: "LocalizableStr", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypBlack
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    private lazy var addCateroryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(
            NSLocalizedString("mes11", tableName: "LocalizableStr", comment: ""),
            for: .normal
        )
        button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        button.backgroundColor = UIColor.ypBlack
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        
        return button
    }()
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = 75
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .ypWhite
        
        return tableView
    }()
    
    //MARK: - Private variables
    private let viewModel: SelectCategoryViewModel
    
    //MARK: - Initialization
    init(viewModel: SelectCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.onChange = self.categoryTableView.reloadData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

//MARK: - CreateNewCategoryDelegate
extension SelectCategoryViewController: CreateNewCategoryDelegate {
    func createNewCategory(category: String) {
        viewModel.addNewCategory(category: category)
        
        changeVisability()
    }
}

//MARK: - UITableViewDataSource
extension SelectCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = viewModel.categories[indexPath.row]
        let header = category.header
        
        guard let cell = categoryTableView.dequeueReusableCell(
            withIdentifier: "categoryTableCell",
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(text: header)
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension SelectCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateCategory(category: viewModel.categories[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
        dismiss(animated: true)
    }
}

//MARK: - Private functions
private extension SelectCategoryViewController {
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite

        changeVisability()
        configureTableView()
        addSubViews()
        configureConstraints()
    }
    
    func changeVisability() {
        let categoiesNotEmpty = viewModel.categories.count > 0
        categoryTableView.isHidden = !categoiesNotEmpty
        centerLabel.isHidden = categoiesNotEmpty
        centerImageView.isHidden = categoiesNotEmpty
    }
    
    func configureTableView() {
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryTableCell")
    }
    
    func addSubViews() {
        view.addSubview(categoryTableView)
        view.addSubview(centerImageView)
        view.addSubview(centerLabel)
        view.addSubview(headerLabel)
        view.addSubview(addCateroryButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: addCateroryButton.topAnchor),
            
            centerImageView.widthAnchor.constraint(equalToConstant: 80),
            centerImageView.heightAnchor.constraint(equalToConstant: 80),
            centerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            centerLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 8),
            centerLabel.centerXAnchor.constraint(equalTo: centerImageView.centerXAnchor),
            
            addCateroryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCateroryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCateroryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCateroryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    func addCategory() {
        let createNewCategoryViewController = CreateNewCategoryViewController()
        createNewCategoryViewController.delegate = self
        let navigatonViewController = UINavigationController(rootViewController: createNewCategoryViewController)
        
        present(navigatonViewController, animated: true)
    }
}
