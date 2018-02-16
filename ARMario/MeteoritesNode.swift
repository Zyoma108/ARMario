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
    func meteoriteDidFell(position: SCNVector3)
}

class MeteoritesNode: SCNNode {
    
    let maxMeteors = 5
    
    public weak var delegate: MeteoritesDelegate?
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    init(position: SCNVector3) {
        super.init()
        self.position = position
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updatePosition(_ position: SCNVector3) {
        self.position = position
        updatePositionMeteors()
    }
    
    @objc func updateTimer() {
        checkFallinMeteors()
        createNewMeteors()
    }
    
    fileprivate func checkFallinMeteors() {
        
    }
    
    fileprivate func createNewMeteors() {
        
    }
    
    fileprivate func updatePositionMeteors() {
        if self.childNodes.count <= maxMeteors { return }
    }
}
