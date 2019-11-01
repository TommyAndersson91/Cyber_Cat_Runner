//
//  AnimationHelper.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-17.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    
    /*
     Laddar texturer från en atlas som anges som inparameter till metoden.
     Lägger till dem i en SKTexture Array och returnerar sedan arrayen med textures.
     
    */
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        for index in 1..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
        
    }
    
    
    
}
