//
//  RingMode.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import Foundation

/// A `LoadingMode` implementation that renders a continuously rotating partial ring.
///
/// - Strategy: Uses `StrategyRing` to draw a stroked circular path
///   with a configurable line width, stroke color, gap ratio, and rotation speed.
/// - Style: Controlled by `StrategyRing.Style`.
/// - Intrinsic Size: Default is a fixed square (32x32), but this can
///   be overridden by Auto Layout constraints.
public enum RingMode: LoadingMode {
    /// Creates a new instance of the `StrategyRing` animation strategy.
    public static func makeStrategy() -> StrategyRing { StrategyRing() }
    
    /// Provides the default ring appearance:
    /// - Stroke Color: `.label`
    /// - Line Width: 3pt
    /// - Gap Ratio: 0.25 (25% of the ring is empty)
    /// - Rotation Duration: 0.9s
    public static var defaultStyle: StrategyRing.Style { .init() }

    /// Returns a fixed intrinsic size, making the ring visually square.
    /// Consumers can override via constraints if needed.
    public static func intrinsicContentSize(for style: StrategyRing.Style) -> CGSize {
        CGSize(width: 32, height: 32)
    }
}
