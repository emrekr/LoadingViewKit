//
//  StrategyWaveDots.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

//
//  StrategyWaveDots.swift
//  LoadingAnimations
//
/// A loading animation strategy where a series of equally spaced dots
/// animate vertically in a sequential wave pattern.
///
/// Uses `CAReplicatorLayer` to duplicate a single dot layer (`dotLayer`) horizontally.
/// The animation is applied only to the original dot, and the replicator’s
/// `instanceDelay` staggers the start time for each copy, creating the wave effect.
///
/// Example: With `count = 5` and `duration = 0.4s`,
/// `instanceDelay` is `0.4 / 5 = 0.08s`, so each dot begins its animation
/// 0.08 seconds after the previous one.
public final class StrategyWaveDots: Strategy {

    // MARK: - Public Style

    /// User-facing style for the wave dots animation.
    public struct Style {
        public var color: UIColor = .label             // Dot color
        public var secondaryColor: UIColor = .label    // Secondary color
        public var size: CGFloat = 8                   // Diameter of each dot
        public var count: Int = 5                       // Number of dots
        public var spacing: CGFloat = 8                 // Horizontal spacing between dots
        public var amplitude: CGFloat = 6               // Vertical movement amount
        public var duration: CFTimeInterval = 0.4       // Duration of up-down animation per dot
    }

    // MARK: - Internal Config (mirrored from Style)

    private var dotColor: UIColor = .label
    private var secondaryDotColor: UIColor = .label
    private var dotSize: CGFloat = 8
    private var dotCount: Int = 5
    private var dotSpacing: CGFloat = 8
    private var amplitude: CGFloat = 6
    private var duration: CFTimeInterval = 0.4

    // MARK: - Layers

    /// Handles duplicating the dot horizontally and applying delays.
    private let replicator = CAReplicatorLayer()

    /// The single dot layer that is duplicated.
    private let dotLayer = CALayer()

    /// Prevents duplicate setup work in `build(in:)`.
    private var didBuild = false

    // MARK: - Strategy Conformance

    public func apply(style: Style) {
        dotColor = style.color
        secondaryDotColor = style.secondaryColor
        dotSize = style.size
        dotCount = style.count
        dotSpacing = style.spacing
        amplitude = style.amplitude
        duration = style.duration
    }

    /// The layer whose animation will be driven externally.
    /// We return `dotLayer` (not the replicator) so that only the base dot
    /// receives the animation and the replicator applies time offsets.
    public func hostLayer(in view: UIView) -> CALayer { dotLayer }

    /// Builds the base layers if they haven’t been created yet.
    public func build(in view: UIView) {
        guard !didBuild else { return }

        // Add the replicator to the view’s main layer.
        view.layer.addSublayer(replicator)

        // Add the single dot to the replicator (it will be copied).
        replicator.addSublayer(dotLayer)

        // Basic dot appearance.
        dotLayer.backgroundColor = dotColor.cgColor
        dotLayer.cornerRadius = dotSize / 2

        // Configure replication.
        replicator.instanceCount = dotCount
        replicator.instanceTransform = CATransform3DMakeTranslation(dotSize + dotSpacing, 0, 0)

        // Each dot starts animation slightly later than the previous.
        replicator.instanceDelay = duration / Double(max(dotCount, 1))

        didBuild = true
    }

    /// Lays out the replicator and base dot within the view’s bounds.
    public func layout(in view: UIView) {
        guard didBuild else { return }

        replicator.frame = view.bounds

        let totalWidth = CGFloat(dotCount) * dotSize + CGFloat(dotCount - 1) * dotSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let y = (view.bounds.height - dotSize) / 2

        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        dotLayer.cornerRadius = dotSize / 2
        dotLayer.position = CGPoint(x: startX + dotSize/2, y: y + dotSize/2)
        dotLayer.backgroundColor = dotColor.cgColor

        replicator.instanceTransform = CATransform3DMakeTranslation(dotSize + dotSpacing, 0, 0)
        replicator.instanceCount = dotCount
        replicator.instanceDelay = duration / Double(max(dotCount, 1))
    }

    /// Creates the vertical up-down animation for a single dot.
    /// The replicator will copy this motion to all dots with delays.
    public func makeAnimation(in view: UIView) -> CAAnimation {
        let anim = CABasicAnimation(keyPath: "position.y")
        anim.byValue = -amplitude
        anim.duration = duration
        anim.autoreverses = true
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let color = CABasicAnimation(keyPath: "backgroundColor")
        color.fromValue = dotColor.cgColor
        color.toValue = secondaryDotColor.cgColor
        color.duration = duration
        color.autoreverses = true
        color.repeatCount = .infinity
        color.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.animations = [anim, color]
        group.duration = duration
        group.repeatCount = .infinity
        group.autoreverses = true
        return group
    }
}


