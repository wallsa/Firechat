//
//  ColorExtension.swift
//  Firechat
//
//  Created by Wallace Santos on 16/02/23.
//


import UIKit

extension UIColor{
    
    static func rgb(red: CGFloat, green : CGFloat, blue:CGFloat) -> UIColor{
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let navyBlue = UIColor.rgb(red: 15, green: 98, blue: 146)
    static let mainPurple = UIColor.rgb(red: 57, green: 48, blue: 83)
   
}
