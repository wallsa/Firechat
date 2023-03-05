//
//  ProfileFooterView.swift
//  Firechat
//
//  Created by Wallace Santos on 04/03/23.
//

import UIKit

protocol ProfileFooterDelegate:AnyObject{
    func handleLoggout()
}

class ProfileFooterView:UIView{
    //MARK: - Properties
    
    weak var delegate:ProfileFooterDelegate?
    
    private let loggoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loggout", for: .normal)
        button.backgroundColor = .navyBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.addTarget(self , action: #selector(handleLoggout), for: .touchUpInside)
        return button
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
        addSubview(loggoutButton)
        loggoutButton.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, height: 60)
    }
    
    //MARK: - Selectors
    
    @objc func handleLoggout(){
        delegate?.handleLoggout()
    }
}
