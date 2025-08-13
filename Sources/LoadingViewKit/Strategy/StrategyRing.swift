//
//  StrategyRing.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

/// A loading animation strategy that renders a partial circular arc rotating indefinitely.
///
/// - Layers:
///   - `CAShapeLayer` draws the arc.
///   - `CALayer` (rotationLayer) is rotated to animate the ring.
/// - Animation:
///   - Continuous rotation around the Z-axis.
/// - Style Parameters:
///   - `lineWidth`, `strokeColor`, `gapRatio`, `rotationDuration`.
public final class StrategyRing: Strategy {

    public struct Style {
        public var lineWidth: CGFloat = 3
        public var strokeColor: UIColor = .label
        /// 0...1 portion of the circle to leave empty.
        public var gapRatio: CGFloat = 0.25
        public var rotationDuration: CFTimeInterval = 0.9
    }

    // MARK: Internal State
    private var lineWidth: CGFloat = 3
    private var strokeColor: UIColor = .label
    private var gapRatio: CGFloat = 0.25
    private var rotationDuration: CFTimeInterval = 0.9

    // MARK: Layers
    private let shape = CAShapeLayer()
    private let rotationLayer = CALayer()
    private var didBuild = false

    public func apply(style: Style) {
        lineWidth = style.lineWidth
        strokeColor = style.strokeColor
        gapRatio = style.gapRatio
        rotationDuration = style.rotationDuration
    }

    public func hostLayer(in view: UIView) -> CALayer { rotationLayer }

    public func build(in view: UIView) {
        guard !didBuild else { return }
        view.layer.addSublayer(rotationLayer)
        rotationLayer.addSublayer(shape)

        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = strokeColor.cgColor
        shape.lineCap = .round
        shape.lineWidth = lineWidth

        didBuild = true
    }

    public func layout(in view: UIView) {
        guard didBuild else { return }

        rotationLayer.frame = view.bounds
        let side = min(view.bounds.width, view.bounds.height)
        let radius = (side - lineWidth) / 2
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)

        let clampedGap = max(0, min(gapRatio, 0.95))
        let start: CGFloat = -.pi / 2
        let end: CGFloat = start + 2 * .pi * (1 - clampedGap)

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        shape.frame = view.bounds
        shape.path = path.cgPath
        shape.lineWidth = lineWidth
        shape.strokeColor = strokeColor.cgColor
    }

    public func makeAnimation(in view: UIView) -> CAAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = 2 * CGFloat.pi
        rotation.duration = rotationDuration
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        return rotation
    }
}
