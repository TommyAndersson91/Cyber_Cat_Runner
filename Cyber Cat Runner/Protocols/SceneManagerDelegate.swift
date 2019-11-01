//
//  SceneManagerDelegate.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-22.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import Foundation

protocol SceneManagerDelegate {
    
    
    func presentLevelScene(for world: Int)
    func presentGameScene(for level: Int, in world: Int)
    func presentMenuScene()
    
}
