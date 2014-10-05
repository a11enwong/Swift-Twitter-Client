//
//  AppNotifications.swift
//  Twitter
//
//  Created by Hector Monserrate on 05/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation

enum AppNotifications {
    case StatusCreated, StatusUpdated
    
    func get() -> String {
        
        switch self {
        case .StatusCreated:
            return "StatusCreated"
        case .StatusUpdated:
            return "StatusUpdated"
        }
    }
}