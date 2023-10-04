//
//  CreateNewCategorySwift.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

final class CreateNewCategoryViewController: UIViewController {
    //MARK: - Layout variables
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Новая каегория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.ypBlack
        
        return label
    }()
    private lazy var nameCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.setLeftPaddingPoints(10)
        textField.placeholder = "Введите название ктегории"
        textField.backgroundColor = UIColor.ypBackground
        textField.layer.cornerRadius = 16
        textField.delegate = self
        
        return textField
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.backgroundColor = UIColor.ypGray
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        
        return button
    }()
    
    weak var delegate: CreateNewCategoryDelegate?
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
}

//MARK: - UITextFieldDelegate
extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
           text.count > 0 {
            
            doneButton.isEnabled = true
            doneButton.backgroundColor = UIColor.ypBlack
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = UIColor.ypGray
        }
        textField.resignFirstResponder()
        return true
    }
}

private extension CreateNewCategoryViewController {
    func setUpView() {
        view.backgroundColor = UIColor.ypWhite
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(nameCategoryTextField)
        view.addSubview(doneButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),

            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func done(){
        guard let text = nameCategoryTextField.text,
              let delegate = delegate else {
            return
        }
        delegate.createNewCategory(category: text)
        
        dismiss(animated: true)
    }
}
