//
//  PreviewViewController.swift
//  Donut
//
//  Created by Keisuke Tatsumi on 09/19/2017.
//  Copyright (c) 2017 Keisuke Tatsumi. All rights reserved.
//

import UIKit
import Donut

final class PreviewViewController: UIViewController, DonutViewDelegate {

    enum Const {
        static let cardImageNames = ["01_windy",
                                     "02_fly",
                                     "03_shadow",
                                     "04_watery",
                                     "05_wood",
                                     "06_wind",
                                     "07_jump",
                                     "08_illusion",
                                     "09_silent",
                                     "10_thunder",
                                     "11_sword",
                                     "12_flower"]
    }

    private let donutView = DonutView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Preview"

        donutView.frame = view.bounds
        donutView.delegate = self
        updateConfig()
        donutView.addCells(getCardCells())
        view.addSubview(donutView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateConfig()
        reloadCells()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        donutView.frame = view.bounds
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.reloadCells()
        })
    }

    // MARK: - DonutViewDelegate

    func donutView(_ donutView: DonutView, didChangeCenter cell: DonutViewCell) {
        print("current center cell: \(cell)")
    }

    func donutView(_ donutView: DonutView, didSelect cell: DonutViewCell) {
        print("selected cell: \(cell)")
    }

    // MARK: - Private Methods

    private func updateConfig() {
        let manager = ConfigManager.shared
        donutView.setCenterDiff(CGPoint(x: manager.centerDiffX, y: manager.centerDiffY))
        donutView.setCarouselInclination(angleX: manager.inclinationX, angleZ: manager.inclinationZ)
        donutView.setFrontCellAlpha(manager.frontCellAlpha)
        donutView.setBackCellAlpha(manager.backCellAlpha)
        donutView.setSelectableCell(manager.isSelectableCell)
        donutView.setCellAlignmentCenter(manager.isCellAlignmentCenter)
        donutView.setBackCellInteractionEnabled(manager.isBackCellInteractionEnabled)
        donutView.setOnlyCellInteractionEnabled(manager.isOnlyCellInteractionEnabled)
        donutView.setAnimationCurve(manager.animationCurve)
    }

    private func getCardCells() -> [DonutViewCell] {

        var cells: [DonutViewCell] = []
        for i in 0..<Const.cardImageNames.count {
            let cell = ClowCardCell.makeFromNib()
            cell.imageView.image = UIImage(named: Const.cardImageNames[i])
            cells.append(cell)
        }
        return cells
    }

    private func reloadCells(animated: Bool = false) {
        donutView.removeAllCells(animated: animated)
        donutView.addCells(getCardCells(), animated: animated)
    }
}
