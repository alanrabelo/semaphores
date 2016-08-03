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
    
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
    
    func beServed(timeInterval: NSTimeInterval) {
        let initialDate = NSDate()
        var actualDate = NSDate()
        
        
        let finishDate = initialDate.dateByAddingTimeInterval(timeInterval)
        while actualDate.compare(finishDate) == NSComparisonResult.OrderedAscending {
            actualDate = NSDate()
        }
        
    }


}
