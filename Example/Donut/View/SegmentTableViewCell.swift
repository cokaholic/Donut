//
//  SegmentTableViewCell.swift
//  Donut
//
//  Created by 辰己 佳祐 on 2017/09/20.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

final class SegmentTableViewCell: UITableViewCell {

    enum Const {
        static let cellIdentifier = "SegmentTableViewCell"
    }

    enum CellType {
        case none
        case centerDiffX
        case centerDiffY
        case inclinationX
        case inclinationZ
        case frontCellAlpha
        case backCellAlpha
    }

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    private var cellType: CellType = .none
    private var values: [CGFloat] = []

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        segmentedControl.removeAllSegments()
        cellType = .none
        values = []
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        segmentedControl.removeAllSegments()
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlChanged(_:)),
                                   for: .valueChanged)
    }

    func setCellConfig(cellType: CellType) {
        self.cellType = cellType

        switch cellType {
        case .centerDiffX, .centerDiffY:
            values = [ConfigManager.Const.centerDiffMin, ConfigManager.Const.centerDiffMin / 2, 0.0, ConfigManager.Const.centerDiffMax / 2, ConfigManager.Const.centerDiffMax]
        case .inclinationX, .inclinationZ:
            values = [-0.2, -0.1, 0.0, 0.1, 0.2]
        case .frontCellAlpha, .backCellAlpha:
            values = [0.0, 0.3, 0.5, 0.7, 1.0]
        case .none:
            values = []
            break
        }

        var currentIndex: Int = 0
        let manager = ConfigManager.shared
        for (index, value) in values.enumerated() {
            segmentedControl.insertSegment(withTitle: "\(value)", at: segmentedControl.numberOfSegments, animated: false)

            switch cellType {
            case .centerDiffX:
                titleLabel.text = "Center Diff X"
                if value == manager.centerDiffX {
                    currentIndex = index
                }
            case .centerDiffY:
                titleLabel.text = "Center Diff Y"
                if value == manager.centerDiffY {
                    currentIndex = index
                }
            case .inclinationX:
                titleLabel.text = "Inclination X"
                if value == manager.inclinationX {
                    currentIndex = index
                }
            case .inclinationZ:
                titleLabel.text = "Inclination Z"
                if value == manager.inclinationZ {
                    currentIndex = index
                }
            case .frontCellAlpha:
                titleLabel.text = "Front Cell Alpha"
                if value == manager.frontCellAlpha {
                    currentIndex = index
                }
            case .backCellAlpha:
                titleLabel.text = "Back Cell Alpha"
                if value == manager.backCellAlpha {
                    currentIndex = index
                }
            case .none:
                break
            }
        }
        segmentedControl.selectedSegmentIndex = currentIndex
    }

    @objc private func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {

        let manager = ConfigManager.shared
        switch cellType {
        case .centerDiffX:
            manager.centerDiffX = values[segmentedControl.selectedSegmentIndex]
        case .centerDiffY:
            manager.centerDiffY = values[segmentedControl.selectedSegmentIndex]
        case .inclinationX:
            manager.inclinationX = values[segmentedControl.selectedSegmentIndex]
        case .inclinationZ:
            manager.inclinationZ = values[segmentedControl.selectedSegmentIndex]
        case .frontCellAlpha:
            manager.frontCellAlpha = values[segmentedControl.selectedSegmentIndex]
        case .backCellAlpha:
            manager.backCellAlpha = values[segmentedControl.selectedSegmentIndex]
        case .none:
            break
        }
    }
}
