//
//  MainViewController.swift
//  tips
//
//  Created by Michael Bock on 8/3/15.
//  Copyright (c) 2015 Michael R. Bock. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var billField: UITextField!

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitLabel1: UILabel!
    @IBOutlet weak var splitLabel2: UILabel!
    @IBOutlet weak var splitLabel3: UILabel!
    @IBOutlet weak var splitLabel4: UILabel!

    var allLabels = [UILabel]()
    var splitLabels = [UILabel]()

    @IBOutlet weak var tipControl: UISegmentedControl!

    var tipPercentages = [18.0, 20.0, 22.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        allLabels = [tipLabel, totalLabel, splitLabel1, splitLabel2, splitLabel3, splitLabel4]
        splitLabels = [splitLabel1, splitLabel2, splitLabel3, splitLabel4]

        billField.becomeFirstResponder()

        println("viewDidLoad")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        let defaults = NSUserDefaults.standardUserDefaults()

        for i in 0...2 {
            let percentValue = defaults.integerForKey("option\(i+1)")
            if percentValue != 0 {
                tipControl.setTitle(String(percentValue) + "%", forSegmentAtIndex: i)
                tipPercentages[i] = Double(Double(percentValue)/100.0)
            } else {
                tipControl.setTitle("\(18+i*2)%", forSegmentAtIndex: i)
                tipPercentages[i] = Double(Double(18+i*2)/100.0)
            }
        }

        let lastBillAmount = defaults.objectForKey("billAmount") as! String
        let lastSavedDate = defaults.objectForKey("lastSavedDate") as! NSDate?
        if lastSavedDate != nil {
            if NSDate().compare(lastSavedDate!.dateByAddingTimeInterval(600)) ==
                NSComparisonResult.OrderedAscending {
                    billField.text = lastBillAmount
            } else {
                billField.text = ""
            }
        }

        let currencyChoice = defaults.objectForKey("currencyChoice") as! String?
        if currencyChoice != nil {
            currencyLabel.text = currencyChoice
        } else {
            currencyLabel.text = "$"
        }

        updateLabels()

        println("viewWillAppear")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text, forKey: "billAmount")
        defaults.setObject(NSDate(), forKey: "lastSavedDate")
        defaults.synchronize()

        println("viewWillDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateLabels()
    }

    func updateLabels() {
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]

        var billAmount = (billField.text as NSString).doubleValue
        var tip = billAmount * tipPercentage
        var total = billAmount + tip

        tipLabel.text = String(format: "\(currencyLabel.text!)%.2f", tip)
        totalLabel.text = String(format: "\(currencyLabel.text!)%.2f", total)
        for i in 0...count(splitLabels)-1 {
            splitLabels[i].text =
                String(format: "\(currencyLabel.text!)%.2f", total/Double(i+1))
        }

        if currencyLabel.text == "€" {
            for label in allLabels {
                label.text = label.text?
                    .stringByReplacingOccurrencesOfString(".", withString: ",")
            }
        } else {
            for label in allLabels {
                label.text = label.text?
                    .stringByReplacingOccurrencesOfString(",", withString: ".")
            }
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

