//
//  UIView+addTapGesture.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.07.2024.
//

import Foundation
import UIKit

extension UIView {

    func addTapGesture(_ action: @escaping () -> Void ) {
        let tap = TapGestureRecognizer(target: self,
                                       action: #selector(self.handleTap(_:)))
        tap.action = action
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    @objc func handleTap(_ sender: TapGestureRecognizer) {
        guard let action = sender.action else { return }
        action()
    }
}

final class TapGestureRecognizer: UITapGestureRecognizer {
    var action: (() -> Void)?
}
