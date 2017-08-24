//
//  Menu.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class Menu: UIViewController {

    @IBOutlet weak var howToUse: UIButton!
    @IBOutlet weak var emergencyProcedures: UIButton!
    @IBOutlet weak var reportABug: UIButton!
    @IBOutlet weak var about: UIButton!
    let yellow = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        howToUse.layer.cornerRadius = 20
        howToUse.layer.borderWidth = 3
        howToUse.layer.borderColor = yellow.cgColor
        emergencyProcedures.layer.cornerRadius = 20
        emergencyProcedures.layer.borderWidth = 3
        emergencyProcedures.layer.borderColor = yellow.cgColor
        reportABug.layer.cornerRadius = 20
        reportABug.layer.borderWidth = 3
        reportABug.layer.borderColor = yellow.cgColor
        about.layer.cornerRadius = 20
        about.layer.borderWidth = 3
        about.layer.borderColor = yellow.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
