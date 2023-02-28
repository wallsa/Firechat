//
//  ChatController.swift
//  Firechat
//
//  Created by Wallace Santos on 16/02/23.
//

import UIKit
import Firebase

private let reuseIdentifier = "ChatCell"

class MultipleChatsController:UIViewController{
//MARK: - Properties
    
    private let tableView = UITableView()
    
    private let newMessageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.plus), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .navyBlue
        button.addTarget(self , action: #selector(handleNewMessage), for: .touchUpInside)
        return button
    }()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUser()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar(withTitle: "Messages", color: .navyBlue, largeTitle: true)
    }

//MARK: - API
    
    func checkUser(){
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User not connected, show loginCOntroller")
            presentLoginScreen()
        } else {
            print("DEBUG: Configure UI for user\(Auth.auth().currentUser?.uid)")
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("DEBUG: error signing Out..")
        }
        presentLoginScreen()
    }

//MARK: - Helper Functions
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        configureNavigationBar(withTitle: "Messages", color: .navyBlue, largeTitle: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.personImage), style: .plain, target: self, action: #selector(showProfile))
        navigationItem.leftBarButtonItem?.tintColor = .white
        configureTableView()
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 16, paddingRight: 12, width: 60, height: 60)
        newMessageButton.layer.cornerRadius = 60 / 2
        
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
        logout()
    }
    
    @objc func handleNewMessage(){
        print("DEBUG: New Message Controller")
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
//MARK: - TableView DataSource

extension MultipleChatsController:UITableViewDataSource{
    
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

extension MultipleChatsController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - NewMessageController Delegate

extension MultipleChatsController:NewMessageControllerDelegate{
    func controller(_ controller: NewMessageController, wantsToChatWith user: User) {
        controller.dismiss(animated: true)
        let conversation = SingleChatController(user: user)
        navigationController?.pushViewController(conversation, animated: true)
    }
    
    
}
