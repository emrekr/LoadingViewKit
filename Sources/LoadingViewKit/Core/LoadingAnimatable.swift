//
//  LoadingAnimatable.swift
//  LoadingView
//
//  Created by Emre Kuru on 13.08.2025.
//

import UIKit

/// Common behaviours for all loading animations: start/stop, status check, accessibility,
/// and idempotent setup.
public protocol LoadingAnimatable where Self: UIView {
    /// The layer where the animation will be applied (e.g., dotLayer, rotationLayer, or self.layer
    var animationHostLayer: CALayer { get }
    /// Builds the layer hierarchy. Must be idempotent (safe to call multiple times without duplications.)
    func buildLayersIfNeeded()
    /// Returns the CAAnimation (can be group) to run on the host layer.
    func makeAnimation() -> CAAnimation
    
    /// The animation key for the identifying the animation on the host layer.
    var animationKey: String { get }
}

public extension LoadingAnimatable {
    /// Default animation key.
    var animationKey: String { "loading.anim" }
    
    /// Whether the animation is currently running.
    var isAnimating: Bool {
        animationHostLayer.animation(forKey: animationKey) != nil
    }
    
    /// Starts the animation if it's not already running.
    public func startAnimating() {
        guard !isAnimating else { return }
        buildLayersIfNeeded()
        let anim = makeAnimation()
        animationHostLayer.add(anim, forKey: animationKey)
        
        // Accessibility - default behavior for most loading views
        if isAccessibilityElement == false {
            isAccessibilityElement = true
            accessibilityLabel = "Loading"
            accessibilityTraits.insert(.updatesFrequently)
        }
    }
    
    /// Stops the animation if it's running.
    func stopAnimating() {
        guard isAnimating else { return }
        animationHostLayer.removeAnimation(forKey: animationKey)
    }
}
