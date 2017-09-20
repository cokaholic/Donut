//
//  ClowCardCell.swift
//  TKCarouselView
//
//  Created by 辰己 佳祐 on 2017/09/19.
//  Copyright © 2017年 辰己 佳祐. All rights reserved.
//

import UIKit
import Donut

final class ClowCardCell: DonutViewCell {

    class func makeFromNib() -> ClowCardCell {
        let nib = UINib(nibName: "ClowCardCell", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil)[0] as! ClowCardCell
    }

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            backgroundColor = .clear
            contentMode = .scaleAspectFit
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
}
