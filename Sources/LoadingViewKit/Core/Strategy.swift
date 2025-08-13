//
//  Strategy.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

/// An internal protocol that defines the contract for a loading animation strategy.
///
/// Each conforming type is responsible for:
/// - Defining a `Style` struct that controls its public configuration.
/// - Creating and managing the CALayer hierarchy needed for the animation.
/// - Laying out layers according to the `view.bounds`.
/// - Producing the CAAnimation(s) that will run.
/// - Applying style changes dynamically at runtime.
///
/// The `LoadingView` delegates all animation responsibilities to its active `Strategy`,
/// allowing for different animation styles (e.g., dots, ring, shimmer) to be swapped
/// without changing the public API.
public protocol Strategy: AnyObject {
    associatedtype Style

    /// Returns the primary CALayer that should receive the animation.
    ///
    /// - Parameter view: The view hosting the animation.
    func hostLayer(in view: UIView) -> CALayer
    
    /// Builds the necessary layer hierarchy for the animation.
    /// Should be idempotent—calling this multiple times must not create duplicates.
    func build(in view: UIView)

    /// Updates frames, paths, positions, and other layout-related properties
    /// when the hosting view's bounds change.
    func layout(in view: UIView)

    /// Produces and returns the animation to run on the host layer.
    func makeAnimation(in view: UIView) -> CAAnimation

    /// Pushes the public-facing style configuration into the strategy's internal state.
    ///
    /// Implementations should mirror values from `Style` into their internal variables.
    func apply(style: Style)
}
