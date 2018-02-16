//
//  Hero.swift
//  ARMario
//
//  Created by Vyacheslav Khorkov on 16/02/2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Hero: SCNNode {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init?(named: String) {
        guard let scene = SCNScene(named: named) else { return nil }
        super.init()
        
        for node in scene.rootNode.childNodes {
            addChildNode(node)
        }
        
        //scale = SCNVector3(x:0.01, y: 0.01, z: 0.01)
    }
}
