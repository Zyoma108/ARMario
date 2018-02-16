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

private typealias ParticleEmitter = (node: SCNNode, particleSystem: SCNParticleSystem, birthRate: CGFloat)

class Bloc: SCNNode {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init?(named: String) {
        guard let scene = SCNScene(named: named) else { return nil }
        super.init()
        
        addChildNode(scene.rootNode)
        
        func particleEmitterWithName(_ name: String) -> ParticleEmitter {
            let emitter: ParticleEmitter
            emitter.node = childNode(withName: name, recursively: true)!
            emitter.particleSystem = emitter.node.particleSystems![0]
            emitter.birthRate = emitter.particleSystem.birthRate
            emitter.node.isHidden = false
            return emitter
        }
        
        fireEmitter = particleEmitterWithName("fire")
    }
    
    func boom() {
        SCNTransaction.animateWithDuration(0.3) {
            self.fireEmitter?.particleSystem.particleSize = 0.6
        }
    }
    
    private var fireEmitter: ParticleEmitter?
}

extension SCNTransaction {
    class func animateWithDuration(_ duration: CFTimeInterval = 0.25, timingFunction: CAMediaTimingFunction? = nil, completionBlock: (() -> Void)? = nil, animations: () -> Void) {
        begin()
        self.animationDuration = duration
        self.completionBlock = completionBlock
        self.animationTimingFunction = timingFunction
        animations()
        commit()
    }
}
