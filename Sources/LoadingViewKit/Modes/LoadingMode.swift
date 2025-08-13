//
//  LoadingMode.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import Foundation

/// Represents a *mode* (or variant) of the `LoadingView`, such as "Dots", "Ring", or "Shimmer".
///
/// A mode is essentially a **type-safe binding** between:
///  1. A concrete `Strategy` implementation (`S`) — the rendering & animation logic for this style.
///  2. Its public `Style` type — the user-facing configuration values for that strategy.
///  3. Any additional *mode-level defaults* — such as the default style configuration
///     and the calculation of an intrinsic content size for Auto Layout.
///
/// By using `LoadingMode`, we achieve **compile-time interface segregation**:
///  - The generic `LoadingView<M>` will only expose the `style` relevant to the chosen mode `M`.
///  - The view cannot accidentally use style properties from a different mode.
///  - Adding a new mode only requires implementing this protocol with its own strategy & style.
///
/// - Note: The associated `S` type here *must* be a class (reference type)
///         conforming to the internal `Strategy` protocol.
/// - SeeAlso: `Strategy` for the internal contract between a loading mode and its animation logic.
public protocol LoadingMode {
    /// The concrete `Strategy` type that implements the actual rendering & animation for this mode.
    associatedtype S: Strategy

    /// Creates a fresh instance of the concrete strategy.
    ///
    /// This allows each `LoadingView` to own its own strategy instance rather than sharing a singleton.
    static func makeStrategy() -> S

    /// The default configuration values for this mode’s `Style`.
    ///
    /// Used to initialize a `LoadingView`’s `style` when the view is first created.
    /// This should represent the *most commonly desired* appearance for this mode.
    static var defaultStyle: S.Style { get }

    /// Computes the intrinsic content size for this mode given its current style.
    ///
    /// - Parameter style: The style instance whose values may affect sizing
    ///                    (e.g., dot count & spacing for dots, radius for ring).
    /// - Returns: A `CGSize` that represents this mode's ideal, natural size
    ///            for Auto Layout purposes. Return `.zero` if no intrinsic size is preferred.
    static func intrinsicContentSize(for style: S.Style) -> CGSize
}

