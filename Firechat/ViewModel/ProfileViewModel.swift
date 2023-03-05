//
//  ProfileViewModel.swift
//  Firechat
//
//  Created by Wallace Santos on 04/03/23.
//

import Foundation


enum ProfileViewModel:Int, CaseIterable{
    case accountInfo
    case settings
    
    
    var description:String{
        switch self{
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var image:String{
        switch self{
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
    
    
}
