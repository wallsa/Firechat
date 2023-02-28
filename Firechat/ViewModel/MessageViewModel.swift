//
//  MessageViewModel.swift
//  Firechat
//
//  Created by Wallace Santos on 27/02/23.
//

import UIKit

struct MessageViewModel {
    
    private let message:Message
    
    init(message: Message) {
        self.message = message
    }
    
    var messageBackGround:UIColor{
        return message.isFromCurrentUser ? .systemGroupedBackground : .mainPurple
    }
    
    var messageTextColor:UIColor{
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive:Bool{
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive:Bool{
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage:Bool{
        return message.isFromCurrentUser
    }
}
