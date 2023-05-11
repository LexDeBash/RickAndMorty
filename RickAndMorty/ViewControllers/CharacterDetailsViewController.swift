//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

final class CharacterDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }
    
    // MARK: - Public properties
    var character: Character!
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var spinnerView = UIActivityIndicatorView()
        
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        title = character.name
        descriptionLabel.text = character.description
        showSpinner(in: characterImageView)
        fetchImage()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination
        guard let navigationVC = navigationVC as? UINavigationController else { return }
        let episodesVC = navigationVC.topViewController
        guard let episodesVC = episodesVC as? EpisodesViewController else { return }
        episodesVC.character = character
    }
    
    // MARK: - Private Methods
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .white
        spinnerView.startAnimating()
        spinnerView.center = characterImageView.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }
    
    private func fetchImage() {
        networkManager.fetchImage(from: character.image) { result in
            switch result {
            case .success(let imageData):
                self.characterImageView.image = UIImage(data: imageData)
                self.spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
