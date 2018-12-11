//
//  UserSearchController.swift
//  Instagram
//
//  Created by OuSS on 12/11/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import UIKit

class UserSearchController: UITableViewController {
    
    let cellId = "cellId"
    
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        
        tableView.register(UserSearchCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserSearchCell
        return cell
    }
}

extension UserSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
