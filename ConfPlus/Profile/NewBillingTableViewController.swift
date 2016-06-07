//
//  NewBillingTableViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 3/06/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import PKHUD

class NewBillingTableViewController: UITableViewController, UITextFieldDelegate {
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var cardLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var expireLabel: UILabel!
	
	@IBOutlet weak var cardTextField: UITextField!
	@IBOutlet weak var typeTextField: UITextField!
	@IBOutlet weak var expireTextField: UITextField!
	
	let user = NSUserDefaults.standardUserDefaults()
	var date = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		typeTextField.delegate = self
		expireTextField.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		setText()
	}
	
	@IBAction func performSave(sender: AnyObject) {
		guard let card = cardTextField.text, type = typeTextField.text else {
			HUD.flash(.Label("warnEmpty".localized()), delay: 1)
			return
		}
		if card.characters.count < 10 || type.characters.count == 0 || date.characters.count == 0 {
			HUD.flash(.Label("warnEmpty".localized()), delay: 1)
			return
		}
		HUD.show(.Progress)
		if let email = user.stringForKey("email"){
			APIManager().createBillingInfo(email, card: card, type: type, date: date){ result in
				HUD.hide()
				self.navigationController?.popViewControllerAnimated(true)
			}
		}
	}
	
	@IBAction func editType(sender: AnyObject) {
		ActionSheetStringPicker(title: "Card Type".localized(), rows: ["MasterCard", "VISA", "AMEX"], initialSelection: 0, doneBlock: {
			picker, value, index in
			
			self.typeTextField.text = (index as! String)
			return
			
			}, cancelBlock: { ActionStringCancelBlock in return }, origin: sender).showActionSheetPicker()
	}
	
	@IBAction func editExpire(sender: AnyObject) {
		let datePicker = ActionSheetDatePicker(title: "Expiry Date".localized(), datePickerMode: UIDatePickerMode.Date , selectedDate: NSDate(), doneBlock: {
			picker, value, index in
			
			print("value = \(value)")

			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			let temp = dateFormatter.stringFromDate(value as! NSDate) as NSString
			self.date = temp as String
			self.expireTextField.text = self.date.substringToIndex(self.date.startIndex.advancedBy(7))
			
			print("index = \(index)")
			print("picker = \(picker)")
			return
			}, cancelBlock: { ActionStringCancelBlock in return }, origin: sender.superview!!.superview)
		datePicker.minimumDate = NSDate()
		datePicker.locale = NSLocale(localeIdentifier: "en_AU")
		datePicker.showActionSheetPicker()
	}
	
	func setText(){
		navigationItem.title = "New Billing".localized()
		
		saveButton.title = "save".localized()
		cardLabel.text = "Card Number".localized()
		typeLabel.text = "Card Type".localized()
		expireLabel.text = "Expire Date".localized()
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Billing Information".localized()
		}
		return ""
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		
		if textField == typeTextField{
			editType(typeTextField)
		} else if textField == expireTextField {
			editExpire(expireTextField)
		}
		return false
	}
}
