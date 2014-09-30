//
//  ColorPalette.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation

enum ColorPalette {
    case Blue, Gray, Green, Yellow, White
    
    func get(alpha: CGFloat = 1.0) -> UIColor {
        
        switch self {
        case .Blue:
            return UIColor(red: 115/255, green: 169/255, blue: 238/255, alpha: alpha)
        case .Gray:
            return UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: alpha)
        case .Green:
            return UIColor(red: 142/255, green: 182/255, blue: 124/255, alpha: alpha)
        case .Yellow:
            return UIColor(red: 253/255, green: 177/255, blue: 59/255, alpha: alpha)
        case .White:
            return UIColor.whiteColor()
        }
    }
}