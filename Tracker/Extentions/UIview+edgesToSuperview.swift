//
//  UIview+edgesToSuperview.swift
//  Tracker
//
//  Created by Илья Лощилов on 14.06.2024.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult func edgesToSuperview() -> Self {
        guard let superview = superview else {
            fatalError("View не в иерархии!")
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        return self
    }
}
