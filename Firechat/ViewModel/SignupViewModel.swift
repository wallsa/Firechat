//
//  SignupViewModel.swift
//  Firechat
//
//  Created by Wallace Santos on 19/02/23.
//

import UIKit

struct SignupViewModel:AuthenticateUserProtocol {
    var fullname:String?
    var username:String?
    var email:String?
    var password:String?
    
    var formIsValid:Bool{
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
}
