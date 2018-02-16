//
//  Bloc.swift
//  ARMario
//
//  Created by Vyacheslav Khorkov on 17/02/2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Bloc: SCNNode {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init?(named: String) {
        guard let scene = SCNScene(named: named) else { return nil }
        super.init()
        
        addChildNode(scene.rootNode)
    }
}
