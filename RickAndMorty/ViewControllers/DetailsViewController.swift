//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var chracterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Public properties
    var result: Result!
    var charcterUrl: String?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupChracterImageView()
        
        if charcterUrl == nil {
            descriptionLabel.text = result.description
            fetchImage()
        }
        
        if let charcterUrl = charcterUrl {
            NetworkManager.shared.fetchCharacter(from: charcterUrl) { result in
                self.title = result.name
                self.descriptionLabel.text = result.description
                guard let imageData = ImageManager.shared.fetchImage(from: result.image) else { return }
                DispatchQueue.main.async {
                    self.chracterImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let episodesVC = navigationController.topViewController as! EpisodesViewController
        episodesVC.result = result
    }
    
    // MARK: - Private methods
    private func setupChracterImageView() {
        chracterImageView.layer.cornerRadius = chracterImageView.bounds.width / 2
        chracterImageView.backgroundColor = .white
    }
    
    private func fetchImage() {
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: self.result.image) else { return }
            DispatchQueue.main.async {
                self.chracterImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func setupNavigationBar() {
        if charcterUrl == nil {
            title = result.name
        }
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}
