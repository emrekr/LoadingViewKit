//
//  ShimmerMode.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import Foundation

/// A `LoadingMode` implementation that renders a shimmering placeholder effect.
///
/// - Strategy: Uses `StrategyShimmer` to draw a base-colored rectangle
///   overlaid with a moving highlight gradient.
/// - Style: Controlled by `StrategyShimmer.Style`, which includes
///   base/highlight colors, corner radius, preferred size, shimmer width ratio,
///   and animation duration.
/// - Intrinsic Size: Uses `preferredSize` if set; otherwise defaults to 120x12pt.
public enum ShimmerMode: LoadingMode {
    /// Creates a new instance of the `StrategyShimmer` animation strategy.
    public static func makeStrategy() -> StrategyShimmer { StrategyShimmer() }

    /// Provides the default shimmer appearance:
    /// - Base Color: `.label` with 12% alpha
    /// - Highlight Color: `.label` with 28% alpha
    /// - Corner Radius: 6pt
    /// - Preferred Size: 120x12pt
    /// - Shimmer Width Ratio: 0.2
    /// - Duration: 1.2s
    public static var defaultStyle: StrategyShimmer.Style { .init() }

    /// Computes intrinsic content size:
    /// - Returns `preferredSize` if non-zero.
    /// - Defaults to 120x12pt otherwise.
    public static func intrinsicContentSize(for style: StrategyShimmer.Style) -> CGSize {
        style.preferredSize == .zero
            ? CGSize(width: 120, height: 12)
            : style.preferredSize
    }
}
