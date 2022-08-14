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
    
    private var characters: [Character] = [] {
        didSet {
            if characters.count == episode.characters.count {
                characters = characters.sorted { $0.id < $1.id }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCharacters()
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
        guard let detailsVC = segue.destination as? CharacterDetailsViewController else { return }
        detailsVC.character = sender as? Character
    }
    
    private func setCharacters() {
        episode.characters.forEach { characterURL in
            NetworkManager.shared.fetch(Character.self, from: characterURL) { [weak self] result in
                switch result {
                case .success(let character):
                    self?.characters.append(character)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Table view data source
extension EpisodeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let characterURL = episode.characters[indexPath.row]
        NetworkManager.shared.fetch(Character.self, from: characterURL) { result in
            switch result {
            case .success(let character):
                cell.configure(with: character)
            case .failure(let error):
                print(error)
            }
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
