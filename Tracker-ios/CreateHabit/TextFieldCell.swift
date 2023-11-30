//
//  File.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 03.10.2023.
//

import UIKit

final class TextFieldCell: UITableViewCell {
    //MARK: - Public variables
    weak var delegate: TextFieldDelegate?
    var text: String?
    
    //MARK: - Layout variables
    private lazy var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.placeholder = NSLocalizedString("mes9", tableName: "LocalizableStr", comment: "")
        textField.layer.cornerRadius = 16
        textField.delegate = self
        
        return textField
    }()
    
    //MARK: - Main function
    func configureCell() {
        contentView.backgroundColor = UIColor.ypBackground
        selectionStyle = .none
        
        nameHabitTextField.text = text ?? ""
        
        addSubViews()
        configureConstraints()
    }
}

//MARK: - UITextFieldDelegate
extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString: NSString? = textField.text as? NSString
        guard let currentString = currentString else { return true }
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        let isAcceptableLength = newString.length <= maxLength
        
        if isAcceptableLength {
            delegate?.updateHabitName(with: newString as String)
        }
        
        return isAcceptableLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

//MARK: - Private functions
private extension TextFieldCell {
    func addSubViews() {
        contentView.backgroundColor = UIColor.ypBackground
        
        contentView.addSubview(nameHabitTextField)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            nameHabitTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameHabitTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameHabitTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameHabitTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
