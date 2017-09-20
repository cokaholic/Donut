//
//  UIViewAnimationOptionsExtension.swift
//  TKCarouselView
//
//  Created by Keisuke Tatsumi on 2017/09/12.
//  Copyright © 2017 Keisuke Tatsumi. All rights reserved.
//

import UIKit

extension UIViewAnimationOptions {
    init(curve: UIViewAnimationCurve) {
        switch curve {
        case .easeIn:
            self = .curveEaseIn
        case .easeOut:
            self = .curveEaseOut
        case .easeInOut:
            self = .curveEaseInOut
        case .linear:
            self = .curveLinear
        }
    }
}
