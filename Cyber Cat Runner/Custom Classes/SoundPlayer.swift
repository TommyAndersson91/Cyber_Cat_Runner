//
//  SoundPlayer.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-22.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

/*
 Klass där de olika ljuden i spelet är samlade.
 muted används för att ersätta ljudet när ljudet är avstängt. 
 
 */

class SoundPlayer {
    
    var buttonSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
    var coinSound = SKAction.playSoundFileNamed("SFX_Coin04", waitForCompletion: false)
    var completedSound = SKAction.playSoundFileNamed("completed", waitForCompletion: false)
    var deathSound = SKAction.playSoundFileNamed("SFX_Lose01", waitForCompletion: false)
    var powerupSound = SKAction.playSoundFileNamed("powerup", waitForCompletion: false)
    var jumpSound = SKAction.playSoundFileNamed("SFX_Jump04", waitForCompletion: false)
    var backgroundSound = SKAction.playSoundFileNamed("background", waitForCompletion: false)
    
    let muted = SKAction.stop()
    
}
