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
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type username here to search"
        search.searchResultsUpdater = self
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserSearchCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        
        setupNavigationBar()
        fetchUsers()
        
    }
    
    func setupNavigationBar() {
        definesPresentationContext = true
        navigationItem.title = "Users"
        navigationItem.searchController = search
    }
    
    func fetchUsers() {
        UserService.instance.fetchUsers { (users) in
            self.users = users
            self.filteredUsers = users
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let userProfile = UserProfileController(collectionViewLayout: layout)
        userProfile.user = user
        navigationController?.pushViewController(userProfile, animated: true)
    }
}

extension UserSearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter{$0.username.lowercased().contains(text.lowercased())}
        }
        
        tableView.reloadData()
    }
}
