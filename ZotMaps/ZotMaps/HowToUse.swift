//
//  HowToUse.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class HowToUse: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "1. Click the button on the top right corner to select your destination.\n\n2. You can search for your destination with categories.\n\n3. Follow the directions on the map. Distance and estimated time are on the bottom\n\n 4. Click on the x button to clear the map.\n\n5. Click on the location button to go back to your current location.\n\nNote: Try clicking the distance/estimate time to get a surprise!"
        label.sizeToFit()
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
