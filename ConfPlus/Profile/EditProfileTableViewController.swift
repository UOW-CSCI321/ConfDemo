//
//  EditProfileTableViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 12/05/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Localize_Swift

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var lastNameLabel: UILabel!
	@IBOutlet weak var birthLabel: UILabel!
	@IBOutlet weak var streetLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var stateLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var dateTextField: UITextField!
	@IBOutlet weak var streetTextField: UITextField!
	@IBOutlet weak var cityTextField: UITextField!
	@IBOutlet weak var stateTextField: UITextField!
	@IBOutlet weak var countryTextField: UITextField!
	
	let user = NSUserDefaults.standardUserDefaults()
	
	@IBAction func performSave(sender: AnyObject) {
		let title = titleTextField.text
		let firstName = firstNameTextField.text
		let lastName = lastNameTextField.text
		let birthday = dateTextField.text
		let street = streetTextField.text
		let city = cityTextField.text
		let state = stateTextField.text
		let country = countryTextField.text
		
		if let email = user.stringForKey("email"){
			APIManager().updateProfile(email, title: title, first_name: firstName, last_name: lastName, dob: birthday, street: street, city: city, state: state, country: country){ result in
				if result {
					self.user.setObject(title, forKey: "title")
					self.user.setObject(firstName, forKey: "firstName")
					self.user.setObject(lastName, forKey: "lastName")
					self.user.setObject(birthday, forKey: "birthday")
					self.user.setObject(street, forKey: "street")
					self.user.setObject(city, forKey: "city")
					self.user.setObject(state, forKey: "state")
					self.user.setObject(country, forKey: "country")
					
					self.navigationController?.popViewControllerAnimated(true)
				}
				
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		dateTextField.delegate = self
		
		localizeAttribute()
		populateTextField()
    }
	
	func localizeAttribute(){
		navigationController?.title = "EditProfile".localized()
		saveButton.title = "save".localized()
		
		titleLabel.text = "title".localized()
		firstNameLabel.text = "firstName".localized()
		lastNameLabel.text = "lastName".localized()
		birthLabel.text = "birthday".localized()
		streetLabel.text = "street".localized()
		cityLabel.text = "city".localized()
		stateLabel.text = "state".localized()
		countryLabel.text = "country".localized()
		
		titleTextField.placeholder = "title".localized()
		firstNameTextField.placeholder = "firstName".localized()
		lastNameTextField.placeholder = "lastName".localized()
		dateTextField.placeholder = "birthday".localized()
		streetTextField.placeholder = "street".localized()
		cityTextField.placeholder = "city".localized()
		stateTextField.placeholder = "state".localized()
		countryTextField.placeholder = "country".localized()
	}
	
	func populateTextField(){
		if let title = user.stringForKey("title"){ titleTextField.text = title }
		if let firstName = user.stringForKey("firstName"){ firstNameTextField.text = firstName }
		if let lastName = user.stringForKey("lastName"){ lastNameTextField.text = lastName }
		if let birthday = user.stringForKey("birthday"){ dateTextField.text = birthday }
		if let street = user.stringForKey("street"){ streetTextField.text = street }
		if let city = user.stringForKey("city"){ cityTextField.text = city }
		if let state = user.stringForKey("state"){ stateTextField.text = state }
		if let country = user.stringForKey("country"){ countryTextField.text = country }
	}

	@IBAction func editDate(sender: AnyObject) {
		let datePicker = ActionSheetDatePicker(title: "Date", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: {
			picker, value, index in
			
			print("value = \(value)")
			
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			let temp = dateFormatter.stringFromDate(value as! NSDate) as NSString
			self.dateTextField.text = temp as String
			
			print("index = \(index)")
			print("picker = \(picker)")
			return
			}, cancelBlock: { ActionStringCancelBlock in return }, origin: sender.superview!!.superview)
		datePicker.maximumDate = NSDate()
		datePicker.locale = NSLocale(localeIdentifier: "en_AU")
		datePicker.showActionSheetPicker()
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Personal Information".localized()
		} else if section == 1 {
			return "Address".localized()
		}
		return ""
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		
		if textField == dateTextField{
			editDate(dateTextField)
		}
		return false
	}
}
