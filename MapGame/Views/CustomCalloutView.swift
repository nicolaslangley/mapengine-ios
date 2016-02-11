//
//  CustomCalloutView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    var progressView: UIProgressView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressView?.progress = 0.9
        progressView?.progressTintColor = UIColor.greenColor()
        progressView?.center = self.center
        self.addSubview(progressView!)
        
        // ProgressView AutoLayout Constraints
        progressView?.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: progressView!,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: -1.0)
        let leadingConstraint = NSLayoutConstraint(item: progressView!,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 1.0)
        let bottomConstraint = NSLayoutConstraint(item: progressView!,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: -1.0)
        NSLayoutConstraint.activateConstraints([trailingConstraint, leadingConstraint, bottomConstraint])
        
    }
    
}

