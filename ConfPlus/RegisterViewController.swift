//
//  RegisterViewController.swift
//  ConfPlus
//
//  Created by CY Lim on 29/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
	@IBAction func performRegister(sender: AnyObject) {
		// TODO: API Call to register
		// TODO: Save the information into NSUserDefault
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func dismissRegisterView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
