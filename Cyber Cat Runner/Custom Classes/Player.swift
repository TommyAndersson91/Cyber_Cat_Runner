//
//  Player.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-16.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit


enum PlayerState {
    case idle, running
}

class Player: SKSpriteNode {
    
    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    var fallFrames = [SKTexture]()
    
    var state = PlayerState.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    var airborne = false
    var invincible = false
    
    /*
     Laddar texturer från olika texturatlas i asset-katalogen.
     
     */
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerIdleAtlas), withName: GameConstants.StringConstants.idlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerRunAtlas), withName: GameConstants.StringConstants.runPrefixKey)
        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerJumpAtlas), withName: GameConstants.StringConstants.jumpPrefixKey)
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerDieAtlas), withName: GameConstants.StringConstants.diePrefixKey)
        fallFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerFallAtlas), withName: GameConstants.StringConstants.fallPrefixKey) 
    }
    
    /*
     Kör animationer utefter vilket stadium spelarspriten befinner sig.
     .idle är när spelet antingen ej är startat eller är pausat.
     .running är när spelet körs.
     */
    
    func animate(for state: PlayerState) {
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
        
    }
    
    /*
     Funktionen för att aktivera en powerup och kör partikeleffekten som hör till.
     forDuration: specificerar hur länge den körs innan det som står efter completion: körs.
     */
    
    func activatePowerup(active: Bool) {
        if active {
            if let powerupEffect = ParticleHelper.addParticleEffect(name: GameConstants.StringConstants.powerupEmitterKey, particlePositionRange: CGVector(dx: 0.0, dy: size.height), position: CGPoint(x: -size.width, y: 0.0)) {
                powerupEffect.zPosition = GameConstants.ZPositions.objectZ
                addChild(powerupEffect)
                invincible = true
                run(SKAction.wait(forDuration: 5.0), completion: {
                    self.activatePowerup(active: false)
                })
            }
        } else {
            invincible = false
            ParticleHelper.removeParticleEffect(name: GameConstants.StringConstants.powerupEmitterKey, from: self)
        }
    }
    /*
    Används för att köra runFrames när spelaren når marken igen efter ha fallit.
 
    */
    
    func loadRunFrames() -> SKAction{
        let runAnimation: SKAction!
        runAnimation = SKAction.animate(with: runFrames, timePerFrame: 0.05)
        return runAnimation
    }
    
    func loadFallingFrames() -> SKAction{
    let fallAnimation: SKAction!
    fallAnimation = SKAction.animate(with: fallFrames, timePerFrame: 0.2/Double(jumpFrames.count))
        return fallAnimation
    }
}
