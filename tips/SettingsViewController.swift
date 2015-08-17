//
//  SettingsViewController.swift
//  tips
//
//  Created by Michael Bock on 8/6/15.
//  Copyright (c) 2015 Michael R. Bock. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var option1Field: UITextField!
    @IBOutlet weak var option2Field: UITextField!
    @IBOutlet weak var option3Field: UITextField!

    var optionFields = [UITextField]()

    @IBOutlet weak var currencyControl: UISegmentedControl!
    var currencies = ["$", "£", "€"]

    override func viewDidLoad() {
        super.viewDidLoad()

        optionFields = [option1Field, option2Field, option3Field]
        for optionField in optionFields {
            optionField.delegate = self
        }

        addDoneButtonToKeyboards()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let defaults = NSUserDefaults.standardUserDefaults()

        for optionField in optionFields {
            let percentValue = defaults.integerForKey(optionField.restorationIdentifier!)
            if percentValue != 0 {
                optionField.text = String(percentValue)
            }
        }

        if let currencyChoice = defaults.objectForKey("currencyChoice") as? String {
            currencyControl.selectedSegmentIndex = find(currencies, currencyChoice)!
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            let defaults = NSUserDefaults.standardUserDefaults()

            let oldText = textField.text as NSString
            let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)

            // Check that only numbers are inputted
            if count(newText) == 0 {
                defaults.setInteger(0, forKey: textField.restorationIdentifier!)
                defaults.synchronize()
                return true
            } else if count(newText) >= 4 {
                return false
            } else if let newTextInt = newText.toInt() {
                // remove leading zer0s
                textField.text = String(newTextInt)
                defaults.setInteger(newTextInt, forKey: textField.restorationIdentifier!)
                defaults.synchronize()
                return false
            } else {
                return false
            }
    }

    @IBAction func valueChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(currencies[currencyControl.selectedSegmentIndex], forKey: "currencyChoice")
        defaults.synchronize()
    }

    func addDoneButtonToKeyboards() {
        var doneToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default

        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))

        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(flexSpace)
        toolBarItems.append(doneButton)

        doneToolbar.items = toolBarItems
        doneToolbar.sizeToFit()

        for optionField in optionFields {
            optionField.inputAccessoryView = doneToolbar
        }
    }

    func doneButtonAction() {
        for optionField in optionFields {
            optionField.resignFirstResponder()
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
