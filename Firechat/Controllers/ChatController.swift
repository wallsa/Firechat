//
//  ChatController.swift
//  Firechat
//
//  Created by Wallace Santos on 16/02/23.
//

import UIKit

private let reuseIdentifier = "ChatCell"

class ChatController:UIViewController{
//MARK: - Properties
    
    private let tableView = UITableView()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        
    }

//MARK: - API

//MARK: - Helper Functions
    
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        configureNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.personImage), style: .plain, target: self, action: #selector(showProfile))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func configureNavigationBar(){
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navyBlue
        
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

//MARK: - Selectors
    
    @objc func showProfile(){
        print("DEBUG: Show profile")
    }
}
//MARK: - TableView DataSource

extension ChatController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Test Cell"
        cell.contentConfiguration = content
        return cell
    }
}
//MARK: - TableView Delegate

extension ChatController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
