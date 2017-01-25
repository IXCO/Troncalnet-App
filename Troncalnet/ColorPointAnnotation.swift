//
//  ColorPointAnnotation.swift
//  Troncalnet
//
//  Created by Ana Arellano on 25/01/17.
//  Copyright © 2017 Ixco. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}
