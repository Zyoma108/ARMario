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

private typealias ParticleEmitter = (node: SCNNode, particleSystem: SCNParticleSystem, birthRate: CGFloat)

class Hero: SCNNode {
    var isWalking = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    addAnimation(walkAnimation, forKey: "walk")
                } else {
                    removeAnimation(forKey: "walk", fadeOutDuration: 0.2)
                }
            }
        }
    }
    
    var isFireShow = false {
        didSet {
            if isFireShow {
                fireEmitter?.particleSystem.birthRate = fireEmitter!.birthRate
            } else {
                fireEmitter?.particleSystem.birthRate = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init?(named: String) {
        guard let scene = SCNScene(named: named) else { return nil }
        super.init()
        
        let characterTopLevelNode = scene.rootNode.childNodes[0]
        addChildNode(characterTopLevelNode)
        
        walkAnimation = CAAnimation.animationWithSceneNamed("art.scnassets/walk.scn")
        walkAnimation.usesSceneTimeBase = false
        walkAnimation.fadeInDuration = 0.3
        walkAnimation.fadeOutDuration = 0.3
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.speed = 1.0
        
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
    
    // MARK: - Animation
    
    private var fireEmitter: ParticleEmitter?
    private var walkAnimation: CAAnimation!
}

extension CAAnimation {
    class func animationWithSceneNamed(_ name: String) -> CAAnimation? {
        var animation: CAAnimation?
        if let scene = SCNScene(named: name) {
            scene.rootNode.enumerateChildNodes({ (child, stop) in
                if child.animationKeys.count > 0 {
                    animation = child.animation(forKey: child.animationKeys.first!)
                    stop.initialize(to: true)
                }
            })
        }
        return animation
    }
}
