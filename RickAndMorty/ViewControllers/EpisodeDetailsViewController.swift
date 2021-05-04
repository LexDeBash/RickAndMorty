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
    
    var episode: Episode!
    private var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getCharacters()
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        title = episode.episode
        episodeDescriptionLabel.text = episode.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! CharcterDetailsViewController
        detailsVC.character = sender as? Character
    }
    
    private func getCharacters() {
        for characterURL in episode.characters {
            NetworkManager.shared.fetchCharacter(from: characterURL) { character in
                self.characters.append(character)
            }
        }
    }
}

// MARK: - Table view data sourse
extension EpisodeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let characterURL = episode.characters[indexPath.row]
        NetworkManager.shared.fetchCharacter(from: characterURL) { character in
            cell.configure(with: character)
        }
        return cell
    }
}

// MARK: - Table view delegate
extension EpisodeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        performSegue(withIdentifier: "showCharacter", sender: character)
    }
}
