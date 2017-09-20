//
//  DonutViewCell.swift
//  Donut
//
//  Created by Keisuke Tatsumi on 2017/07/06.
//  Copyright © 2017 Keisuke Tatsumi. All rights reserved.
//

import UIKit

open class DonutViewCell: UIView {

    private(set) var angle: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
    }

    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
    }

    // MARK: - Public Functions

    public func setCellAngle(_ angle: CGFloat) {
        self.angle = angle
    }
}
