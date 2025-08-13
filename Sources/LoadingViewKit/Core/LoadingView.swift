//
//  LoadingView.swift
//  LoadingView
//
//  Created by Emre Kuru on 14.07.2025.
//

import UIKit

/// A generic, mode-bound loading view with a clean, type-safe public API.
///
/// `LoadingView<M>` composes a concrete animation strategy and its style
/// via the `LoadingMode` generic parameter. This enforces **compile-time
/// interface segregation**: the view only exposes the `style` that belongs
/// to the selected mode `M` (e.g., `DotsMode`, `RingMode`, `ShimmerMode`).
///
/// ### How it works
/// - `M: LoadingMode` supplies:
///   - a concrete `Strategy` implementation (`M.S`)
///   - a default `Style` for that strategy (`M.S.Style`)
///   - an intrinsic size function derived from the style
/// - The view delegates its rendering, layout, and animation to the strategy.
/// - Public configuration is done through `style`, which is specific to `M`.
///
/// ### Example
/// ```swift
/// let dots = LoadingView<DotsMode>()
/// dots.style.count = 5
/// dots.startAnimating()
/// ```
///
/// - Important: The view lazily builds and updates its layer tree via the strategy.
///   Call `startAnimating()` to add the animation; `stopAnimating()` to remove it.
/// - SeeAlso: `LoadingMode`, `Strategy`, and concrete modes like `DotsMode`.
public final class LoadingView<M: LoadingMode>: UIView, LoadingAnimatable {

    // MARK: - Strategy & Style

    /// Concrete strategy instance for this mode.
    ///
    /// Each `LoadingView` owns its own strategy, which manages the layer hierarchy
    /// and produces the CAAnimation to run. The strategy is created via
    /// `M.makeStrategy()` and kept private to avoid leaking implementation details.
    private var strategy: M.S = M.makeStrategy()

    /// Public, mode-specific style used to configure the strategy.
    ///
    /// Assigning a new style mirrors its values into the strategy and triggers layout.
    /// This is the single entry point for consumers to customize the look & feel.
    public var style: M.S.Style = M.defaultStyle {
        didSet {
            strategy.apply(style: style)
            setNeedsLayout()
        }
    }

    // MARK: - LoadingAnimatable (delegated to strategy)

    /// The layer that will host the animation (e.g., rotation layer, dot layer, gradient layer).
    public var animationHostLayer: CALayer { strategy.hostLayer(in: self) }

    /// Builds the strategy's layer hierarchy if needed (idempotent).
    public func buildLayersIfNeeded() { strategy.build(in: self) }

    /// Returns the fully configured CAAnimation for this strategy.
    public func makeAnimation() -> CAAnimation { strategy.makeAnimation(in: self) }

    // MARK: - Initializers

    /// Designated initializer.
    ///
    /// Applies the default style immediately so the strategy reflects the current configuration.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        strategy.apply(style: style)
    }

    /// Storyboard/XIB initializer.
    ///
    /// Also applies the default style. Strategy builds lazily on demand.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        strategy.apply(style: style)
    }

    // MARK: - Layout

    /// Forwards layout to the strategy so it can update frames, paths, and positions.
    public override func layoutSubviews() {
        super.layoutSubviews()
        strategy.layout(in: self)
    }

    /// Natural size derived from the current mode's style.
    ///
    /// Consumers can override via explicit Auto Layout constraints as needed.
    public override var intrinsicContentSize: CGSize {
        M.intrinsicContentSize(for: style)
    }
}

