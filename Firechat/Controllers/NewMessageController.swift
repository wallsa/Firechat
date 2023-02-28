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
    
    var users : [User]?{
        didSet{tableView.reloadData()}
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchUsers()
    }
    //MARK: - API
    
    func fetchUsers(){
        UserService.fetchUser { users in
            self.users = users
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
    
//MARK: - Selectors
    
    @objc func handleDismiss(){
        dismiss(animated: true)
    }
}

//MARK: - TableView Data Soruce
extension NewMessageController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users?[indexPath.row]
        return cell
    }
}
//MARK: - TableView Delegate
extension NewMessageController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row] else {return}
        delegate?.controller(self, wantsToChatWith: user)
    }
}
