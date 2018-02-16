//
//  NodePositionManager.swift
//  ARMario
//
//  Created by Roman Sentsov on 16.02.2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import UIKit
import ARKit

class NodePositionManager {
    
    private var currentX: CGFloat = 0
    private var currentY: CGFloat = 0
    private var currentZ: CGFloat = 0
    
    func updatePositionFor(angle: CGFloat, displacement: CGFloat) -> SCNVector3 {
        let radAngle = angle * .pi / 180
        
        let distance = 0.005 * displacement
        
        currentX = distance * cos(radAngle) + currentX
        currentZ = distance * sin(radAngle) + currentZ
        
        print("=======Update position===========")
        print("angle: \(angle)")
        print("x: \(currentX)")
        print("z: \(currentZ)")
        return SCNVector3(currentX, currentY, currentZ)
    }
    
}
