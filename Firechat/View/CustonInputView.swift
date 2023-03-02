//
//  CustonInputView.swift
//  Firechat
//
//  Created by Wallace Santos on 22/02/23.
//

import UIKit

protocol CustonInputViewDelegate:AnyObject{
    func handleSendMessage(_ inputView:CustonInputView,_ text:String)
}

class CustonInputView:UIView{
//MARK: - Properties
    
    weak var delegate:CustonInputViewDelegate?
    
    private let inputMessageText : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.navyBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Enter Message"
        return label
    }()

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
//MARK: - API

//MARK: - Helper Functions
    
    func configure(){
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8, width: 50, height: 50)
        
        addSubview(inputMessageText)
        inputMessageText.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor,                               paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inview: inputMessageText, leftAnchor: inputMessageText.leftAnchor, paddinLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleHidePlaceholder), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    func clearInput(){
        inputMessageText.text = nil
        placeholderLabel.isHidden = false
    }
//MARK: - Selectors
    
    @objc func handleSendMessage(){
        guard !inputMessageText.text.isEmpty else {return}
        delegate?.handleSendMessage(self, inputMessageText.text)
    }
    
    @objc func handleHidePlaceholder(){
        placeholderLabel.isHidden = !inputMessageText.text.isEmpty
        
    }
}
