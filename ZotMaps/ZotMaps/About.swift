//
//  About.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class About: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        label1.sizeToFit()
        label2.sizeToFit()
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
