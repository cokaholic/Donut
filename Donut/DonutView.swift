//
//  DonutView.swift
//  Donut
//
//  Created by Keisuke Tatsumi on 2017/07/06.
//  Copyright © 2017 Keisuke Tatsumi. All rights reserved.
//

import UIKit

@objc public protocol DonutViewDelegate: NSObjectProtocol {
    @objc optional func donutView(_ donutView: DonutView, didChangeCenter cell: DonutViewCell)
    @objc optional func donutView(_ donutView: DonutView, didSelect cell: DonutViewCell)
}

open class DonutView: UIView {

    weak open var delegate: DonutViewDelegate?

    private var inclinationAngleX: CGFloat = 0.0
    private var inclinationAngleZ: CGFloat = 0.0
    private var frontCellAlpha: CGFloat = 1.0
    private var backCellAlpha: CGFloat = 0.7
    private var isSelectableCell = true
    private var isCellAlignmentCenter = true
    private var isBackCellInteractionEnabled = false
    private var isOnlyCellInteractionEnabled = true
    private var animationCurve: UIViewAnimationCurve = .linear

    private var cells: [DonutViewCell] = []
    private var isSingleTap = false
    private var startPosition: CGFloat = 0.0
    private var separationAngle: CGFloat = 0.0
    private var radius: CGFloat = 0.0
    private var centerDiff: CGPoint = CGPoint(x: 0, y: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpInitialState()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpInitialState()
    }

    // MARK: - Public Functions

    public func setSelectedCellAndCenter(_ cell: DonutViewCell) {
        if cell.angle >= .pi {
            moveDonut(angleOffset: -(cell.angle - (2.0 * .pi)))
        } else {
            moveDonut(angleOffset: -cell.angle)
        }
    }

