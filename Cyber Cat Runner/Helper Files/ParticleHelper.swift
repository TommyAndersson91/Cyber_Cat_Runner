//
//  ParticleHelper.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-19.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class ParticleHelper {
    
    /*
     Lägger till en partikeleffekt mha namn: T.ex JumpSmokeEmitter.
     
     */
    
    static func addParticleEffect(name: String, particlePositionRange: CGVector, position: CGPoint) -> SKEmitterNode? {
        
        if let emitter = SKEmitterNode(fileNamed: name) {
            emitter.particlePositionRange = particlePositionRange
            emitter.position = position
            emitter.name = name
            return emitter
        }
        return nil
        
    }
    
    /*
     Tar bort en partikeleffekt.
     
     */
    
    static func removeParticleEffect(name: String, from node: SKNode) {
        let emitters = node[name]
        for emitter in emitters {
            emitter.removeFromParent()
        }
        
    }
    
    
    
}
