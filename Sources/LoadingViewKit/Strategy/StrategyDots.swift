//
//  StrategyDots.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

/// A loading animation strategy that renders a horizontal sequence of equally spaced, pulsing dots.
///
/// - Layers:
///   - `CAReplicatorLayer` duplicates a single dot into multiple instances.
///   - `CALayer` (dotLayer) represents the individual dot shape.
/// - Animation:
///   - Simultaneous scale and opacity animations grouped together and applied to the dot.
/// - Style Parameters:
///   - `color`, `size`, `count`, `spacing`, `duration`.
public final class StrategyDots: Strategy {

    /// Public configuration for the dots animation.
    public struct Style {
        public var color: UIColor = .label
        public var size: CGFloat = 8
        public var count: Int = 3
        public var spacing: CGFloat = 10
        public var duration: CFTimeInterval = 0.6
    }

    // MARK: Internal State (mirrored from Style)
    private var dotColor: UIColor = .label
    private var dotSize: CGFloat = 8
    private var dotCount: Int = 3
    private var dotSpacing: CGFloat = 10
    private var duration: CFTimeInterval = 0.6

    // MARK: Layers
    private let replicator = CAReplicatorLayer()
    private let dotLayer = CALayer()
    private var didBuild = false

    public func apply(style: Style) {
        dotColor = style.color
        dotSize = style.size
        dotCount = style.count
        dotSpacing = style.spacing
        duration = style.duration
    }

    public func hostLayer(in view: UIView) -> CALayer { dotLayer }

    public func build(in view: UIView) {
        guard !didBuild else { return }
        view.layer.addSublayer(replicator)
        replicator.addSublayer(dotLayer)

        dotLayer.backgroundColor = dotColor.cgColor
        dotLayer.cornerRadius = dotSize / 2

        replicator.instanceCount = dotCount
        replicator.instanceDelay = duration / Double(max(dotCount, 1))

        didBuild = true
    }

    public func layout(in view: UIView) {
        guard didBuild else { return }
        replicator.frame = view.bounds

        let totalWidth = CGFloat(dotCount) * dotSize + CGFloat(dotCount - 1) * dotSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let y = (view.bounds.height - dotSize) / 2

        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        dotLayer.cornerRadius = dotSize / 2
        dotLayer.position = CGPoint(x: startX + dotSize / 2, y: y + dotSize / 2)

        replicator.instanceTransform = CATransform3DMakeTranslation(dotSize + dotSpacing, 0, 0)

        // Re-apply updated config in case style changed post-build
        dotLayer.backgroundColor = dotColor.cgColor
        replicator.instanceCount = dotCount
        replicator.instanceDelay = duration / Double(max(dotCount, 1))
    }

    public func makeAnimation(in view: UIView) -> CAAnimation {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.6
        scale.toValue = 1.0
        scale.duration = duration
        scale.autoreverses = true
        scale.repeatCount = .infinity
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.3
        opacity.toValue = 1.0
        opacity.duration = duration
        opacity.autoreverses = true
        opacity.repeatCount = .infinity
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let group = CAAnimationGroup()
        group.animations = [scale, opacity]
        group.duration = duration
        group.autoreverses = true
        group.repeatCount = .infinity
        return group
    }
}
