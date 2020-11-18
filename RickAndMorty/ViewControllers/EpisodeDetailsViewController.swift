//
//  EpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 18.11.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var episodeDescriptionLabel: UILabel!
    
    var episodeUrl: String!
    var episode: Episode?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        NetworkManager.shared.fetchEpisode(from: episodeUrl) { episode in
            self.episode = episode
            self.title = episode.episode
            self.episodeDescriptionLabel.text = episode.description
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! CharcterDetailsViewController
        detailsVC.charcterUrl = sender as? String
    }

}

// MARK: - Table view data sourse
extension EpisodeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode?.characters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterUrl", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = episode?.characters[indexPath.row]
        content.textProperties.color = .white
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table view delegate
extension EpisodeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let characterUrl = episode?.characters[indexPath.row]
        performSegue(withIdentifier: "showCharacter", sender: characterUrl)
    }
}
