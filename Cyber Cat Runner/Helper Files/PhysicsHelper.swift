//
//  PhysicsHelper.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-16.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class PhysicsHelper {
    
    
    /* Lägger till en fysiskkropp till sprites
    Utifrån dess namn. 
    Physicsbody circleOfRadius är minst krävande
     Rectangle lite mer
     och som mest krävande är Alpha Mask : SKPhysicsBody(texture: sprite.texture!,
     size: CGSize(width: sprite.size.width,
     height: sprite.size.height))  . Vilken ger spriten en physicsbody utifrån dess texture, alltså dess reela form blir dess physicsBody.
     
    */
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        
        switch name {
        case GameConstants.StringConstants.playerName:
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!,
                                               size: CGSize(width: sprite.size.width,
                                                            height: sprite.size.height))
            sprite.physicsBody?.usesPreciseCollisionDetection = true
            sprite.physicsBody!.restitution = 0.0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory | GameConstants.PhysicsCategories.blockingCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.allCategory
        case GameConstants.StringConstants.finishLineName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.finishCategory
        case GameConstants.StringConstants.enemyName:
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!,
                                                          size: CGSize(width: sprite.size.width,
                                                                       height: sprite.size.height))
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.enemyCategory
        case GameConstants.StringConstants.coinName, GameConstants.StringConstants.powerUpName,
             _ where GameConstants.StringConstants.superCoinNames.contains(name):
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.collectibleCategory
        case GameConstants.StringConstants.blocks:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.blockingCategory
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.playerCategory
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        }
        
        if name != GameConstants.StringConstants.playerName {
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody!.isDynamic = false
        }
    }
    
    /*
     Lägger till physicsBody till tilemap med tillhörande tilemapnodes. Kollar ifall de har ett boolean värde som är 1. I detta fallet heter värdet
     ground och anges i TileSets.sks filen för varje tile som ska vara en ground tile. 
     
    */
    static func addPhysicsBody(to tileMap: SKTileMapNode, and tileInfo: String) {
        let tileSize = tileMap.tileSize
        
        for row in 0..<tileMap.numberOfRows {
            var tiles = [Int]()
        //    var blockingTiles = [Int]()
            for col in 0..<tileMap.numberOfColumns {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isUsedTile = tileDefinition?.userData?[tileInfo] as? Bool
//                let isBlockingTile = tileDefinition?.userData?["blocks"] as? Bool
                if (isUsedTile ?? false) {
                    tiles.append(1)
                } else {
                    tiles.append(0)
                }
//                if (isBlockingTile ?? false) {
//                    blockingTiles.append(1)
//                }  else {
//                    blockingTiles.append(0)
//                }
            }
            if tiles.contains(1) {
                var platform = [Int]()
                for (index,tile) in tiles.enumerated() {
                    if tile == 1 && index < (tileMap.numberOfColumns - 1) {
                        platform.append(index)
                    } else if !platform.isEmpty {
                        let x = CGFloat(platform[0]) * tileSize.width
                        let y = CGFloat(row) * tileSize.height
                        let tileNode = GroundNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height))
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.anchorPoint = CGPoint.zero
                        tileMap.addChild(tileNode)
                        platform.removeAll()
                    }
                }
            }
//            if blockingTiles.contains(1) {
//                var platform = [Int]()
//                for (index,tile) in blockingTiles.enumerated() {
//                    if tile == 1 && index < (tileMap.numberOfColumns - 1) {
//                        platform.append(index)
//
//                    } else if !platform.isEmpty {
//                        print(platform)
//                        let x = CGFloat(platform[0]) * tileSize.width
//                        let y = CGFloat(row) * tileSize.height
//                        let tileNode = BlockingNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height))
//                        tileNode.position = CGPoint(x: x, y: y)
//                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: x, height: y))
//                        tileNode.anchorPoint = CGPoint.zero
//                        tileMap.addChild(tileNode)
//                        platform.removeAll()
//
//                    }
//                }
//
//            }
        }
        
    }
}
