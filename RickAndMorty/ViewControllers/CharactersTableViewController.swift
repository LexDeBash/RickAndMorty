//
//  CharactersTableViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class CharactersTableViewController: UITableViewController {
    
    //MARK: Private properties
    private var rickAndMorty: RickAndMorty?
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredCharacter: [Character] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        fetchData(from: RickAndMortyAPI.baseURL.url)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredCharacter.count : rickAndMorty?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? TableViewCell else {
            return UITableViewCell()
        }
        let character = isFiltering
        ? filteredCharacter[indexPath.row]
        : rickAndMorty?.results[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let character = isFiltering
        ? filteredCharacter[indexPath.row]
        : rickAndMorty?.results[indexPath.row]
        guard let detailVC = segue.destination as? CharacterDetailsViewController else { return }
        detailVC.character = character
    }
    
    @IBAction func updateData(_ sender: UIBarButtonItem) {
        sender.tag == 1
        ? fetchData(from: rickAndMorty?.info.next)
        : fetchData(from: rickAndMorty?.info.prev)
    }
    
    // MARK: - Private methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    private func setupNavigationBar() {
        title = "Rick & Morty"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func fetchData(from url: URL?) {
        NetworkManager.shared.fetch(RickAndMorty.self, from: url) { [weak self] result in
            switch result {
            case .success(let rickAndMorty):
                self?.rickAndMorty = rickAndMorty
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCharacter = rickAndMorty?.results.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}
