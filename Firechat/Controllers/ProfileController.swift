//
//  ProfileController.swift
//  Firechat
//
//  Created by Wallace Santos on 02/03/23.
//

import UIKit

protocol ProfileControllerDelegate:AnyObject{
    func handleLoggout(_ controller:ProfileController)
}

private let reuseIdentifier = "ProfileSettingsCell"

class ProfileController:UITableViewController{
    
//MARK: - Properties
    
    private var user : User
    
    weak var delegate:ProfileControllerDelegate?
    
    
    private lazy var profileHeader : ProfileHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 380)
        let view = ProfileHeaderView(user: user, frame: frame)
        view.delegate = self
        return view
    }()
    
    private lazy var profileFooter : ProfileFooterView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let view = ProfileFooterView(frame: frame)
        view.delegate = self
        return view
    }()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(withTitle: "\(user.fullname) Profile", color: .navyBlue, largeTitle: false)
        configureTableView()
    }
    
    init(user: User) {
        self.user = user
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configureTableView(){
        tableView.backgroundColor = .systemGroupedBackground
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = profileHeader
        tableView.tableFooterView = profileFooter
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
}
//MARK: - TableView DataSource
extension ProfileController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else {return UITableViewCell()}
        content.text = viewModel.description
        content.image = UIImage(systemName: viewModel.image)
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - TableView Delegate

extension ProfileController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let option = ProfileViewModel(rawValue: indexPath.row) else {return}
        
        switch option {
        case .accountInfo:print("DEBUG: ACCOUNT INFO")
            
        case .settings: print("DEBUG: SETTINGS")
    
        }
    }
}

//MARK: - TableView UI Elements

extension ProfileController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - HeaderView Delegate

extension ProfileController:ProfileHeaderDelegate{
    func dismissController() {
        dismiss(animated: true)
    }
}

//MARK: - FooterView Delegate

extension ProfileController:ProfileFooterDelegate{
    func handleLoggout() {
        let loggoutAlert = UIAlertController().createLogoutAlert { _ in
            self.delegate?.handleLoggout(self)
        }
        present(loggoutAlert, animated: true)
    }
    
    
}
