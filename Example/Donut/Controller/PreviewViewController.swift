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
        donutView.setCenterDiff(CGPoint(x: 0, y: 0))
        donutView.setCarouselInclination(angleX: 0.0, angleZ: 0.0)
        donutView.setFrontCellAlpha(1.0)
        donutView.setBackCellAlpha(0.7)
        donutView.setSelectableCell(true)
        donutView.setCellAlignmentCenter(true)
        donutView.setBackCellInteractionEnabled(false)
        donutView.setOnlyCellInteractionEnabled(true)
        donutView.setAnimationCurve(.linear)

        donutView.addCells(getCardCells())

        donutView.delegate = self
        view.addSubview(donutView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
