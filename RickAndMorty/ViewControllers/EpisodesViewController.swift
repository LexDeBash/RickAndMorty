//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 18.11.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class EpisodesViewController: UITableViewController {
    
    var result: Result!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.episode.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episode", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = result.episode[indexPath.row]
        content.textProperties.color = .white
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeUrl = result.episode[indexPath.row]
        performSegue(withIdentifier: "showEpisode", sender: episodeUrl)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let episodeDetailsVC = segue.destination as! EpisodeDetailsViewController
        episodeDetailsVC.episodeUrl = sender as? String
    }

}
