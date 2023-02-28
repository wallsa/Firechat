//
//  AuthService.swift
//  Firechat
//
//  Created by Wallace Santos on 20/02/23.
//

import UIKit
import Firebase

struct AuthCredentials{
    let email:String
    let fullname:String
    let username:String
    let password:String
    let profileImage:UIImage
}

class AuthService{
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email:String, password:String, authCompletion:@escaping (AuthDataResult?, Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password, completion: authCompletion)
    }
    
    
    func registerUser(withCredentials credentials:AuthCredentials, databaseCompletion:@escaping (Error?) -> (), authCompletion:@escaping (Error?) -> ()){
        let email = credentials.email
        let fullname = credentials.fullname
        let password = credentials.password
        let username = credentials.username
        let profileImage = credentials.profileImage
        //Salvando a nossa imagem no storage da Firebase e dentro do clousure, temos acesso ao URL da imagem, dado que salvamos em nossa database
        let fileName = NSUUID().uuidString
        let imageStorageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { result , error in
            if let error = error{
                authCompletion(error)
                return
        }
            
        imageStorageRef.putData(imageData, metadata: nil) { meta , error  in
            imageStorageRef.downloadURL { url , error in
                guard let profileImageUrl = url?.absoluteString else {return}
                    
                    guard let uid = result?.user.uid else {return}
                    let values = ["email" : email, "username" : username, "fullname" : fullname, "uid" : uid, "profileImageUrl" : profileImageUrl] as [String:Any]
                    
                    
                    REF_USERS.document(uid).setData(values, completion: databaseCompletion)
                    }
                }
            }
        }
    
}
