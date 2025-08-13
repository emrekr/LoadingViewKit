//
//  DotsMode.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import Foundation

/// A `LoadingMode` implementation that renders a sequence of bouncing/fading dots.
///
/// - Strategy: Uses `StrategyDots` to draw equally spaced circular dots.
/// - Style: Controlled by `StrategyDots.Style`, which includes
///   parameters like `dotColor`, `size`, `count`, and `spacing`.
/// - Intrinsic Size: Width is calculated from the number of dots,
///   their size, and the spacing between them. Height equals the dot size.
@frozen
public enum DotsMode: LoadingMode {
    /// Creates a new instance of the `StrategyDots` animation strategy.
    public static func makeStrategy() -> StrategyDots { StrategyDots() }

    /// Provides the default appearance for the dots:
    /// - Color: `.label`
    /// - Count: 3
    /// - Size: 8pt
    /// - Spacing: 10pt
    /// - Duration: 0.6s
    public static var defaultStyle: StrategyDots.Style { .init() }

    /// Computes intrinsic content size based on style configuration.
    /// Ensures width accounts for both dot size and inter-dot spacing.
    public static func intrinsicContentSize(for style: StrategyDots.Style) -> CGSize {
        let w = CGFloat(style.count) * style.size
              + CGFloat(style.count - 1) * style.spacing
        return CGSize(width: max(w, 1), height: style.size)
    }
}
