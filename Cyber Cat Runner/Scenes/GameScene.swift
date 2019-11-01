//
//  GameScene.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-12.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import SpriteKit

enum GameState {
    case ready, ongoing, paused, finished
}


class GameScene: SKScene {
    
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    var foregroundLayer: RepeatingLayer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    
    
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    /*
     Används för att kolla vilket läge spelet befinner sig i.
     
    */
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(bool: false)
            case .paused:
                player.state = .idle
                pauseEnemies(bool: true)
            case .finished:
                player.state = .idle
                pauseEnemies(bool: true)
            default:
                break
            }
        }
    }
    
    var player: Player!
    
    var touch = false
    var brake = false
    var volume = true
    
    var coins = 0
    var superCoins = 0
    
    var world: Int
    var level: Int
    var levelKey: String
    
    var volumeButton = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 50, height: 50))
    
    var popup: PopupNode?
    
    let soundPlayer = SoundPlayer()
    
    var hudDelegate: HUDDelegate?
    var sceneManagerDelegate: SceneManagerDelegate?
    
 
    
    init(size: CGSize, world: Int, level: Int, sceneManagerDelegate: SceneManagerDelegate) {
        self.world = world
        self.level = level
        self.levelKey = "Level_\(world)-\(level)"
        self.sceneManagerDelegate = sceneManagerDelegate
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
      
        createLayers()
       
    
        
       
        
        
    }
    
    /*
     Används för att positionera världen och röra på den.
     worldLayer.layerVelocity används för att ställa in hur världen ska röra sig.
     Även för att sätta bakgrundsbilden korrekt.
     Om värld är lika med 1 så laddas en förgrundsbild in. Vilket är buskar för gräsvärlds-temat.
     
     */
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.ZPositions.worldZ
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -150.0, y: 0.0)
        
        backgroundLayer = RepeatingLayer()
        backgroundLayer.zPosition = GameConstants.ZPositions.farBGZ
        addChild(backgroundLayer)
        
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundNames[world])
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundImage.size.width, y: 0.0)
            backgroundLayer.addChild(backgroundImage)
        }
        
        backgroundLayer.layerVelocity = CGPoint(x: -100.0, y: 0.0)
        
        if world == 1 {
            
            foregroundLayer = RepeatingLayer()
            foregroundLayer.zPosition = GameConstants.ZPositions.hudZ
            addChild(foregroundLayer)
            
            for i in 0...1 {
                let foregroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.foregroundLayer)
                foregroundImage.name = String(i)
                foregroundImage.scale(to: frame.size, width: false, multiplier: 1/15)
                foregroundImage.anchorPoint = CGPoint.zero
                foregroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * foregroundImage.size.width, y: 0.0)
                foregroundLayer.addChild(foregroundImage)
            }
            
            foregroundLayer.layerVelocity = CGPoint(x: -300.0, y: 0.0)
            
        }
        
        load(level: levelKey)
    }
     /*
     Används för att ladda in rätt level.
     
     */
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode {
            tileMap = groundTiles
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "blocks")
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        
        addPlayer()
        addHUD()
       isPaused = true
        isPaused = false
        pauseEnemies(bool: true)
       
      
    
    }
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY-75)
        player.zPosition = GameConstants.ZPositions.playerZ
        player.loadTextures()
        player.state = .idle
        addChild(player)
        player.alpha = 0
       view?.isUserInteractionEnabled = false
        player.run(SKAction.wait(forDuration: 3), completion: {
            self.player.alpha = 1
            self.view?.isUserInteractionEnabled = true
        })
        addPlayerActions()
        
    }
    
    
    func addPlayerActions () {
        let up = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0.4)
        up.timingMode = .easeOut
        
        player.createUserData(entry: up, forKey: GameConstants.StringConstants.jumpUpActionKey)
        
        let move = SKAction.moveBy(x: 0.0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.2/Double(player.jumpFrames.count))
        let group = SKAction.group([move,jump])
        
        
        player.createUserData(entry: group, forKey: GameConstants.StringConstants.brakeDescendActionKey)
    }
    
    func jump() {
        player.airborne = true
        player.turnGravity(on: false)
            self.run(self.soundPlayer.jumpSound)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction ) {
            if self.touch {
                self.player.run(self.player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction, completion: {
                    self.player.turnGravity(on: true)
                  
                })
            }
        }
    }
    
    func brakeDescend() {
        brake = true
        player.physicsBody!.velocity.dy = 0.0
        
        if let smokeJump = ParticleHelper.addParticleEffect(name: GameConstants.StringConstants.jumpSmokeEmitterKey, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: player.position.x, y: player.position.y-player.size.height/2)) {
            smokeJump.zPosition = GameConstants.ZPositions.objectZ
            addChild(smokeJump)
        }
        
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.brakeDescendActionKey) as! SKAction) {
          ParticleHelper.removeParticleEffect(name: GameConstants.StringConstants.jumpSmokeEmitterKey, from: self)
    }
}
    
    func handleEnemyContact() {
        if player.invincible { return }
        die(reason: 0)
    }
    
    func pauseEnemies(bool: Bool) {
        for enemy in tileMap[GameConstants.StringConstants.enemyName] {
            enemy.isPaused = bool
        }
    }
    
    func handleCollectible(sprite: SKSpriteNode) {
        switch sprite.name! {
        case GameConstants.StringConstants.coinName,
             _ where GameConstants.StringConstants.superCoinNames.contains(sprite.name!):
            collectCoin(sprite: sprite)
            run(soundPlayer.coinSound)
        case GameConstants.StringConstants.powerUpName:
            player.activatePowerup(active: true)
           // run(soundPlayer.powerupSound)
        default:
            break
        }
        
    }
    
    func collectCoin(sprite: SKSpriteNode) {
        if GameConstants.StringConstants.superCoinNames.contains(sprite.name!) {
            superCoins += 1
            for index in 0..<3 {
                if GameConstants.StringConstants.superCoinNames[index] == sprite.name! {
                    hudDelegate?.addSuperCoin(index: index)
                }
            }
        } else {
          coins += 1
            hudDelegate?.updateCoinLabel(coins: coins)
        }
        
        
        if let coinDust = ParticleHelper.addParticleEffect(name: GameConstants.StringConstants.coinDustEmitterKey, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint.zero) {
            coinDust.zPosition = GameConstants.ZPositions.objectZ
            sprite.addChild(coinDust)
            sprite.run(SKAction.fadeOut(withDuration: 0.4), completion:  {
                coinDust.removeFromParent()
                sprite.removeFromParent()
            })
        }
        
    }
    
    func buttonHandler(index: Int) {
        if gameState == .ongoing {
            gameState = .paused
            createAndShowPopup(type: 0, title: GameConstants.StringConstants.pausedKey)
        }
    }
        func volumeHandler(index: Int) {
            if volume == true {
                soundPlayer.buttonSound = soundPlayer.muted
                soundPlayer.coinSound = soundPlayer.muted
                soundPlayer.completedSound = soundPlayer.muted
                soundPlayer.deathSound = soundPlayer.muted
                soundPlayer.jumpSound = soundPlayer.muted
                soundPlayer.powerupSound = soundPlayer.muted
                soundPlayer.backgroundSound = soundPlayer.muted
                GameViewController.stopBackgroundMusic()
                volumeButton.texture = SKTexture(imageNamed: GameConstants.StringConstants.volumeOffButton)
                volume = false
                return
            }
            if volume == false {
                soundPlayer.buttonSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
                soundPlayer.coinSound = SKAction.playSoundFileNamed("SFX_Coin04", waitForCompletion: false)
                soundPlayer.completedSound = SKAction.playSoundFileNamed("completed", waitForCompletion: false)
                soundPlayer.deathSound = SKAction.playSoundFileNamed("SFX_Lose01", waitForCompletion: false)
                soundPlayer.jumpSound = SKAction.playSoundFileNamed("SFX_Jump04", waitForCompletion: false)
                soundPlayer.powerupSound = SKAction.playSoundFileNamed("powerup", waitForCompletion: false)
                soundPlayer.backgroundSound = SKAction.playSoundFileNamed("background", waitForCompletion: false)
                GameViewController.startBackgroundMusic()
                volumeButton.texture = SKTexture(imageNamed: GameConstants.StringConstants.volumeOnButton)
                volume = true
                return
            }
            
        }
        
    
    
    func addHUD() {
        let hud = GameHUD(with: CGSize(width: frame.width, height: frame.height*0.1))
        hud.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height*0.05)
        hud.zPosition = GameConstants.ZPositions.hudZ
        hudDelegate = hud
        addChild(hud)
        
        let pauseButton = SpriteKitButton(defaultButtonImage: GameConstants.StringConstants.pauseButton, action: buttonHandler, index: 0)
        pauseButton.scale(to: frame.size, width: false, multiplier: 0.1)
        pauseButton.position = CGPoint(x: frame.midX, y: frame.maxY - pauseButton.size.height/1.9)
        pauseButton.zPosition = GameConstants.ZPositions.hudZ
        addChild(pauseButton)
        
        
        volumeButton = SpriteKitButton(defaultButtonImage: GameConstants.StringConstants.volumeOffButton, action: volumeHandler, index: 0)
        volumeButton.scale(to: frame.size, width: false, multiplier: 0.08)
        volumeButton.position = CGPoint(x: frame.midX+volumeButton.size.width*1.5, y: frame.maxY - volumeButton.size.height/1.9)
        volumeButton.zPosition = GameConstants.ZPositions.hudZ
        addChild(volumeButton)
    }
    /*
    Funktion för att öppna popups
     case 0: Är vid pausning av spelet
     default: Är när en bana klaras av.
     */
    
    
    func createAndShowPopup(type: Int, title: String) {
        switch type {
        case 0:
            popup = PopupNode(withTitle: title, and: SKTexture(imageNamed: GameConstants.StringConstants.smallPopup), buttonHandlerDelegate: self)
            
            popup!.add(buttons: [0,3,2])
        default:
            popup = ScorePopupNode(buttonHandlerDelegate: self, title: title, level: levelKey, texture: SKTexture(imageNamed: GameConstants.StringConstants.largePopup), score: coins, coins: superCoins, animated: true)
            popup!.add(buttons: [2,0])
        }
        
        popup!.position = CGPoint(x: frame.midX, y: frame.midY)
        popup!.zPosition = GameConstants.ZPositions.hudZ
        popup!.scale(to: frame.size, width: true, multiplier: 0.8)
        addChild(popup!)
    }
    
    /*
     Funktionen för att "döda" spelaren. case 0: Är när spelar-spriten vidrör vid något dödligt.
     case 1: Är när spelaren ramlar ner från banan, vilket gör att sekvensen: up, wait, och down körs
     vilket gör att spelaren åker upp och sedan ner igen. 
 
    */
    func die(reason: Int) {
        run(soundPlayer.deathSound)
        gameState = .finished
        player.turnGravity(on: false)
        let deathAnimation: SKAction!
        switch reason {
        case 0:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case 1:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.25)
            let wait = SKAction.wait(forDuration: 0.1)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
            deathAnimation = SKAction.sequence([up,wait,down])
        default:
               deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        
        player.run(deathAnimation) {
            self.player.removeFromParent()
            self.createAndShowPopup(type: 1, title: GameConstants.StringConstants.failedKey)
        }
        
    }
    
    func finishGame() {
        run(soundPlayer.completedSound)
       
        if player.position.y > frame.size.height*0.7 {
            coins += 10
        }
        
        gameState = .finished
        player.turnGravity(on: false)
        var stars = 0
        let percentage = CGFloat(coins)/100.0
        if percentage >= 0.8 {
            stars = 3
        } else if percentage >= 0.4 {
            stars = 2
        } else if coins >= 1 {
            stars = 1
        }
        let scores = [
            GameConstants.StringConstants.scoreScoreKey: coins,
            GameConstants.StringConstants.scoreStarsKey: stars,
            GameConstants.StringConstants.scoreCoinsKey: superCoins
        ]
        ScoreManager.compare(scores: [scores], in: levelKey)
        createAndShowPopup(type: 1, title: GameConstants.StringConstants.completedKey)
        
        if level < 9 {
            let nextLevelKey = "Level_\(world)-\(level+1)_Unlocked"
            UserDefaults.standard.set(true, forKey: nextLevelKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            switch self.gameState {
        case .ready:
            self.gameState = .ongoing
        case .ongoing:
            self.touch = true
            if !self.player.airborne {
                self.jump()
            } else if !self.brake {
                self.brakeDescend()
            }
        default:
            break
        
    }
   
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    

    
    /*
     Funktion som körs för varje frame.
     Inne i update-metoden så ges variabeln currentTime den nuvarande tiden på system.
     dt = currentTime - lastTime ger tiden som förflutit från det senaste anropet och sätter den tiden till variabeln dt.
     lastTime = currentTime gör så att lastTime innehåller tiden från senaste funktionsanropet.
     worldLayer.update(dt) = Gör så att tiden från senaste gången funktionen kallades på alltid finns sparad.
     */
    var lastPlayerYPos: CGFloat = 0
    var falling: Bool = false
    var outOfMap: Bool = false
    override func update(_ currentTime: TimeInterval) {
        
        if player.position.y - player.size.height/3 < lastPlayerYPos {
            
            // PÅ väg ner
            if !falling {
                falling = true
                player.run(player.loadFallingFrames())
            
            }
            
        } else {
            falling = false
        }
        //Kontroller ifall spelarens x-position är mindre än framens minimum x-nivå (Längst till vänster). Vilket kan förekomma om han blir blockerad av något. Jag har lagt till så att noder med namnet "Box" Kommer få en rektangulär fysiskkropp som blockerar spelaren.
        if (player.position.x <= frame.minX-10 && outOfMap == false) {
            outOfMap = true
          die(reason: 0)
        }
        
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        lastTime = currentTime
        
        /*
        När spelaren klickar på skärmen så körs banan igång och rör sig åt höger.
        backgroundLayer uppdateras för att hela tiden ha en bakgrundsbild. 
        */
        
        if gameState == .ongoing {
          worldLayer.update(dt)
            backgroundLayer.update(dt)
            
            if world == 1 {
                foregroundLayer.update(dt)
            }
            
        }
        
        lastPlayerYPos = player.position.y - player.size.height/3
        
    }
    
    /*
    Funktion för att lägger till physics body åt tiles så länge som spelaren är ovanför tiles.
     och vice versa om spelaren är under dem. Så att spelaren kan hoppa igenom tiles så länge som han är under dem.
 
    */
    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.StringConstants.groundNodeName] {
            if let groundNode = node as? GroundNode {
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height/3
                groundNode.isBodyActivated = playerY > groundY
            }
        }
        
//        for node in tileMap[GameConstants.StringConstants.blockingNodeName] {
//            if let blockingNode = node as? BlockingNode {
//             blockingNode.physicsBody =
//
//
//    }
//        }
    }








}


