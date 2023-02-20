//
//  Constants.swift
//  Firechat
//
//  Created by Wallace Santos on 16/02/23.
//

import Foundation
import Firebase

//MARK: - Database References

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DATA_REF = Firestore.firestore()
let REF_USERS = DATA_REF.collection("users")


//MARK: - Images
struct Constants {
    static let personImage = "person.circle.fill"
    static let messageBaloon = "message"
    static let envelope = "envelope"
    static let lock = "lock"
    static let eye = "eye.fill"
    static let person = "person"
    static let personAdd = "plus.circle"
    
}
