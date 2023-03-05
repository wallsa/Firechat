//
//  ProfileHeaderView.swift
//  Firechat
//
//  Created by Wallace Santos on 02/03/23.
//

import UIKit

protocol ProfileHeaderDelegate:AnyObject{
    func dismissController()
}

class ProfileHeaderView:UIView{
    //MARK: - Properties
    
    private let user:User
    private let gradient = CAGradientLayer()
    
    weak var delegate:ProfileHeaderDelegate?
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: 180, width: 180)
        imageView.layer.cornerRadius = 180 / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.setDimensions(height: 48, width: 48)
        button.addTarget(self , action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(user:User,frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        configure()
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }

    //MARK: - Helper Functions
    
    fileprivate func configureFade() {
        gradient.colors = [UIColor.mainPurple.cgColor, UIColor.navyBlue.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    func configure(){
        configureFade()
        
        addSubview(profileImageView)
        profileImageView.centerX(inview: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let nameStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 8
        nameStack.alignment = .center
        
        addSubview(nameStack)
        nameStack.centerX(inview: self)
        nameStack.anchor(top: profileImageView.bottomAnchor,paddingTop: 16)
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        
        profileImageView.sd_setImage(with: user.profileImageURL)
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@\(user.username)"
        
    }
    
//MARK: - Selectors
    @objc func handleBack(){
        delegate?.dismissController()
    }
}