    public func addCell(_ cell: DonutViewCell, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let me = self else { return }
            me.layer.insertSublayer(cell.layer, at: UInt32(me.cells.count))
            cell.layer.position = CGPoint(x: me.frame.width / 2.0 + me.centerDiff.x, y: me.frame.height / 2.0 + me.centerDiff.y)
            me.cells.append(cell)
            me.refreshCellsPosition(animated: animated)
        }
    }

    public func addCells(_ cells: [DonutViewCell], animated: Bool = true) {
        cells.forEach { [weak self] cell in
            self?.addCell(cell, animated: animated)
        }
    }

    public func removeCell(cell: DonutViewCell) {

        guard let index: Int = cells.index(of: cell) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let me = self else { return }
            cell.layer.removeFromSuperlayer()
            me.cells.remove(at: index)
            me.refreshCellsPosition(animated: true)
        }
    }
    
   public func removeAllCells(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let me = self else { return }
            me.cells.forEach { [weak self] cell in
                cell.layer.removeFromSuperlayer()
                self?.refreshCellsPosition(animated: animated)
            }
            me.cells.removeAll()
        }
    }

    // default value is x: 0.0, z: 0.0
    public func setCarouselInclination(angleX: CGFloat = 0.0, angleZ: CGFloat = 0.0) {
        inclinationAngleX = angleX
        inclinationAngleZ = angleZ
    }

    // default value is 1.0
    public func setFrontCellAlpha(_ alpha: CGFloat) {
        if alpha >= 0.0 && alpha <= 1.0 {
            frontCellAlpha = alpha
        }
    }

    // default value is 0.7
    public func setBackCellAlpha(_ alpha: CGFloat) {
        if alpha >= 0.0 && alpha <= 1.0 {
            backCellAlpha = alpha
        }
    }
    
    // default is (0, 0)
    public func setCenterDiff(_ centerDiff: CGPoint) {
        self.centerDiff = centerDiff
    }

    // default value is true
    public func setSelectableCell(_ isSelectableCell: Bool) {
        self.isSelectableCell = isSelectableCell
    }

    // default value is true
    public func setCellAlignmentCenter(_ isCellAlignmentCenter: Bool) {
        self.isCellAlignmentCenter = isCellAlignmentCenter
    }

    // default value is false
    public func setBackCellInteractionEnabled(_ enabled: Bool) {
        isBackCellInteractionEnabled = enabled
    }

    // default value is true
    public func setOnlyCellInteractionEnabled(_ enabled: Bool) {
        isOnlyCellInteractionEnabled = enabled
    }

    // default value is .linear
    public func setAnimationCurve(_ animationCurve: UIViewAnimationCurve) {
        self.animationCurve = animationCurve
    }

    public func getCellAtIndex(_ index: Int) -> DonutViewCell? {
        if cells.count == 0 {
            return nil
        }
        return circularObject(cells: cells, index: index)
    }
    
    public func getCells() -> [DonutViewCell] {
        return cells
    }

    // MARK: - UIResponder Functions

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchEvent = touches.first else { return }
        let targetPoint = touchEvent.location(in: self)
        guard let targetLayer = layer.hitTest(targetPoint) else { return }
        let targetCell = findCellOnScreen(targetLayer: targetLayer)

        if isCellPositionBack(angle: targetCell?.angle) && !isBackCellInteractionEnabled {
            return
        }

        if targetCell == nil && isOnlyCellInteractionEnabled {
            return
        }

        startPosition = targetPoint.x

        isSingleTap = touchEvent.tapCount == 1
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touchEvent = touches.first else { return }
        let targetPoint = touchEvent.location(in: self)
        guard let targetLayer = layer.hitTest(targetPoint) else { return }
        let targetCell = findCellOnScreen(targetLayer: targetLayer)

        if isCellPositionBack(angle: targetCell?.angle) && !isBackCellInteractionEnabled {
            return
        }

        if targetCell == nil && isOnlyCellInteractionEnabled {
            return
        }

        let movedPoint = touchEvent.location(in: self)
        let offset = startPosition - movedPoint.x
        if offset != 0 {
            isSingleTap = false
        }
        let offsetToMove = -atan(offset / radius)

        startPosition = movedPoint.x

        moveDonut(angleOffset: offsetToMove)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touchEvent = touches.first else { return }
        let targetPoint = touchEvent.location(in: self)
        guard let targetLayer = layer.hitTest(targetPoint) else { return }
        let targetCell = findCellOnScreen(targetLayer: targetLayer)

        if isCellPositionBack(angle: targetCell?.angle) && !isBackCellInteractionEnabled {
            return
        }

        if targetCell == nil && isOnlyCellInteractionEnabled {
            if isCellAlignmentCenter, let selectedCell = getSelectedCell() {
                setSelectedCellAndCenter(selectedCell)
            }
            return
        }

        if isSingleTap && isSelectableCell {
            if let targetCell = targetCell {
                setSelectedCellAndCenter(targetCell)
                delegate?.donutView?(self, didSelect: targetCell)
                delegate?.donutView?(self, didChangeCenter: targetCell)
            }
        } else {
            if isCellAlignmentCenter, let selectedCell = getSelectedCell() {
                setSelectedCellAndCenter(selectedCell)
            }
        }

        isSingleTap = false
    }

    // MARK: - Private Functions

    private func setUpInitialState() {

        isUserInteractionEnabled = true
        autoresizesSubviews = true
        clipsToBounds = true
    }

    private func refreshCellsPosition(animated: Bool) {
        if cells.count == 0 {
            return
        }

        let cellView = cells[0]

        radius = (cellView.bounds.size.width / 2.0) / tan(.pi / CGFloat(cells.count))
        separationAngle = (2.0 * .pi) / CGFloat(cells.count)

        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(animationCurve)
            UIView.setAnimationBeginsFromCurrentState(true)
        }

        var angle: CGFloat = 0.0
        for cell in cells {
            cell.setCellAngle(angle)
            cell.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            cell.layer.anchorPointZ = -radius
            cell.layer.transform = CATransform3DMakeRotation(cell.angle, 0, 1, 0)
            cell.layer.transform = CATransform3DConcat(cell.layer.transform, CATransform3DMakeRotation(inclinationAngleX, 1, 0, 0))
            cell.layer.transform = CATransform3DConcat(cell.layer.transform, CATransform3DMakeRotation(inclinationAngleZ, 0, 0, 1))
            cell.alpha = isCellPositionBack(angle: angle) ? backCellAlpha : frontCellAlpha

            angle += separationAngle
        }

        if animated {
            UIView.commitAnimations()
        }
    }

    private func findCellOnScreen(targetLayer: CALayer) -> DonutViewCell? {
        var foundCell: DonutViewCell? = nil

        for h in 0..<cells.count {
            let cell = circularObject(cells: cells, index: h)

            if cell.layer.isEqual(targetLayer) {
                foundCell = cell
                break
            }

            for i in 0..<cell.subviews.count {
                let subView = cell.subviews[i]

                if subView.layer.isEqual(targetLayer) {
                    foundCell = cell
                    break
                }

                for j in 0..<subView.subviews.count {
                    let subSubView = subView.subviews[j]

                    if subSubView.layer.isEqual(targetLayer) {
                        foundCell = cell
                        break
                    }
                }
            }
        }
        return foundCell
    }

    private func moveDonut(angleOffset: CGFloat) {

        if fabs(angleOffset) == 0.0 { return }

        let cellsMoved = fabs(angleOffset / separationAngle)

        for i in 0..<cells.count {
            let cell = circularObject(cells: cells, index: i)
            cell.setCellAngle(cell.angle + angleOffset)

            UIView.animate(withDuration: TimeInterval((0.1 * cellsMoved)),
                           delay: 0,
                           options: [UIViewAnimationOptions(curve: animationCurve), .beginFromCurrentState],
                           animations: {
                            cell.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(angleOffset, 0, 1, 0), cell.layer.transform)
                            cell.alpha = self.isCellPositionBack(angle: cell.angle) ? self.backCellAlpha : self.frontCellAlpha
            }, completion: { [weak self] _ in
                guard let me = self else { return }
                while cell.angle > (2 * .pi) {
                    cell.setCellAngle(cell.angle - (2.0 * .pi))
                }
                while cell.angle < 0 {
                    cell.setCellAngle(cell.angle + (2.0 * .pi))
                }
                
                if cell.angle == 0 {
                    me.delegate?.donutView?(me, didChangeCenter: cell)
                }
            })
        }
    }

    private func getSelectedCell() -> DonutViewCell? {

        if cells.count == 0 { return nil }

        var minimumAngle: CGFloat = .pi
        var selectedCell: DonutViewCell? = nil

        for i in 0..<cells.count {
            let cell = circularObject(cells: cells, index: i)
            var angle = cell.angle
            angle = abs(angle)

            while angle > (2.0 * .pi) {
                angle = angle - (2.0 * .pi)
            }

            if angle < minimumAngle {
                minimumAngle = angle
                selectedCell = cell
            }
        }

        return selectedCell
    }

    private func isCellPositionBack(angle: CGFloat?) -> Bool {
        guard let angle = angle else { return false }
        if angle > .pi / 2.0 && angle < 1.5 * .pi {
            return true
        }
        return false
    }
}

// MARK: - For Circular

extension DonutView {

    func circularObject(cells: [DonutViewCell], index: Int) -> DonutViewCell {

        var circularIndex = index
        while circularIndex < 0 {
            circularIndex = circularIndex + cells.count
        }
        return cells[circularIndex%cells.count]
    }

    func circularPreviusObject(cells: [DonutViewCell], cell: DonutViewCell) -> DonutViewCell? {

        guard let index = cells.index(of: cell) else { return nil }
        return circularObject(cells: cells, index: index - 1)
    }

    func circularNextObject(cells: [DonutViewCell], cell: DonutViewCell) -> DonutViewCell? {

        guard let index = cells.index(of: cell) else { return nil }
        return circularObject(cells: cells, index: index + 1)
    }
}
