//
//  ConversationCell.swift
//  Firechat
//
//  Created by Wallace Santos on 01/03/23.
//

import UIKit

class ConversationCell:UITableViewCell{
    //MARK: - Properties
    
    var conversation:Conversation?{
        didSet{configureCell()}
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setDimensions(height: 32, width: 32)
        imageView.layer.cornerRadius = 32 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let timestampLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    //MARK: - Helper Functions
    
    func configure(){
        addSubview(profileImageView)
        profileImageView.centerY(inview: self, leftAnchor: leftAnchor, paddinLeft: 8)
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        let labelStack = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        labelStack.alignment = .leading
        labelStack.spacing = 4
        labelStack.axis = .vertical
        
        addSubview(labelStack)
        labelStack.centerY(inview: self)
        labelStack.anchor(left: profileImageView.rightAnchor, right: timestampLabel.leftAnchor, paddingLeft: 8, paddingRight: 8)
    }
    
    func configureCell(){
        guard let conversation = conversation else {return}
        let viewModel = ConversationViewModel(conversation: conversation)
        profileImageView.sd_setImage(with: viewModel.profileImage)
        usernameLabel.text = conversation.user.username
        messageLabel.text = conversation.message.text
        timestampLabel.text = viewModel.timestamp
    }
    
    //MARK: - Selectors
}
