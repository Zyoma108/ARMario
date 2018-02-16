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
            emitter.particleSystem.birthRate = 0
            emitter.node.isHidden = false
            return emitter
        }
        
        fireEmitter = particleEmitterWithName("fire")
    }
    
    func boom() {
        
//        let animation = CABasicAnimation(keyPath: "particleSize")
//        animation.toValue = 2.0
//        animation.duration = 1.0
//        animation.repeatCount = 1
//        fireEmitter?.particleSystem.addAnimation(animation, forKey: "particleSize")
    }
    
    private var fireEmitter: ParticleEmitter?
}
