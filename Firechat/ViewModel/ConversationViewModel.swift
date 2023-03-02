//
//  File.swift
//  Firechat
//
//  Created by Wallace Santos on 02/03/23.
//

import Foundation


struct ConversationViewModel {
    private let conversation:Conversation
    
    var profileImage:URL?{
        return conversation.user.profileImageURL
    }
    
    var timestamp:String{
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
  
}
