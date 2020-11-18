//
//  EpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 18.11.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet var episodeDescriptionLabel: UILabel!
    
    var episodeUrl: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchEpisode(from: episodeUrl) { episode in
            self.title = episode.episode
            self.episodeDescriptionLabel.text = episode.description
        }
    }

}
