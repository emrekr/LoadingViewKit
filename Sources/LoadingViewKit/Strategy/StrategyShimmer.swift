//
//  StrategyShimmer.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

/// A loading animation strategy that renders a shimmering highlight
/// moving horizontally across a base-colored rectangle.
///
/// - Layers:
///   - `CALayer` (backgroundLayer) holds the static base color.
///   - `CAGradientLayer` draws the moving highlight.
///   - `CAShapeLayer` (maskLayer) restricts shimmer to rounded bounds.
/// - Animation:
///   - Animates the gradient's `locations` to move highlight from left to right.
/// - Style Parameters:
///   - `baseColor`, `highlightColor`, `cornerRadius`, `preferredSize`,
///     `widthRatio`, `duration`.
public final class StrategyShimmer: Strategy {

    /// User-facing style for the shimmer.
    public struct Style {
        public var baseColor: UIColor = UIColor.label.withAlphaComponent(0.12)
        public var highlightColor: UIColor = UIColor.label.withAlphaComponent(0.28)
        public var cornerRadius: CGFloat = 6
        public var preferredSize: CGSize = .init(width: 120, height: 12)
        /// Relative width (0...1) of the highlight band.
        public var widthRatio: CGFloat = 0.2
        /// Duration of one full shimmer pass.
        public var duration: CFTimeInterval = 1.2
    }

    // MARK: Internal State
    private var baseColor: UIColor = UIColor.label.withAlphaComponent(0.12)
    private var highlightColor: UIColor = UIColor.label.withAlphaComponent(0.28)
    private var cornerRadius: CGFloat = 6
    private var preferredSize: CGSize = .init(width: 120, height: 12)
    private var widthRatio: CGFloat = 0.2
    private var shimmerDuration: CFTimeInterval = 1.2

    // MARK: Layers
    private let backgroundLayer = CALayer()
    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()
    private var didBuild = false

    public func apply(style: Style) {
        baseColor = style.baseColor
        highlightColor = style.highlightColor
        cornerRadius = style.cornerRadius
        preferredSize = style.preferredSize
        widthRatio = style.widthRatio
        shimmerDuration = style.duration
    }

    public func hostLayer(in view: UIView) -> CALayer { gradientLayer }

    public func build(in view: UIView) {
        guard !didBuild else { return }

        view.layer.addSublayer(backgroundLayer)
        view.layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer

        // Horizontal gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)

        // 4 stops: base, highlight, highlight, base
        gradientLayer.colors = [
            baseColor.cgColor,      // 0.0
            highlightColor.cgColor, // left
            highlightColor.cgColor, // right
            baseColor.cgColor       // 1.0
        ]

        didBuild = true
    }

    public func layout(in view: UIView) {
        guard didBuild else { return }

        let bounds = view.bounds

        backgroundLayer.frame = bounds
        backgroundLayer.backgroundColor = baseColor.cgColor
        backgroundLayer.cornerRadius = cornerRadius

        gradientLayer.frame = bounds

        // Rounded mask (keeps gradient within a pill shape)
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

        // Compute highlight band edges from widthRatio
        let w = max(0.05, min(widthRatio, 0.9))
        let left  = max(0.0, 0.5 - w / 2)
        let right = min(1.0, 0.5 + w / 2)

        gradientLayer.locations = [
            0.0,
            NSNumber(value: Double(left)),
            NSNumber(value: Double(right)),
            1.0
        ]

        // Colors may change at runtime
        gradientLayer.colors = [
            baseColor.cgColor,
            highlightColor.cgColor,
            highlightColor.cgColor,
            baseColor.cgColor
        ]
    }

    public func makeAnimation(in view: UIView) -> CAAnimation {
        let w = max(0.05, min(widthRatio, 0.9))
        let left  = 0.5 - w / 2
        let right = 0.5 + w / 2

        // Animate the 4 location stops from just before 0 to just after 1
        let fromLocations: [NSNumber] = [
            NSNumber(value: -Double(w)),        // base before 0
            NSNumber(value: Double(left - w)),  // highlight leading offscreen
            NSNumber(value: Double(left)),      // highlight trailing at left
            0.0                                 // base at start
        ]
        let toLocations: [NSNumber] = [
            1.0,                                // base at end
            NSNumber(value: Double(right)),     // highlight leading at right
            NSNumber(value: Double(right + w)), // highlight trailing offscreen
            NSNumber(value: Double(1.0 + w))    // base after 1
        ]

        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = fromLocations
        anim.toValue = toLocations
        anim.duration = shimmerDuration
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        return anim
    }
}
