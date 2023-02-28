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
}
