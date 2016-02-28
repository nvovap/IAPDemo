//
//  CanvasView.swift
//  IAPDemo
//
//  Created by Gabriel Theodoropoulos on 5/25/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var bezierPath: UIBezierPath!
    
    var selectedStrokeColor = UIColor.redColor()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        bezierPath = UIBezierPath()
        bezierPath.lineWidth = 10.0;
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        if let path = bezierPath {
            selectedStrokeColor.setStroke()
            path.stroke()
        }
    }
    
    
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            bezierPath.moveToPoint(gesture.locationInView(self))
        }
        else if gesture.state == UIGestureRecognizerState.Changed {
            bezierPath.addLineToPoint(gesture.locationInView(self))
            setNeedsDisplay()
        }
        else if gesture.state == UIGestureRecognizerState.Ended {
            bezierPath.addLineToPoint(gesture.locationInView(self))
            setNeedsDisplay()
        }
    }
    
}
