//
//  CategoryCreationViewController.swift
//  Tracker
//
//  Created by Илья Лощилов on 06.09.2024.
//

import Foundation
import UIKit

final class CategoryCreationViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var viewModel: CategoryViewModel
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = TextField()
        textField.placeholder = ""
        textField.backgroundColor = .ypLightGrey
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self,
                            action: #selector(textFieldDidChange),
                            for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var doneButton = Button(
        title: NSLocalizedString("doneButtonTitle", comment: ""),
        style: .normal,
        color: .ypBlack
    ) {
        guard let name = self.categoryNameTextField.text else { return }
        self.viewModel.createNewCategory(with: name)
        self.dismiss(animated: true)
    }
    
    // MARK: - Initializers
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        navigationItem.title = NSLocalizedString("categoryCreationTitle", comment: "")
        
        view.backgroundColor = .ypWhite
        doneButton.isEnabled = false
        view.addSubviews([categoryNameTextField, doneButton])
        
        NSLayoutConstraint.activate([
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension CategoryCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        if let text = textField.text {
            if text.count == 0 {
                doneButton.isEnabled = false
            } else {
                doneButton.isEnabled = true
            }
        }
    }
}
