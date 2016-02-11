//
//  CustomAnnotationView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/10/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit

class CustomAnnotationView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called when drawing the CustomAnnotationView
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "firstaid.png"))
        self.addSubview(imageView)
    }
}