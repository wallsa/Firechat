//
//  ConversationController.swift
//  Firechat
//
//  Created by Wallace Santos on 22/02/23.
//

import UIKit

private let reuseIdentifier = "ChatCell"

class SingleChatController:UICollectionViewController{
    
    //MARK: - Properties
    
    private let user : User
    private var messages = [Message]()
    
    var isFromCurrentUser:Bool = false
    
    private lazy var customInputView : CustonInputView = {
        let custonView = CustonInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        custonView.delegate = self
        return custonView
    }()
    
    //MARK: - Lifecycle
    
    init(user:User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar(withTitle: user.username, color: .navyBlue, largeTitle: false)
    }
    
    override var inputAccessoryView: UIView?{
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: - API
    
    //MARK: - Helper Functions
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.alwaysBounceVertical = true
    }
    
    //MARK: - Selectors
}

//MARK: - CollectionView DataSource

extension SingleChatController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    
    }
}
//MARK: - CollectionViewCell Custon Sizes
extension SingleChatController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}

//MARK: - CustonInputView Delegate

extension SingleChatController:CustonInputViewDelegate{
    func handleSendMessage(_ text: String) {
        isFromCurrentUser.toggle()
        let newMessage = Message(text: text, isFromCurrentUser: isFromCurrentUser)
        messages.append(newMessage)
        collectionView.reloadData()
    }
    
    
}
