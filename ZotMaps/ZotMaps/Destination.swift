//
//  Destination.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class Destination: NSObject {
    var name = ""
    var category = ""
    var lat = 0.0
    var long = 0.0
    
    init(name: String, category: String, lat: Double, long: Double){
        self.name = name
        self.category = category
        self.lat = lat
        self.long = long
    }
    
    override init(){
        super.init()
    }
}
