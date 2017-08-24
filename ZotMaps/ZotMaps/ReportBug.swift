//
//  ReportBug.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class ReportBug: UIViewController {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var label: UILabel!
    let yellow = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "If reporting bug:\nBe as specific as possible where you found a bug.\n\nIf you have questions:\nMake sure to mention which feature of the app you have questions about.\n\nIf you have suggestions:\nI would love to hear your suggestions and make the app better. Maybe you would like a location to be added?\n\nOptional: Let me know if you want a response!"
        label.sizeToFit()
        
        emailButton.layer.cornerRadius = 20
        emailButton.layer.borderWidth = 3
        emailButton.layer.borderColor = yellow.cgColor
        emailButton.addTarget(self, action: #selector(ReportBug.createEmail), for: .touchUpInside)
    }
    
    func createEmail(){
        let email = "zotmapsapp@gmail.com"
        let url = URL(string: "mailto:\(email)")
        UIApplication.shared.openURL(url!)
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
