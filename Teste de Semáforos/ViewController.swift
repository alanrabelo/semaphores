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
    let mutex = dispatch_semaphore_create(1)
    var waiting = 0
    var clientesCount = 0
    var clientes = [Client]()
    var cashiers = [Cashier]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createCahiers(1)
        
    }

    
    func loop(timeInterval: NSTimeInterval) {
        let initialDate = NSDate()
        var actualDate = NSDate()
        
        
        let finishDate = initialDate.dateByAddingTimeInterval(timeInterval)
            while actualDate.compare(finishDate) == NSComparisonResult.OrderedAscending {
                actualDate = NSDate()
            }
    }
    
    @IBAction func createANewCustomer(sender: AnyObject) {
        loop(1)
        clientesCount += 1
        
        let customerGettinHairCut = NSThread(target: self, selector: #selector(self.customer), object: nil)
        customerGettinHairCut.start()
    }
   
    
    func createCahiers(quant: Int) {
        
        
        for i in 0...quant {
            
            let barber = NSThread(target: self, selector: #selector(self.barber), object: nil)
            barber.name = "(\(i+1)) barberThread"
            barber.start()
            
            let cashier = Cashier(name: i, number: i)
            cashier.currentThread = barber
            
            cashiers.append(cashier)
            
            
        }
        
        
        
        
    }
    
    
    
    func barber(){
        
        while true {
            
            if clientes.count == 0 {
                print("Caixa esperando consumidores\n")
            }
            
            dispatch_semaphore_wait(customersSemaphore, tempo)
            dispatch_semaphore_wait(mutex, tempo)
            
            for cashier in cashiers {
                
                if cashier.client == nil && clientes.count > 0 {
                    cashier.client = clientes.first
                    clientes.removeFirst()
                }
                
            }
            
            dispatch_semaphore_signal(barberSemaphore)
            dispatch_semaphore_signal(mutex)
            cutHair()
        }
        
    }
    
    func customer() {
        
        dispatch_semaphore_wait(mutex, tempo)
        
        if clientes.count < 5 {
            
            customerArrived()
            
            let cliente = Client(name: "cliente", number: clientesCount)
            self.clientes.append(cliente)
            
            print("Mais um consumidor! Total de \(self.clientes.count) consumidores esperando")
            dispatch_semaphore_signal(customersSemaphore)
            dispatch_semaphore_signal(mutex)
            dispatch_semaphore_wait(barberSemaphore, tempo)
            getHairCut()
            
        } else {
            
            dispatch_semaphore_signal(mutex)
            giveUpHaircut()
            
        }
        
    }
    
    
    func searchClient(client: Client) {
        for cashier in cashiers {
            if cashier.client!.isEqual(client) {
                cashier.client = nil
            }
        }
    }
    
    func cutHair() {
        print("\nBarbeiro \(NSThread.currentThread().name!) está cortando cabelo\n")
        
        loop(8)
        
        return
    }
    
    func customerArrived () {
        print("Cliente chegou pra cortar o cabelo")
    }
    
    func getHairCut () {
        print("Algum cliente está cortando o cabelo")
        loop(8)
        return
    }
    
    func giveUpHaircut () {
        print("Cliente Desistiu")
    }

    
}

