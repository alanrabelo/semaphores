//
//  Client.swift
//  Teste de Semáforos
//
//  Created by Alan Rabelo Martins on 03/08/16.
//  Copyright © 2016 Alan Rabelo Martins. All rights reserved.
//

import Foundation

class Client: NSObject {
    let name: String
    let number: Int
    let necessaryTime: NSTimeInterval
    
    init(name: String, number: Int, necessaryTime: NSTimeInterval) {
        self.name = name
        self.number = number
        self.necessaryTime = necessaryTime
    }
    
    func beServed() {
        let initialDate = NSDate()
        var actualDate = NSDate()
        
        
        let finishDate = initialDate.dateByAddingTimeInterval(self.necessaryTime)
        while actualDate.compare(finishDate) == NSComparisonResult.OrderedAscending {
            actualDate = NSDate()
        }
        
    }


}
