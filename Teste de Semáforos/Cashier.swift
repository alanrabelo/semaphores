//
//  Cashier.swift
//  Teste de Semáforos
//
//  Created by Alan Rabelo Martins on 03/08/16.
//  Copyright © 2016 Alan Rabelo Martins. All rights reserved.
//

import Foundation

class Cashier: NSObject {
    let name: Int
    let number: Int
    var client: Client?
    var currentThread: NSThread?
    
    init(name: Int, number: Int) {
        self.name = name
        self.number = number
    }
    
    func serveClient(timeInterval: NSTimeInterval) {
        let initialDate = NSDate()
        var actualDate = NSDate()
        
        
        let finishDate = initialDate.dateByAddingTimeInterval(timeInterval)
        while actualDate.compare(finishDate) == NSComparisonResult.OrderedAscending {
            actualDate = NSDate()
        }

    }
    
    
    
}
