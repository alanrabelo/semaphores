//
//  ViewController.swift
//  Teste de Semáforos
//
//  Created by Alan Rabelo Martins on 7/26/16.
//  Copyright © 2016 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //DECLARANDO SEMÁFOROS
    let tempo = DISPATCH_TIME_FOREVER
    let customersSemaphore = dispatch_semaphore_create(0)
    let barberSemaphore = dispatch_semaphore_create(0)
    let mutex = dispatch_semaphore_create(5)
    var waiting = 0
    
    func loop(timeInterval: NSTimeInterval) {
        let initialDate = NSDate()
        var actualDate = NSDate()
        
        
        let finishDate = initialDate.dateByAddingTimeInterval(timeInterval)
            while actualDate.compare(finishDate) == NSComparisonResult.OrderedAscending {
                actualDate = NSDate()
            }
    }
    
    func createBarber() {
        self.barber()
    }
    
    func createCustomer() {
        while true {
            loop(10)
            let customerGettinHairCut = NSThread(target: self, selector: #selector(self.customer), object: nil)
            customerGettinHairCut.start()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let barber = NSThread(target: self, selector: #selector(createBarber), object: nil)
        barber.name = "barberThread"
        barber.start()
        
        let customer = NSThread(target: self, selector: #selector(createCustomer), object: nil)
        customer.start()
        
       
        
        
        
        
        
    }
    
    
    func barber(){
        
        while true {
            
            if waiting == 0 {
                print("Barber esperando consumidores\n")
            }
            
            dispatch_semaphore_wait(customersSemaphore, tempo)
            
            dispatch_semaphore_wait(mutex, tempo)
            
            waiting -= 1
            dispatch_semaphore_signal(barberSemaphore)
            dispatch_semaphore_signal(mutex)
            cutHair()
        }
        
    }
    
    func customer() {
        
        dispatch_semaphore_wait(mutex, tempo)
        
        if waiting < 5 {
            //            customerArrived()
            waiting += 1
            print("Mais um consumidor! Total de \(waiting) consumidores esperando")
            dispatch_semaphore_signal(customersSemaphore)
            dispatch_semaphore_signal(mutex)
            dispatch_semaphore_wait(barberSemaphore, tempo)
            getHairCut()
        } else {
            dispatch_semaphore_signal(mutex)
            giveUpHaircut()
        }
    }
    
    
    func cutHair() {
        print("Barbeiro está cortando cabelo")
        loop(3)
        return
    }
    
    func customerArrived () {
        print("Cliente chegou pra cortar o cabelo")
    }
    
    func getHairCut () {
        print("Algum cliente está cortando o cabelo")
        loop(3)
        return
    }
    
    func giveUpHaircut () {
        print("Cliente Desistiu")
    }
    
    
    
    
}

