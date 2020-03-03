//
//  Extension + UIViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

extension UIViewController {
    func transform(for view: UIView, nameAnimation: String, duration: CFTimeInterval, fromValue: Float, toValue: Float, autoreverses: Bool, repeatCount: Float) {
        
        let animation = CASpringAnimation(keyPath: nameAnimation)
        
        animation.duration = duration
        animation.fromValue = duration
        animation.toValue = fromValue
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        view.layer.add(animation, forKey: nil)
    }
}
