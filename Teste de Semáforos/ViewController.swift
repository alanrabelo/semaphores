//
//  ViewController.swift
//  Teste de Semáforos
//
//  Created by Alan Rabelo Martins on 7/26/16.
//  Copyright © 2016 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    //DECLARANDO SEMÁFOROS
    let tempo = DISPATCH_TIME_FOREVER
    let customersSemaphore = dispatch_semaphore_create(0)
    let barberSemaphore = dispatch_semaphore_create(0)
    let mutex = dispatch_semaphore_create(1)
    var waiting = 0
    var clientesCount = 0
    var numberOfCashiers : Int?
    var clientes = [Client]()
    var cashiers = [Cashier]()
    
    override func viewDidLoad() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        super.viewDidLoad()
        createCahiers(numberOfCashiers!)
        configureFilaDeClientes()
        
    }
    
    
    //FUNCTION TO GENERATE A LOOP DEFINED BY A TIME INTERVAL IN SECONDS
    
    func loop(timeInterval: NSTimeInterval) {
        
        let initialDate = NSDate()
        var actualDate = NSDate()
        
        let finishDate = initialDate.dateByAddingTimeInterval(timeInterval)
        while actualDate.compare(finishDate) == NSComparisonResult.OrderedAscending {
            actualDate = NSDate()
        }
        
    }
    
    @IBAction func createANewCustomer(sender: AnyObject) {
        
        // DELAY OF 1 SECOND
        loop(1)
        
        //CREATING THE THREAD OF THE CLIENTS GENERATOR
        let customerGettinHairCut = NSThread(target: self, selector: #selector(self.customer), object: nil)
        customerGettinHairCut.start()
        
    }
    
    
    func createCahiers(quant: Int) {
        
        // This method creates the cashiers according to the amount selected in "Quant"
        
        
        for i in 0..<quant {
            
            //Inside the for loop a new thread is created for every barber and is named i BarberThread
            
            let barber = NSThread(target: self, selector: #selector(self.barber), object: nil)
            barber.name = "(\(i+1)) barberThread"
            barber.start()
            
            //And the current thread is now an cashier attibute and the whole object goes to the cashiers array
            let cashier = Cashier(name: i, number: i)
            cashier.currentThread = barber
            cashiers.append(cashier)
            
        }
        
    }
    
    
    
    func barber(){
        
        // This function constantly verifies for new customers and dispatch all semaphores for the barber
        
        while true {
            
            if clientes.count == 0 {
                print("Caixa esperando consumidores\n")
            }
            
            // If customers are not set, all threads sleep at this semaphore
            dispatch_semaphore_wait(customersSemaphore, tempo)
            dispatch_semaphore_wait(mutex, tempo)
            
            for cashier in cashiers {
                // Verifying if there is one cashier without client, and add as a client for it
                if cashier.client == nil && clientes.count > 0 {
                    cashier.client = clientes.first
                    clientes.removeFirst()
                }
            }
            
            dispatch_semaphore_signal(barberSemaphore)
            dispatch_semaphore_signal(mutex)
            
            for cashier in self.cashiers {
                if NSThread.currentThread() .isEqual(cashier.currentThread) {
                    cashier.serveClient()
                }
            }
            
        }
        
    }
    
    func customer(timeInterval: NSTimeInterval) {
        
        dispatch_semaphore_wait(mutex, tempo)
        
        if clientes.count < 5 {
            
            customerArrived()
            
            let cliente = Client(name: "cliente", number: clientesCount, necessaryTime: timeInterval)
            self.clientes.append(cliente)
            
            print("Mais um consumidor! Total de \(self.clientes.count) consumidores esperando")
            dispatch_semaphore_signal(customersSemaphore)
            dispatch_semaphore_signal(mutex)
            dispatch_semaphore_wait(barberSemaphore, tempo)
            cliente.beServed()
            searchClient(cliente)
            
        } else {
            
            dispatch_semaphore_signal(mutex)
            giveUpHaircut()
            
        }
        
    }
    
    
    func searchClient(client: Client) {
        for cashier in cashiers {
            if cashier.client != nil && cashier.client == client {
                cashier.client = nil
            }
        }
    }
    
    func cutHair(client: Client) {
        
        print("\nBarbeiro \(NSThread.currentThread().name!) está cortando cabelo\n")
        loop(8)
        return
    }
    
    func customerArrived () {
        print("Cliente chegou pra cortar o cabelo")
    }
    
    
    func giveUpHaircut () {
        print("Cliente Desistiu")
    }
    
    
    @IBAction func showLog(sender: AnyObject) {
        
        
    }
    
    @IBAction func addNewClient(sender: AnyObject) {
        
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Adicione um novo cliente", message: "Digite o nome", preferredStyle: .Alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textFieldNomeDoPaciente) -> Void in
                textFieldNomeDoPaciente.placeholder = "Nome do Cliente"
            })
            alert.addTextFieldWithConfigurationHandler({ (textFieldTempoDeAtendimento) -> Void in
                textFieldTempoDeAtendimento.placeholder = "Tempo de Atendimento"
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Adicionar", style: .Default, handler: { (action) -> Void in
                
                let cliente = Client(name: alert.textFields![0].text!, number: Int(alert.textFields![1].text!)!, necessaryTime: NSTimeInterval(alert.textFields![1].text!)!)

                self.clientes.append(cliente)
                // DELAY OF 1 SECOND
                self.loop(1)
                
                //CREATING THE THREAD OF THE CLIENTS GENERATOR
                let customerGettinHairCut = NSThread(target: self, selector: #selector(self.customer), object: nil)
                customerGettinHairCut.start()

                //            self.configureFilaDeClientes()
                
            }))
            
            // 4. Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)

}
    
    //MARK: TableView Delegates and DataSources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCashiers!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = "UAU"
        return cell
    }
    
    //MARK: ViewControllerFunctions
    
    func configureFilaDeClientes() {
        
        let heigth = 100
        let width = Int(UIScreen.mainScreen().bounds.size.width / 3) - 10
        
        for i in 0..<self.clientes.count {
            let view = UIView(frame: CGRect(x: 5 + ((width + 10) * i), y: 10, width: width, height: heigth))
            view.backgroundColor = UIColor.lightGrayColor()
            let labelID = UILabel(frame: CGRect(x: 5, y: 5, width: view.frame.size.width - 10, height: view.frame.size.height / 2))
            let labelNome = UILabel(frame: CGRect(x: 5, y: 25, width: view.frame.size.width, height: view.frame.size.height))
            labelID.textAlignment = NSTextAlignment.Center
            labelNome.textAlignment = NSTextAlignment.Center
            
            labelID.text = String(self.clientes[i].number)
            labelNome.text = String(self.clientes[i].name)
            
            
            view.addSubview(labelID)
            view.addSubview(labelNome)
            
            self.scrollView.contentSize = CGSizeMake((CGFloat(width) + 10) * CGFloat(self.clientes.count), CGFloat(heigth)+20)
            self.scrollView.addSubview(view)
        }
    }
    
}

