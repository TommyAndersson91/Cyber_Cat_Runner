//
//  ObjectHelper.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-17.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class ObjectHelper {
    
    
    /*
     Hanterar mynt utifrån namnet på myntsamlingen. T.ex 3x3 ger 3 mynt i bredd och höjd
    */
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        
        switch name {
        case GameConstants.StringConstants.finishLineName, GameConstants.StringConstants.enemyName, GameConstants.StringConstants.powerUpName, GameConstants.StringConstants.blocks,
             _ where GameConstants.StringConstants.superCoinNames.contains(name):
            PhysicsHelper.addPhysicsBody(to: sprite, with: name)
        default:
            let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            if let rows = Int(component[0]), let columns = Int(component[1]) {
            calculateGridWith(rows: rows, columns: columns, parent: sprite)
            }
        }
    }
    /*
    Räknar ut storleken på myntsamlingen
     
    */
    static func calculateGridWith(rows: Int, columns: Int, parent: SKSpriteNode) {
        parent.color = UIColor.clear
        for x in 0..<columns {
            for y in 0..<rows {
                let position = CGPoint(x: x, y: y)
                addCoin(to: parent, at: position, columns: columns)
            }
        }
    }
    /*
     Lägger till mynt och sätter storlek utifrån antalet kolumner och sätter position på varje mynt.
     
    */
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        let coin = SKSpriteNode(imageNamed: GameConstants.StringConstants.coinImageName)
        coin.size = CGSize(width: parent.size.width/CGFloat(columns), height: parent.size.width/CGFloat(columns))
        coin.name = GameConstants.StringConstants.coinName
        
      
        coin.position = CGPoint(x: position.x * coin.size.width + coin.size.width/2, y: position.y * coin.size.height + coin.size.height/2)
        
        let coinFrames = AnimationHelper.loadTextures(from:SKTextureAtlas(named: GameConstants.StringConstants.coinRotateAtlas), withName: GameConstants.StringConstants.coinPrefixKey)
        
        coin.run(SKAction.repeatForever(SKAction.animate(with: coinFrames, timePerFrame: 0.1)))
        
        PhysicsHelper.addPhysicsBody(to: coin, with: GameConstants.StringConstants.coinName)
        
        parent.addChild(coin)
    }
    
}
