//
//  StubView.swift
//  Tracker
//
//  Created by Илья Лощилов on 27.06.2024.
//

import Foundation
import UIKit

final class StubView: UIView {
    
    private var emoji = ""
    private var text = ""
    
    private lazy var image = UIImageView()
    private lazy var label = UILabel()
    
    init(emoji: String,
         text: String) {
        super.init(frame: .zero)
        self.emoji = emoji
        self.text = text
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .ypBlack
        
        addSubviews([image, label])
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: emoji)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),

            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
}
