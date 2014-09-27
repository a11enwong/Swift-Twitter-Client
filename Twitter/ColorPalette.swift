//
//  ColorPalette.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation

enum ColorPalette {
    case Blue, White
    
    func get(alpha: CGFloat = 1.0) -> UIColor {
        
        switch self {
        case .Blue:
            return UIColor(red: 115/255, green: 169/255, blue: 238/255, alpha: alpha)
        case .White:
            return UIColor.whiteColor()
        }
    }
}