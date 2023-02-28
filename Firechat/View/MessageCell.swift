//
//  MessageCell.swift
//  Firechat
//
//  Created by Wallace Santos on 22/02/23.
//

import UIKit

class MessageCell:UICollectionViewCell{
    
//MARK: - Properties
    
    var message:Message?{
        didSet{configureMessage()}
    }
    
    var bubbleLeftAnchor:NSLayoutConstraint!
    var bubbleRightAnchor:NSLayoutConstraint!
 
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .mainPurple
        imageView.setDimensions(height: 32, width: 32)
        imageView.layer.cornerRadius = 32 / 2
        return imageView
    }()
    
    private let textView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        textView.text = "Testando uma frase muito longa para ver como a constrain se comporta"
        return textView
    }()
    
    private let bubbleContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .mainPurple
        view.layer.cornerRadius = 12
        return view
    }()

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configure(){
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        
        addSubview(bubbleContainer)
        bubbleContainer.anchor(top: topAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        /*Aqui implementamos para view que forma a bolha do chat a constrain da esquerda e direita e abaixo na configuracao da celula,
         definimos com a ajuda da nossa viewModel qual constrain vai ser ativada */
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleLeftAnchor.isActive = false
        bubbleRightAnchor.isActive = false
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    func configureMessage(){
        guard let message = message else {return}
        let viewModel = MessageViewModel(message: message)
        bubbleContainer.backgroundColor = viewModel.messageBackGround
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
    }

//MARK: - Selectors
}
