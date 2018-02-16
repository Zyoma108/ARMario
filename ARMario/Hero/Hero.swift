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
    }
    
    // MARK: - Animation
    
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
