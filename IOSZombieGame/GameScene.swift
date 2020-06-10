//
//  GameScene.swift
//  IOSZombieGame
//
//  Created by Das Tarlochan Preet Singh on 2020-06-10.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let background = SKSpriteNode(imageNamed: "background1")
        background.zPosition = -1 //SpriteKit will draw it before anything else you add to the scene,
        addChild(background)
        //background.position = CGPoint(x: size.width/2, y: size.height/2)
        //background.anchorPoint = CGPoint.zero
        //background.position = CGPoint.zero // (0,0)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position =  CGPoint(x: size.width/2, y: size.height/2)
        //background.zRotation = CGFloat(M_PI) / 8  // will rotate the sprite
        print("Size: \(background.size)") // size of sprite
        
        //let zombie = SKSpriteNode(imageNamed: "zombie1")
        zombie.position = CGPoint(x:400,y:400)
        //zombie.setScale(2)
        addChild(zombie)
    }
    
    override func update(_ currentTime: TimeInterval) {
        zombie.position = CGPoint(x: zombie.position.x+8, y: zombie.position.y)
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000) milliseconds since last update") // 16.6666
        move(sprite: zombie,velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
    }
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
         // 1
        //Velocity is in points per second
         let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
         y: velocity.y * CGFloat(dt))
         print("Amount to move: \(amountToMove)")
         // 2
         sprite.position = CGPoint(
         x: sprite.position.x + amountToMove.x,
         y: sprite.position.y + amountToMove.y)
    }
    
}
