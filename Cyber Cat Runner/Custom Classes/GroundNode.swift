//
//  GroundNode.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-16.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class GroundNode: SKSpriteNode {
   
    var isBodyActivated: Bool = false {
        didSet {
            physicsBody = isBodyActivated ? activatedBody: nil
        }
    }
    
    private var activatedBody: SKPhysicsBody?
    
    
    /*
     Initering för en ny ground tile. 
     
     */
    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        let bodyInitialPoint = CGPoint(x: 0.0, y: size.height)
        let bodyEndPoint = CGPoint(x: size.width, y: size.height)
        
        activatedBody = SKPhysicsBody(edgeFrom: bodyInitialPoint, to: bodyEndPoint)
        activatedBody!.restitution = 0.0
        activatedBody!.categoryBitMask = GameConstants.PhysicsCategories.groundCategory
        activatedBody!.collisionBitMask = GameConstants.PhysicsCategories.playerCategory
        
        physicsBody = isBodyActivated ? activatedBody : nil
        
        name = GameConstants.StringConstants.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
