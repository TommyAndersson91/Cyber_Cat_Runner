//
//  GameViewController.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-12.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
        GameViewController.startBackgroundMusic()

            
            
        }
    
    static func startBackgroundMusic() {
        let path = Bundle.main.path(forResource: "background2", ofType: "wav")
        let url = URL(fileURLWithPath: path!)
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.play()
    }
    
    static func stopBackgroundMusic() {
        backgroundMusicPlayer.pause()
    }
    
    }


extension GameViewController: SceneManagerDelegate {
    
    func presentMenuScene() {
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentLevelScene(for world: Int) {
        let scene = LevelScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.world = world
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentGameScene(for level: Int, in world: Int) {
        let scene = GameScene(size: view.bounds.size, world: world, level: level, sceneManagerDelegate: self)
        scene.scaleMode = .aspectFill
        present(scene: scene)
    }
    
    func present(scene: SKScene) {
        
        if let view = self.view as! SKView? {
     
            
            
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsNodeCount = true
            view.showsFPS = true
        //    view.showsPhysics = true
        
    }
}
}
