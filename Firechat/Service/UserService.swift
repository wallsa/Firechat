//
//  UserService.swift
//  Firechat
//
//  Created by Wallace Santos on 21/02/23.
//

import Firebase


class UserService{
    
    
    static func fetchUser(completion:@escaping ([User]) -> ()){
        REF_USERS.getDocuments { snapshot , error in
            if let error = error {
                print("DEBUG: Error fetching database")
            }
            guard var users = snapshot?.documents.map({User(dataDictionary: $0.data())}) else {return}
            if let i = users.firstIndex(where: {$0.uid == Auth.auth().currentUser?.uid}){
                users.remove(at: i)
            }
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
