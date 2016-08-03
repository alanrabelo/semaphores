//
//  PickerViewController.swift
//  Teste de Semáforos
//
//  Created by Alan Rabelo Martins on 03/08/16.
//  Copyright © 2016 Alan Rabelo Martins. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerViewNumberOfCashiers: UIPickerView!

    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        pickerViewNumberOfCashiers.delegate = self
        pickerViewNumberOfCashiers.dataSource = self
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
    @IBAction func addCashiersOnMainViewController(sender: AnyObject) {
        performSegueWithIdentifier("showMain", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mainViewController = segue.destinationViewController as! ViewController
        
        mainViewController.numberOfCashiers = self.pickerViewNumberOfCashiers.selectedRowInComponent(0) + 1
        
    }







}

