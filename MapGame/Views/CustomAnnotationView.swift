//
//  CustomAnnotationView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/10/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called when drawing the CustomAnnotationView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let customAnnotation = self.annotation as! CustomAnnotation
        switch (customAnnotation.type) {
        case .UnitFirstAid:
            image = UIImage(named: "firstaid")
        case .UnitFood:
            image = UIImage(named: "food")
        case .UnitRide:
            image = UIImage(named: "ride")
        default:
            image = UIImage(named: "star")
        }
    }
}
