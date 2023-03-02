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
    let custonViewHeight = CGFloat(integerLiteral: 50)
    
    private lazy var customInputView : CustonInputView = {
        let custonView = CustonInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: custonViewHeight))
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
        fetchMessages()
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
    
    func fetchMessages(){
        MessageService.fetchMessages(forUser: user) { messages in
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    //MARK: - Helper Functions
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        //Fecha o teclado com a interação do usuario, e abaixo definimos um inset para a collection, 16px a mais do que a custonView
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset.bottom = custonViewHeight + 16
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
        cell.message?.user = user
        return cell
    
    }
}
//MARK: - CollectionViewCell Custon Sizes
extension SingleChatController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimateSizeForCell = MessageCell(frame: frame)
        
        estimateSizeForCell.message = messages[indexPath.row]
        estimateSizeForCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 10000)
        let estimateSize = estimateSizeForCell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: view.frame.width, height: estimateSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}

//MARK: - CustonInputView Delegate

extension SingleChatController:CustonInputViewDelegate{
    func handleSendMessage(_ inputView: CustonInputView, _ text: String) {
        inputView.clearInput()
        MessageService.uploadMessage(text, to: user) { error in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
        }
    }  
}
