//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class CharcterDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }

    // MARK: - Public properties
    var character: Character!
    
    private var spinnerView: UIActivityIndicatorView!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView = showSpinner(in: characterImageView)
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        title = character.name
        descriptionLabel.text = character.description
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: self.character.image) else { return }
            DispatchQueue.main.async {
                self.characterImageView.image = UIImage(data: imageData)
                self.spinnerView.stopAnimating()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let episodesVC = navigationController.topViewController as! EpisodesViewController
        episodesVC.character = character
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}
