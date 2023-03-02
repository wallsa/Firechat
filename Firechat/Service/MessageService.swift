//
//  MessageService.swift
//  Firechat
//
//  Created by Wallace Santos on 27/02/23.
//

import Foundation
import Firebase

struct MessageService{
//addDocument - Adiciona o dictionary naquele nó da database
//setData - Sobreescreve oa dados que estão naquele nó da database
    static func uploadMessage(_ message:String, to user:User, completion:((Error?) -> ())?){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let values = ["text" : message, "fromID" : currentUID, "toID" : user.uid, "timestamp" : Timestamp(date: Date())] as [String:Any]
        REF_MESSAGES.document(currentUID).collection(user.uid).addDocument(data: values) { _ in
            REF_MESSAGES.document(user.uid).collection(currentUID).addDocument(data: values, completion: completion)
            REF_MESSAGES.document(currentUID).collection("recent-messages").document(user.uid).setData(values)
            REF_MESSAGES.document(user.uid).collection("recent-messages").document(currentUID).setData(values)
        }
    }
    
    static func fetchMessages(forUser user:User, completion:@escaping(([Message]) -> Void)){
        var messages = [Message]()
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let query = REF_MESSAGES.document(currentUser).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { snapshot , error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added{
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchConversations(completion:@escaping([Conversation]) -> ()){
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = REF_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot , error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                UserService.fetchUser(withUid: message.toID) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
}
