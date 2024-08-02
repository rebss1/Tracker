//
//  ListButton.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

final class ListButton: UIControl {
    
    var action: () -> Void
    
    init(title: String,
         subTitle: String,
         action: @escaping () -> Void = {}
    ) {
        self.action = action
        super.init(frame: .zero)
        titleLabel.text = title
        subTitleLabel.text = subTitle
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGrey
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .ypGrey
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc private func didTapButton() {
        action()
    }
    
    func setSubTitle(subtitle: String? = "") {
        subTitleLabel.text = subtitle
    }
    
    private func setUp() {
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(subTitleLabel)
        addSubviews([containerStack, image])
        backgroundColor = .ypLightGrey
        addTapGesture(action)
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -16),
            containerStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalToConstant: 24),
            image.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
