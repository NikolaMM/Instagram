//
//  DateExtension.swift
//  InstagramFireBase
//
//  Created by Nikola Milenkovic on 6/22/17.
//  Copyright © 2017 Nikola Milenkovic. All rights reserved.
//

import Foundation


extension Date {
    
    func timeAgoDisplay() -> String {
        
        let secounds = Int(Date().timeIntervalSince(self))
        
        let minutes = 60
        let houres = 60 * minutes
        let days = 24 * houres
        let weeks = 7 * days
        let monthes = 30 * days
        let years = 365 * days
        
        
        let broj : Int
        let jedinica : String
        
        if secounds < minutes {
            
            broj = secounds
            jedinica = "secound"
            
            
        } else if secounds < houres {
            
            broj = secounds / minutes
            jedinica = "minut"
            
        } else if secounds < days {
            
            broj = secounds / houres
            jedinica = "houre"
            
        } else if secounds < weeks {
            
            broj = secounds / days
            jedinica = "day"
            
        } else if secounds < monthes {
            
            broj = secounds / weeks
            jedinica = "week"
            
            
        } else if secounds < years {
            
            broj = secounds / monthes
            jedinica = "monthe"
            
            
        } else {
            
            broj = secounds / years
            jedinica = "year"
        }
        
        
        
        return ("\(broj) \(jedinica)\( broj > 1 ? "s ago" : " ago")")
    }
    
}
