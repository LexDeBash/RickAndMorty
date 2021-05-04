//
//  ChracterTableViewController.swift
//  RickAndMorty
//
//  Created by Alexey Efimov on 03.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class ChracterTableViewController: UITableViewController {
    
    //MARK: Private properties
    private var rickAndMorty: RickAndMorty?
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredChracter: [Character] = []
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
        fetchData(from: URLS.rickAndMortyapi.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredChracter.count : rickAndMorty?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let character = isFiltering ? filteredChracter[indexPath.row] : rickAndMorty?.results[indexPath.row]
        cell.configure(with: character)
    
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let character = isFiltering ? filteredChracter[indexPath.row] : rickAndMorty?.results[indexPath.row]
        let detailVC = segue.destination as! CharcterDetailsViewController
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
    
    // Setup navigation bar
    private func setupNavigationBar() {
        
        title = "Rick & Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .black
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
    }
    
    private func fetchData(from url: String?) {
        NetworkManager.shared.fetchData(from: url) {  rickAndMorty in
            self.rickAndMorty = rickAndMorty
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ChracterTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredChracter = rickAndMorty?.results.filter { chracter in
            chracter.name.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}
