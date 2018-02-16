//
//  MeteoriteManager.swift
//  ARMario
//
//  Created by Daniil on 17.02.2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

public protocol MeteoritesDelegate: class {
    func pandaIsDead()
}

class MeteoritesNode: SCNNode {
    
    let maxMeteors = 7
    let radius = 2.0
    let speedMeteorites: Float = 0.01
    let startHeightMeteorites: Float = 2.0
    var deltaPosition: SCNVector3?
    var prevPosition: SCNVector3?
    
    public weak var delegate: MeteoritesDelegate?
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init(position: SCNVector3) {
        super.init()
        self.position = position
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updatePosition(_ position: SCNVector3) {
        self.position = position
        if prevPosition != nil {
            deltaPosition = SCNVector3(position.x - prevPosition!.x, position.y - prevPosition!.y, position.z - prevPosition!.z)
        }
        prevPosition = position
        updatePositionMeteors()
        checkFallinMeteors()
    }
    
    @objc func updateTimer() {
        createNewMeteors()
    }
    
    fileprivate func checkFallinMeteors() {
        for node in self.childNodes {
            if node.position.y <= 0.0 {
                if node.position.x < 0.5 && node.position.x > -0.5 && node.position.z < 0.5 && node.position.z > -0.5 {
                    delegate?.pandaIsDead()
                }
                node.removeFromParentNode()
            }
        }
    }
    
    fileprivate func createNewMeteors() {
        if self.childNodes.count >= maxMeteors { return }
        if let node = BlockFabric.bloc {
            let randomX = Float(arc4random_uniform(UInt32(radius * 2))) - 3.0
            let randomZ = Float(arc4random_uniform(UInt32(radius * 2))) - 3.0
            node.position = SCNVector3(randomX, startHeightMeteorites, randomZ)
            self.addChildNode(node)
        }
    }
    
    fileprivate func updatePositionMeteors() {
        for node in self.childNodes {
            if deltaPosition != nil {
                node.position = SCNVector3(node.position.x - deltaPosition!.x + 0.005, node.position.y - speedMeteorites, node.position.z - deltaPosition!.z)
            } else {
                node.position = SCNVector3(node.position.x, node.position.y - speedMeteorites, node.position.z)
            }
        }
    }
}
