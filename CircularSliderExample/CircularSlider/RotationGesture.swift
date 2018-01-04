//
//  RotationGesture.swift
//  CircularSliderExample
//
//  Created by Matteo Tagliafico on 04/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

public class RotationGestureRecognizer: UIPanGestureRecognizer {
    
    // MARK: - properties
    private var valid = false
    private var arcRadius: CGFloat = 100
    private var knobRadius: CGFloat = 10
    
    public var rotation: CGFloat = 0
    public var tollerance: CGFloat = 0.5
    
    
    // MARK: - init
    init(target: AnyObject?, action: Selector, arcRadius: CGFloat, knobRadius: CGFloat) {
        self.arcRadius = arcRadius
        self.knobRadius = knobRadius
        super.init(target: target, action: action)
        configure()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        if isInsideRing(touches: touches) {
            valid = true
            updateRotationWithTouches(touches: touches)
        } else {
            valid = false
            cancel()
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard valid == true else {
            cancel()
            return
        }
        updateRotationWithTouches(touches: touches)
    }
    
    func updateRotationWithTouches(touches: Set<NSObject>) {
        if let touch = touches[touches.startIndex] as? UITouch {
            rotation = rotationForLocation(location: touch.location(in: view))
        }
    }
    
    
    // MARK: - methods
    private func configure() {
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
        cancelsTouchesInView = false
    }
    
    private func isInsideRing(touches: Set<NSObject>) -> Bool{
        guard let touch = touches[touches.startIndex] as? UITouch else { return false }
        let location = touch.location(in: view)
        
        let outerRadius = arcRadius + knobRadius * (1 + tollerance)
        let innerRadius = arcRadius - knobRadius * (1 + tollerance)
        
        let dist = sqrt(pow(location.x - view!.bounds.midX, 2) + pow(location.y - view!.bounds.midY, 2))
        
        return dist <= outerRadius && dist >= innerRadius
    }
    
    private func rotationForLocation(location: CGPoint) -> CGFloat {
        let offset = CGPoint(x: location.x - view!.bounds.midX, y: location.y - view!.bounds.midY)
        return atan2(offset.y, offset.x)
    }
    
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}
