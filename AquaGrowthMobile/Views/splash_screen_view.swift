//
//  splash_screen_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import SwiftUI
import Lottie

struct SplashScreen: UIViewRepresentable{
    var filename: String

    func makeUIView(context: Context) -> some UIView{
        let view = UIView(frame:.zero)
        let animationView = LottieAnimationView()

        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFit

        animationView.loopMode = .repeat(1)
        animationView.animationSpeed = 2.0

        animationView.play{isFinished in
            print(isFinished ? "Animation Played" : "Animation Not Played")
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

}
