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
    //let playableRect: CGRect = null
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
        //move(sprite: zombie,velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        move(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
    }
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
         // 1 convert the offset vector into a unit vector,
        //Velocity is in points per second
         let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
         y: velocity.y * CGFloat(dt))
         print("Amount to move: \(amountToMove)")
         // 2
         sprite.position = CGPoint(
         x: sprite.position.x + amountToMove.x,
         y: sprite.position.y + amountToMove.y)
        
    }
    
    //subtract the zombie position from the tap position, you get a vector showing the offset amount
    func moveZombieToward(location: CGPoint) {
     let offset = CGPoint(x: location.x - zombie.position.x,y: location.y - zombie.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        //length of the hypotenuse using pythogoras theorem
        let direction = CGPoint(x: offset.x / CGFloat(length),y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec,y: direction.y * zombieMovePointsPerSec)
    }
    // The direction points where the zombie should go.
    //length is zombieMovePointsPerSec
    // 1 - This process of converting a vector into a unit vector is called normalizing a vector
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(location: touchLocation)
    }
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    override func touchesMoved(_ touches: Set<UITouch>,with event: UIEvent?) {
         guard let touch = touches.first else {
            return
         }
         let touchLocation = touch.location(in: self)
         sceneTouched(touchLocation: touchLocation)
    }
    
    
    func boundsCheckZombie() {
     let bottomLeft = CGPoint.zero
     let topRight = CGPoint(x: size.width, y: size.height)

     if zombie.position.x <= bottomLeft.x {
     zombie.position.x = bottomLeft.x
     velocity.x = -velocity.x
     }
     if zombie.position.x >= topRight.x {
     zombie.position.x = topRight.x
     velocity.x = -velocity.x
     }
     if zombie.position.y <= bottomLeft.y {
     zombie.position.y = bottomLeft.y
     velocity.y = -velocity.y
     }
     if zombie.position.y >= topRight.y {
     zombie.position.y = topRight.y
     velocity.y = -velocity.y
     }
    }
}
