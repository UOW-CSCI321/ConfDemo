//
//  testSeat.swift
//  ConfPlus
//
//  Created by Matthew Boroczky on 22/04/2016.
//  Copyright © 2016 Conf+. All rights reserved.
//

import UIKit

class testSeat: UIViewController {
    @IBOutlet var buttonCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //int
        // Create a constant, jagged array.
        let units: [[Int]] = [[1, 2, 3, 4], [5, 6, 7, 8]]
        
        // Loop over array and all nested arrays.
        for var x = 0; x < units.count; x++ {
            var line = ""
            for var y = 0; y < units[x].count; y++ {
                line += String(units[x][y])
                line += " "
            }
            print(line)
        }
        
        var a = UIButton()
        a.setTitle("test",  forState: UIControlState.Normal)
        
        var x_pos:CGFloat? = 50.0;
        var y_pos:CGFloat? = 50.0;
        a.frame = CGRectMake(x_pos!, y_pos!, a.frame.width, a.frame.height)
        
        let buttons: [[UIButton]] = [[a,a,a,a],[a,a,a,a]]
        for var x = 0; x < buttons.count; x++ {
            var line = ""
            for var y = 0; y < buttons[x].count; y++ {
                //line += String(buttons[x][y])
                //line += " "
                buttons[x][y].frame = CGRectMake(x_pos!, y_pos!, a.frame.width, a.frame.height)
                y_pos = y_pos! + 50.0
                
                line += "\(buttons[x][y].frame.maxX)-\(buttons[x][y].frame.maxY)"
                line+=", "
            }
            x_pos = x_pos! + 50.0
            print(line)
        }

        
        /*
        //var buttonArray:[UIButton] = []
        var b = [Double](count:4, repeatedValue:2.3)
        var c = [Double][Double]
        var buttonArray = [[UIButton]]()
        buttonArray.append([])
        var a = UIButton()
        a.setTitle("test",  forState: UIControlState.Normal)
        var b = UIButton()
        b.setTitle("test2",  forState: UIControlState.Normal)
        buttonArray[0][0].append(a)
        buttonArray[0][1].
        //buttonArray[0].*/
        /*for i in 1...10 {
            buttonArray[i] =
        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        
}

