//
//  CollectionHeader.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class CollectionHeader: UICollectionViewCell {
    
    // MARK: - Constants

    static let identifier = "CollectionHeader"
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var delegate: CollectionHeaderDelegate?
    
    // MARK: - Private Properties
    
    private let trackerManager = TrackerManager.shared
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.backgroundColor = .ypLightGrey
        stack.layer.cornerRadius = 16
        stack.alignment = .center
        return stack
    }()
    
    private lazy var textField: UITextField = {
        let textField = TextField()
        textField.placeholder = "Enter tracker's name"
        textField.delegate = self
        textField.backgroundColor = .ypLightGrey
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self,
                            action: #selector(textFieldDidChange),
                            for: .editingChanged)
        return textField
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        return view
    }()
    
    private lazy var categoryButton = ListButton(
        title: "Category",
        subTitle: trackerManager.newTracker.categoryName
    ) {
        self.delegate?.openCategories()
    }
    
    private lazy var scheduleButton = ListButton(
        title: "Schedule",
        subTitle: trackerManager.newTracker.schedule
    ) {
        self.delegate?.openSchedule()
    }
    
    // MARK: - Private Functions

    private func setUp() {
        contentView.addSubviews([textField, containerStack])
        containerStack.addArrangedSubview(categoryButton)
        categoryButton.layer.cornerRadius = 16
        if trackerManager.isRegular {
            containerStack.addArrangedSubview(line)
            containerStack.addArrangedSubview(scheduleButton)
            scheduleButton.layer.cornerRadius = 16
        }
      
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),

            categoryButton.topAnchor.constraint(equalTo: containerStack.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: containerStack.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        if trackerManager.isRegular {
            NSLayoutConstraint.activate([
                line.heightAnchor.constraint(equalToConstant: 1),
                line.widthAnchor.constraint(equalTo: containerStack.widthAnchor, constant: -32),
                line.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),

                scheduleButton.leadingAnchor.constraint(equalTo: containerStack.leadingAnchor),
                scheduleButton.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor),
                scheduleButton.heightAnchor.constraint(equalToConstant: 75),
                scheduleButton.topAnchor.constraint(equalTo: line.bottomAnchor)
            ])
        }
    }
    
    func setupCell() {
        scheduleButton.setSubTitle(subtitle: trackerManager.newTracker.schedule)
        categoryButton.setSubTitle(subtitle: trackerManager.newTracker.categoryName)
        textField.text = trackerManager.newTracker.name
    }
}

// MARK: - UITextFieldDelegate

extension CollectionHeader: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.trackerManager.changeName(name: textField.text)
        textField.endEditing(true)
        return false
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        guard let length = textField.text?.count else { return }
        trackerManager.setError(error: length < 38 ? nil : "38 character limit")
    }
}
