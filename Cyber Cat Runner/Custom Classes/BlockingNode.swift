//
//  BlockingNode.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-05-01.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

 /*
 Klass som är tänkt att möjliggöra tilläggandet av tiles som har physicsBody runtom oavsett spelarens position
 Kan identifieras i TileSets.sks filen med t.ex blocking boolean värde på 0. 
 
 */

class BlockingNode: SKSpriteNode {

//    var isBodyActivated: Bool = false {
//     didSet {
//           physicsBody = isBodyActivated ? activatedBody: nil
//       }
//    }
    
    private var activatedBody: SKPhysicsBody?
    
    
    /*
     Initering för en ny blocking tile.
     
     */
    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        let bodyInitialPoint = CGPoint(x: 0.0, y: size.height)
        let bodyEndPoint = CGPoint(x: size.width, y: size.height)
        
        activatedBody = SKPhysicsBody(edgeFrom: bodyInitialPoint, to: bodyEndPoint)
        activatedBody!.restitution = 0.0
        activatedBody!.categoryBitMask = GameConstants.PhysicsCategories.blockingCategory
        activatedBody!.collisionBitMask = GameConstants.PhysicsCategories.playerCategory
        
       
        name = GameConstants.StringConstants.blockingNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
