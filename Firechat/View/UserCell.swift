//
//  UserCell.swift
//  Firechat
//
//  Created by Wallace Santos on 21/02/23.
//

import UIKit
import SDWebImage

class UserCell:UITableViewCell{
    //MARK: - Properties
    
    var user:User?{
        didSet{configure()}
    }
    
    private let userImage : UIImageView = {
        let image = UIImageView()
        image.setDimensions(height: 40, width: 40)
        image.layer.cornerRadius = 40 / 2
        image.clipsToBounds = true
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Functions
    
    func configure(){
        guard let user = user else {return}
        userImage.sd_setImage(with: user.profileImageURL)
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
    
    func configureConstrains(){
        addSubview(userImage)
        userImage.centerY(inview: self)
        userImage.anchor(left: leftAnchor, paddingLeft: 8)
        
        let nameStack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        nameStack.axis = .vertical
        nameStack.distribution = .fillEqually
        nameStack.spacing = 4
        
        addSubview(nameStack)
        nameStack.centerY(inview: self)
        nameStack.anchor(left: userImage.rightAnchor, right: rightAnchor, paddingLeft: 8)
        
    }
    
    //MARK: - Selectors
}
