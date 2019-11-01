//
//  RepeatingLayer.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-16.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class RepeatingLayer: Layer {
    
    /*
     Funktion för att kolla om en child-node till layern har flyttats så långt till vänster så att den inte syns på skärmen längre.
     Gör så att det blir som en ändlös bakgrundsbild enbart från två bilder. 
     */
    
    override func updateNodes(_ delta: TimeInterval, childNode: SKNode) {
        if let node = childNode as? SKSpriteNode {
            if node.position.x <= -(node.size.width) {
                if node.name == "0" && self.childNode(withName: "1") != nil || node.name == "1" && self.childNode(withName: "0") != nil{
                    node.position = CGPoint(x: node.position.x + node.size.width*2, y: node.position.y)
                }
            }
        }
    }









}