extension GameScene: SKPhysicsContactDelegate {
    
    /*
    Håller koll på vad som händer när olika objekt får fysiskkontakt.
 
    */
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = false
            player.run(player.loadRunFrames())
            brake = false
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.finishCategory:
            finishGame()
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.enemyCategory:
            handleEnemyContact()
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.frameCategory:
            physicsBody = nil
            die(reason: 1)
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.collectibleCategory:
           
           let collectible = contact.bodyA.node?.name == player.name ? contact.bodyB.node as! SKSpriteNode : contact.bodyA.node as! SKSpriteNode
           
            
            handleCollectible(sprite: collectible)
            collectible.removeFromParent()
//        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.blockingCategory:
//            //Inget, kan vara bra att ha ifall något ska hända vid kontakt med blockerande noder, utöver att de blockerar varandra.
        default:
            break
        }
    }
    
    /*
     Håller koll på vad som händer när olika objekt slutar röra vid varandra.
    */
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
            player.airborne = true
        default:
            break
        }
    }
}

extension GameScene: PopupButtonHandlerDelegate {
    
    func popupButtonHandler(index: Int) {
        switch index {
        case 0:
            //Menu
            sceneManagerDelegate?.presentMenuScene()
        case 1:
            //Play
        sceneManagerDelegate?.presentLevelScene(for: world)
        case 2:
            //Retry
            sceneManagerDelegate?.presentGameScene(for: level, in: world)
        case 3:
            //Cancel
            popup!.run(SKAction.fadeOut(withDuration: 0.2), completion: {
                self.popup!.removeFromParent()
                self.gameState = .ongoing
            })
        default:
            break 
        }
    }
    
}
