//
//  Message.swift
//  Firechat
//
//  Created by Wallace Santos on 27/02/23.
//

import Foundation
import Firebase

struct Message{
    let text:String
    let toID:String
    let fromID:String
    let timestamp:Timestamp!
    
    var user:User?
    
    var isFromCurrentUser:Bool{
        return Auth.auth().currentUser?.uid == fromID ? true : false
    }
    
    var chatPartnerID:String{
        return Auth.auth().currentUser?.uid == fromID ? toID : fromID
    }
    
    init(dictionary:[String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
