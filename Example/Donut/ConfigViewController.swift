//
//  ConfigViewController.swift
//  Donut
//
//  Created by 辰己 佳祐 on 2017/09/20.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

final class ConfigViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Config"

        view.backgroundColor = .white

        tableView.register(UINib(nibName: SegmentTableViewCell.Const.cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: SegmentTableViewCell.Const.cellIdentifier)
        tableView.register(UINib(nibName: SwitchTableViewCell.Const.cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: SwitchTableViewCell.Const.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource 

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 4
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentTableViewCell.Const.cellIdentifier,
                                                     for: indexPath) as! SegmentTableViewCell
            switch indexPath.row {
            case 0:
                cell.setCellConfig(cellType: .centerDiffX)
            case 1:
                cell.setCellConfig(cellType: .centerDiffY)
            case 2:
                cell.setCellConfig(cellType: .inclinationX)
            case 3:
                cell.setCellConfig(cellType: .inclinationZ)
            case 4:
                cell.setCellConfig(cellType: .frontCellAlpha)
            case 5:
                cell.setCellConfig(cellType: .backCellAlpha)
            default:
                fatalError()
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.Const.cellIdentifier,
                                                     for: indexPath) as! SwitchTableViewCell
            switch indexPath.row {
            case 0:
                cell.setCellConfig(cellType: .selectableCell)
            case 1:
                cell.setCellConfig(cellType: .cellAlignmentCenter)
            case 2:
                cell.setCellConfig(cellType: .backCellInteractionEnabled)
            case 3:
                cell.setCellConfig(cellType: .onlyCellInteractionEnabled)
            default:
                fatalError()
            }
            return cell
        default:
            fatalError()
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    // MARK: - Button Action

    @IBAction func resetAllConfig(_ sender: Any) {
        ConfigManager.shared.reset()
        tableView.reloadData()
    }
}
