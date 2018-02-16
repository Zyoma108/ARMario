//
//  ViewController.swift
//  ARMario
//
//  Created by Roman Sentsov on 16.02.2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet private weak var joystickView: JoyStickView!
    @IBOutlet private weak var jumpButtonView: UIView!
    
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var keepButton: UIButton!
    
    var sessionConfig = ARWorldTrackingConfiguration()
    private weak var marioNode: Hero?
    private var positionManager: NodePositionManager!
    
    enum MarioState {
        case searchingPlane
        case choosingPlane
        case gaming
    }
    
    var marioState: MarioState = MarioState.searchingPlane {
        didSet {
            switch marioState {
            case .searchingPlane:
                keepButton.isHidden = true
                resetButton.isHidden = true
                joystickView.isHidden = true
                jumpButtonView.isHidden = true
            case .choosingPlane:
                keepButton.isHidden = false
                resetButton.isHidden = false
                joystickView.isHidden = true
                jumpButtonView.isHidden = true
            case .gaming:
                keepButton.isHidden = true
                resetButton.isHidden = false
                joystickView.isHidden = false
                jumpButtonView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    private func configure() {
        joystickView.movable = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Tell the session to automatically detect horizontal planes
        sessionConfig.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(sessionConfig)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @IBAction func jumpClicked(_ sender: Any) {
        print("Jump!")
    }
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        // Create a SceneKit plane to visualize the node using its position and extent.
        // Create the geometry and its materials
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let planeImage = UIImage(named: "plane.png")
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = planeImage
        planeMaterial.isDoubleSided = true
        
        plane.materials = [planeMaterial]
        
        // Create a node with the plane geometry we created
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        DispatchQueue.main.async {
            self.marioState = MarioState.choosingPlane
        }
        
        return planeNode
    }
    // MARK: - ARSCNViewDelegate
    
    // When a plane is detected, make a planeNode for it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if marioNode != nil { return }
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        sceneView.scene.rootNode.enumerateChildNodes { (node1, stop) in
            if node1 != node {
                node1.removeFromParentNode()
            }
        }
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createPlaneNode(anchor: planeAnchor)
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
    }
    
    // When a detected plane is removed, remove the planeNode
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !joystickView.displacement.isZero,
            let cameraAngle = sceneView.session.currentFrame?.camera.eulerAngles.y else {
                marioNode?.isWalking = false
                return
        }
        
        let radAngle = joystickView.angle * .pi / 180
        let positionAngle = radAngle - CGFloat(cameraAngle) - CGFloat.pi / 2
        let rotationAngle = -radAngle + CGFloat(cameraAngle) + CGFloat.pi
        
        marioNode?.position = positionManager.updatePositionFor(angle: positionAngle,
                                                                displacement: joystickView.displacement)
        marioNode?.eulerAngles = SCNVector3(0, rotationAngle, 0)
        marioNode?.isWalking = true
    }

    @IBAction func resetClicked(_ sender: Any) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        // Create a session configuration
        sessionConfig.planeDetection = .horizontal
        sceneView.session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        marioState = MarioState.searchingPlane
    }
    
    @IBAction func keepClicked(_ sender: Any) {
        guard let firstNode = sceneView.scene.rootNode.childNodes.first else { return }
        
        let hero = Hero(named: "art.scnassets/panda.scn")!
        
        hero.addChildNode(BlockFabric.bloc!)
        
        hero.position = SCNVector3Make(firstNode.position.x, firstNode.position.y, firstNode.position.z)
        sceneView.scene.rootNode.addChildNode(hero)
        firstNode.removeFromParentNode()
        marioNode = hero
        positionManager = NodePositionManager(position: hero.position)
        
        self.marioState = MarioState.gaming
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
