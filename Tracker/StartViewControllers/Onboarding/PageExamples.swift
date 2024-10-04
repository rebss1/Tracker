//
//  Pages.swift
//  Tracker
//
//  Created by Илья Лощилов on 05.09.2024.
//

import Foundation
import UIKit

enum PageExamples: Int, CaseIterable {
    
    case first = 0, second
    
    var buttonTitle: String {
        switch self {
        case .first:
            return NSLocalizedString("onboardingTitleOne", comment: "")
        case .second:
            return NSLocalizedString("onboardingTitleTwo", comment: "")
        }
    }
    
    var backgroundImage: UIImage {
        switch self {
        case .first:
            return UIImage(named: "onboarding1") ?? UIImage()
        case .second:
            return UIImage(named: "onboarding2") ?? UIImage()
        }
    }
}
