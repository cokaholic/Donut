//
//  ConfigManager.swift
//  Donut
//
//  Created by 辰己 佳祐 on 2017/09/20.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

final class ConfigManager {

    enum Const {
        static let centerDiffMin: CGFloat = -100.0
        static let centerDiffMax: CGFloat = 100.0
    }

    static let shared = ConfigManager()

    var centerDiffX: CGFloat = 0.0 {
        willSet {
            self.centerDiffX = checkValueMinMax(newValue: newValue,
                                                minValue: Const.centerDiffMin,
                                                maxValue: Const.centerDiffMax)
        }
    }
    var centerDiffY: CGFloat = 0.0 {
        willSet {
            self.centerDiffY = checkValueMinMax(newValue: newValue,
                                                minValue: Const.centerDiffMin,
                                                maxValue: Const.centerDiffMax)
        }
    }
    var inclinationX: CGFloat = -0.1 {
        willSet {
            self.inclinationX = checkValueMinMax(newValue: newValue,
                                                 minValue: -.pi,
                                                 maxValue: .pi)
        }
    }
    var inclinationZ: CGFloat = 0.0 {
        willSet {
            self.inclinationZ = checkValueMinMax(newValue: newValue,
                                                 minValue: -.pi,
                                                 maxValue: .pi)
        }
    }
    var frontCellAlpha: CGFloat = 1.0 {
        willSet {
            self.frontCellAlpha = checkValueMinMax(newValue: newValue,
                                                   minValue: 0.0,
                                                   maxValue: 1.0)
        }
    }
    var backCellAlpha: CGFloat = 0.7 {
        willSet {
            self.backCellAlpha = checkValueMinMax(newValue: newValue,
                                                  minValue: 0.0,
                                                  maxValue: 1.0)
        }
    }
    var isSelectableCell = true
    var isCellAlignmentCenter = true
    var isBackCellInteractionEnabled = false
    var isOnlyCellInteractionEnabled = true
    var animationCurve: UIViewAnimationCurve = .linear

    func reset() {
        centerDiffX = 0.0
        centerDiffY = 0.0
        inclinationX = -0.1
        inclinationZ = 0.0
        frontCellAlpha = 1.0
        backCellAlpha = 0.7
        isSelectableCell = true
        isCellAlignmentCenter = true
        isBackCellInteractionEnabled = false
        isOnlyCellInteractionEnabled = true
        animationCurve = .linear
    }

    private func checkValueMinMax(newValue: CGFloat, minValue: CGFloat, maxValue: CGFloat) -> CGFloat {
        if newValue < minValue {
            return minValue
        } else if newValue > maxValue {
            return maxValue
        }
        return newValue
    }
}
