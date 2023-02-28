//
//  User.swift
//  Firechat
//
//  Created by Wallace Santos on 21/02/23.
//

import Foundation


struct User{
    let email:String
    let fullname:String
    let username:String
    var profileImageURL:URL?
    let uid:String
    
    init(dataDictionary:[String:Any]){
        self.uid = dataDictionary["uid"] as? String ?? ""
        self.fullname = dataDictionary["fullname"] as? String ?? ""
        self.username = dataDictionary["username"] as? String ?? ""
        self.email = dataDictionary["email"] as? String ?? ""
        
        
        if let urlString = dataDictionary["profileImageUrl"] as? String {
            if let url = URL(string: urlString){
                self.profileImageURL = url
            }
        }
    }
    
}
