//
//  NewMessageController.swift
//  Firechat
//
//  Created by Wallace Santos on 21/02/23.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate:AnyObject{
    func controller(_ controller:NewMessageController, wantsToChatWith user:User)
}

class NewMessageController:UITableViewController{
    //MARK: - Properties
    
    weak var delegate:NewMessageControllerDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    
    var users = [User]()
    var filteredUsers = [User]()
    
    private var inSearchMode : Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    //MARK: - API
    
    func fetchUsers(){
        UserService.fetchUser { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
//MARK: - Helper Functions
    
    func configureUI(){
        configureNavigationBar(withTitle: "New Message", color: .navyBlue, largeTitle: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self , action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem?.tintColor = .white
        configureTableView()
    }
    
    func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    func configureSearchController(){
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        searchController.searchResultsUpdater = self
    }
    
//MARK: - Selectors
    
    @objc func handleDismiss(){
        dismiss(animated: true)
    }
}

//MARK: - TableView Data Soruce
extension NewMessageController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        return cell
    }
}
//MARK: - TableView Delegate
extension NewMessageController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToChatWith: user)
    }
}

//MARK: - UISearchController - Results

extension NewMessageController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let seachResult = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({$0.fullname.localizedStandardContains(seachResult) || $0.username.localizedStandardContains(seachResult)})
        tableView.reloadData()
    }
    
    
}
