
//
//  TicketProfileTableViewController.swift
//  confDemo
//
//  Created by Matthew Boroczky on 15/03/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class TicketProfileTableViewController: UITableViewController {
	
	@IBOutlet weak var qrImage: UIImageView!
	
    @IBOutlet weak var titleDetailsLabel: UILabel!
    @IBOutlet weak var venueDetailsLabel: UILabel!
	@IBOutlet weak var roomDetailLabel: UILabel!
	@IBOutlet weak var typeDetailLabel: UILabel!
    @IBOutlet weak var classDetailsLabel: UILabel!
	@IBOutlet weak var seatDetailLabel: UILabel!
	@IBOutlet weak var nameDetailLabel: UILabel!
	@IBOutlet weak var emailDetailLabel: UILabel!
	
	var ticket:Ticket_Record?
	
	let user = NSUserDefaults.standardUserDefaults()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if ticket != nil{
			generateQR()
			
            var title:String = (ticket?.title)!
            title += " - "
            title += (ticket?.ticket_name)!
            titleDetailsLabel.text = title
            
            venueDetailsLabel.text = ticket?.venue_id
            roomDetailLabel.text = ticket?.room_name
			typeDetailLabel.text = ticket?.type
            classDetailsLabel.text = ticket?.ticket_class
			seatDetailLabel.text = ticket?.seat_num
            var name:String = user.stringForKey("firstName")!
            name += " "
            name += user.stringForKey("lastName")!
            nameDetailLabel.text = name
			emailDetailLabel.text = user.stringForKey("email")
			
		}
		
		
		navigationController?.hidesBarsOnSwipe = true
	}
	
	
	func generateQR(){
		let data = String(ticket?.record_id).dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
		
		let filter = CIFilter(name: "CIQRCodeGenerator")
		
		filter!.setValue(data, forKey: "inputMessage")
		filter!.setValue("Q", forKey: "inputCorrectionLevel")
		
		let qrcodeImage = filter!.outputImage
		
		qrImage.image = UIImage(CIImage: qrcodeImage!)
	}
}