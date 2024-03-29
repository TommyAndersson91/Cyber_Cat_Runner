//
//  MenuScene.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-22.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
  
    override func didMove(to view: SKView) {
        layoutView()
    }
    
    func layoutView() {
        let background = SKSpriteNode(imageNamed: GameConstants.StringConstants.menuBackground)
        background.size = size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = GameConstants.ZPositions.farBGZ
        addChild(background)
        
        let logoLabel = SKLabelNode(fontNamed: GameConstants.StringConstants.gameFontName)
        logoLabel.text = GameConstants.StringConstants.gameName
        logoLabel.fontSize = 200.0
        logoLabel.fontColor = UIColor.white
        logoLabel.scale(to: frame.size, width: true, multiplier: 0.8)
        logoLabel.position = CGPoint(x: frame.midX, y: frame.maxY*0.75 - logoLabel.frame.size.height/2)
        logoLabel.zPosition = GameConstants.ZPositions.hudZ
        addChild(logoLabel)
        
        let startButton = SpriteKitButton(defaultButtonImage: GameConstants.StringConstants.playButton, action: goToLevelScene(_:), index: 0)
        startButton.scale(to: frame.size, width: false, multiplier: 0.1)
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.zPosition = GameConstants.ZPositions.hudZ
        addChild(startButton)
    }
    
    func goToLevelScene(_: Int) {
        sceneManagerDelegate?.presentLevelScene(for: 0)
        
    }
    
}
