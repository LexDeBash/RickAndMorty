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
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = result.description
        setupChracterImageView()
        view.backgroundColor = .black
        setupNavigationBar()
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
            
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: self.result.image) else { return }
            DispatchQueue.main.async {
                self.chracterImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func setupNavigationBar() {
        title = result.name
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}
