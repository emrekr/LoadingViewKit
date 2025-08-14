//
//  ViewController.swift
//  LoadingView
//
//  Created by Emre Kuru on 14.07.2025.
//

import UIKit
import LoadingViewKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dots = LoadingView<DotsMode>()
        dots.style.color = .systemGreen
        dots.style.count = 4
        dots.style.size = 10
        dots.startAnimating()

        // Ring
        let ring = LoadingView<RingMode>()
        ring.style.strokeColor = .label
        ring.style.lineWidth = 4
        ring.style.gapRatio = 0.2
        ring.startAnimating()

        // Shimmer
        let shimmer = LoadingView<ShimmerMode>()
        shimmer.style.baseColor = UIColor.label.withAlphaComponent(0.12)
        shimmer.style.highlightColor = UIColor.label.withAlphaComponent(0.28)
        shimmer.style.widthRatio = 0.22
        shimmer.startAnimating()
            
        //Wave
        let waveView = LoadingView<WaveDotsMode>()
        waveView.style.color = .black
        waveView.style.secondaryColor = .red
        waveView.style.count = 3
        waveView.style.amplitude = 10
        waveView.startAnimating()

        let stackView = UIStackView(arrangedSubviews: [dots, ring, shimmer, waveView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }


}

