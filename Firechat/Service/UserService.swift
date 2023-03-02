//
//  UserService.swift
//  Firechat
//
//  Created by Wallace Santos on 21/02/23.
//

import Firebase


class UserService{
    
    
    static func fetchUser(completion:@escaping ([User]) -> ()){
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot , error in
            if let error = error {
                print("DEBUG: Error fetching database")
            }
            snapshot?.documents.forEach({ document in
                let values = document.data()
                let user = User(dataDictionary: values)
                users.append(user)
            })
            completion(users)
        }
    }
    
    static func fetchUser(withUid uid:String, completion:@escaping (User) -> ()){
        REF_USERS.document(uid).getDocument { snapshot , error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dataDictionary: dictionary)
            completion(user)
        }
    }
}
