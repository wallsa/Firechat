//
//  LoginViewModel.swift
//  Firechat
//
//  Created by Wallace Santos on 19/02/23.
//

import UIKit

protocol AuthenticateUserProtocol{
    var formIsValid:Bool {get}
}

struct LoginViewModel:AuthenticateUserProtocol {
    var email:String?
    var password:String?
    
    var formIsValid:Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
