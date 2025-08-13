//
//  WaveDotsMode.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

//
//  WaveDotsMode.swift
//  LoadingAnimations
//
/// A mode that binds the `StrategyWaveDots` strategy, its default style,
/// and an intrinsic content size calculator.
///
/// This mode produces an animation where N dots are laid out horizontally,
/// and they move up and down in sequence (wave effect).
public enum WaveDotsMode: LoadingMode {

    /// Create the strategy instance for this mode.
    public static func makeStrategy() -> StrategyWaveDots { StrategyWaveDots() }

    /// The default style configuration for wave dots.
    /// - Defaults:
    ///   - color: `.label`
    ///   - size: 8pt
    ///   - count: 5 dots
    ///   - spacing: 8pt
    ///   - amplitude: 6pt vertical movement
    ///   - duration: 0.4s per bounce
    public static var defaultStyle: StrategyWaveDots.Style { .init() }

    /// Computes the intrinsic content size for a given style.
    ///
    /// The width is calculated as:
    /// ```
    /// totalWidth = (count * size) + ((count - 1) * spacing)
    /// ```
    /// Height is the dot size plus twice the amplitude (since dots can move up or down).
    /// Ensures at least 1x1 size to avoid invalid zero-size views.
    public static func intrinsicContentSize(for style: StrategyWaveDots.Style) -> CGSize {
        let width = CGFloat(style.count) * style.size + CGFloat(style.count - 1) * style.spacing
        let height = style.size + style.amplitude * 2
        return CGSize(width: max(width, 1), height: max(height, 1))
    }
}

