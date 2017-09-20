//
//  SwitchTableViewCell.swift
//  Donut
//
//  Created by 辰己 佳祐 on 2017/09/21.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell {

    enum Const {
        static let cellIdentifier = "SwitchTableViewCell"
    }

    enum CellType {
        case none
        case selectableCell
        case cellAlignmentCenter
        case backCellInteractionEnabled
        case onlyCellInteractionEnabled
    }

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var switchControl: UISwitch!

    private var cellType: CellType = .none

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        switchControl.isOn = false
        cellType = .none
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        switchControl.addTarget(self,
                                action: #selector(switchControlChanged(_:)),
                                for: .valueChanged)
    }

    func setCellConfig(cellType: CellType) {
        self.cellType = cellType

        let manager = ConfigManager.shared
        switch cellType {
        case .selectableCell:
            titleLabel.text = "Selectable"
            switchControl.isOn = manager.isSelectableCell
        case .cellAlignmentCenter:
            titleLabel.text = "Auto Cell Alignment Center"
            switchControl.isOn = manager.isCellAlignmentCenter
        case .backCellInteractionEnabled:
            titleLabel.text = "Back Cells Interaction Enabled"
            switchControl.isOn =  manager.isBackCellInteractionEnabled
        case .onlyCellInteractionEnabled:
            titleLabel.text = "Only Cells Interaction Enabled"
            switchControl.isOn = manager.isOnlyCellInteractionEnabled
        case .none:
            break
        }
    }

    @objc private func switchControlChanged(_ switchControl: UISwitch) {

        let manager = ConfigManager.shared
        switch cellType {
        case .selectableCell:
            manager.isSelectableCell = switchControl.isOn
        case .cellAlignmentCenter:
            manager.isCellAlignmentCenter = switchControl.isOn
        case .backCellInteractionEnabled:
            manager.isBackCellInteractionEnabled = switchControl.isOn
        case .onlyCellInteractionEnabled:
            manager.isOnlyCellInteractionEnabled = switchControl.isOn
        case .none:
            break
        }
    }
}
