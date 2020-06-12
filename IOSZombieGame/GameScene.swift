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
    let zombieRotateRadiansPerSec:CGFloat = 4.0 * π
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    let playableRect: CGRect
    var lastTouchLocation : CGPoint? //@
    let zombieAnimation: SKAction
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let background = SKSpriteNode(imageNamed: "background1")
        background.zPosition = -1 //SpriteKit will draw it before anything else you add to the scene,
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position =  CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        //background.position = CGPoint(x: size.width/2, y: size.height/2)
        //background.anchorPoint = CGPoint.zero
        //background.position = CGPoint.zero // (0,0)
        
        //background.zRotation = CGFloat(M_PI) / 8  // will rotate the sprite
        print("Size: \(background.size)") // size of sprite
        
        //let zombie = SKSpriteNode(imageNamed: "zombie1")
        zombie.position = CGPoint(x:400,y:400)
        //zombie.setScale(2)
        addChild(zombie)
        //zombie.run(SKAction.repeatForever(zombieAnimation))//animation
        //stop animation
        
        //spawnEnemy()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in self?.spawnEnemy()
        },SKAction.wait(forDuration: 2.0)]))) // periodic spawning
        run(SKAction.repeatForever(
        SKAction.sequence([SKAction.run() { [weak self] in
        self?.spawnCat()
        },
        SKAction.wait(forDuration: 1.0)]))) // spawn cat //scale action
        debugDrawPlayableArea()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //zombie.position = CGPoint(x: zombie.position.x+8, y: zombie.position.y)
        //if((lastTouchLocation - zombie.position) <= zombieMovePointsPerSec*dt )
        
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
       // print("\(dt*1000) milliseconds since last update") // 16.6666
        //move(sprite: zombie,velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        if let lastTouchLocation = lastTouchLocation
        {
            let diff = lastTouchLocation - zombie.position
            if diff.length() <= zombieMovePointsPerSec * CGFloat(dt)
            {
                velocity = CGPoint.zero
                stopZombieAnimation()
            }
            else
            {
                move(sprite: zombie, velocity: velocity)
                rotate(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
            }
        }
        //move(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
        //rotate(sprite: zombie, direction: velocity)
        
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
         // 1 convert the offset vector into a unit vector,
        //Velocity is in points per second
         let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
         y: velocity.y * CGFloat(dt))
         print("Amount to move: \(amountToMove)")
         // 2
         //sprite.position = CGPoint(
         //x: sprite.position.x + amountToMove.x,
         //y: sprite.position.y + amountToMove.y)
        sprite.position += amountToMove
        
    }
    
    //subtract the zombie position from the tap position, you get a vector showing the offset amount
    func moveZombieToward(location: CGPoint) {
     startZombieAnimation()
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
        lastTouchLocation = touchLocation //@
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
     //let bottomLeft = CGPoint.zero
     //let topRight = CGPoint(x: size.width, y: size.height)
    let bottomLeft = CGPoint(x: 0, y: playableRect.minY) //debug
    let topRight = CGPoint(x: size.width, y: playableRect.maxY) //debug
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
    
    override init(size: CGSize) {
     let maxAspectRatio:CGFloat = 16.0/9.0 // 1
     let playableHeight = size.width / maxAspectRatio // 2
     let playableMargin = (size.height-playableHeight)/2.0 // 3
     playableRect = CGRect(x: 0, y: playableMargin,width: size.width,height: playableHeight)//4
    //self.lastTouchLocation = CGPoint.init() //@
        //animation code
        var textures:[SKTexture] = []
        // 2
        for i in 1...4 {
         textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        // 3
        textures.append(textures[2])
        textures.append(textures[1])
        // 4
        zombieAnimation = SKAction.animate(with: textures,
         timePerFrame: 0.1)
        
    super.init(size: size) // 5
    }
    
    required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    func debugDrawPlayableArea() {
     let shape = SKShapeNode()
     let path = CGMutablePath()
     path.addRect(playableRect)
     shape.path = path
     shape.strokeColor = SKColor.red
     shape.lineWidth = 4.0
     addChild(shape)
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint) {
    sprite.zRotation = CGFloat(
    atan2(Double(direction.y), Double(direction.x)))
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint,rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec*CGFloat(dt),abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    /* commented because it waa for testing different actions
    func spawnEnemy() {
     let enemy = SKSpriteNode(imageNamed: "enemy")
     enemy.position = CGPoint(x: size.width + enemy.size.width/2,
     y: size.height/2)
     addChild(enemy)
        //let actionMove = SKAction.move(
         //to: CGPoint(x: -enemy.size.width/2, y: enemy.position.y),
         //duration: 2.0)
        //enemy.run(actionMove)
        let actionMidMove = SKAction.moveBy(
         x: -size.width/2-enemy.size.width/2,
         y: -playableRect.height/2 + enemy.size.height/2,
         duration: 1.0)
        let actionMove = SKAction.moveBy(
         x: -size.width/2-enemy.size.width/2,
         y: playableRect.height/2 - enemy.size.height/2,
         duration: 1.0)
        // 3
        let wait = SKAction.wait(forDuration: 0.25)
        //let sequence = SKAction.sequence([actionMidMove, wait, actionMove]) // makes the sprite wait
        let logMessage = SKAction.run() {
         print("Reached bottom!")
        }
        //let sequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove]) //Run Block aCTION
        //let reverseMid = actionMidMove.reversed()
        //let reverseMove = actionMove.reversed()
        let halfSequence = SKAction.sequence(
         [actionMidMove, logMessage, wait, actionMove])
        let sequence = SKAction.sequence(
         [halfSequence, halfSequence.reversed()])
        //let sequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove,reverseMove,logMessage, wait, reverseMid])
        //Reverse Action
        
        //enemy.run(sequence)
        let repeatAction = SKAction.repeatForever(sequence) // Repeating Action
        enemy.run(repeatAction)
    }
 */ // periodic spawning
    func spawnEnemy() {
     let enemy = SKSpriteNode(imageNamed: "enemy")
     enemy.position = CGPoint(
     x: size.width + enemy.size.width/2,
     y: CGFloat.random(
     min: playableRect.minY + enemy.size.height/2,
     max: playableRect.maxY - enemy.size.height/2))
     addChild(enemy)

     let actionMove =
     SKAction.moveTo(x: -enemy.size.width/2, duration: 2.0)
     //enemy.run(actionMove)
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionMove, actionRemove])) // remove from parent action
    }
    
    //stop animation
    func startZombieAnimation() {
     if zombie.action(forKey: "animation") == nil {
     zombie.run(
     SKAction.repeatForever(zombieAnimation),
     withKey: "animation")
     }
    }
    func stopZombieAnimation() {
     zombie.removeAction(forKey: "animation")
    }
    
    func spawnCat() {
     // 1
     let cat = SKSpriteNode(imageNamed: "cat")
     cat.position = CGPoint(
     x: CGFloat.random(min: playableRect.minX,
     max: playableRect.maxX),
     y: CGFloat.random(min: playableRect.minY,
     max: playableRect.maxY))
     cat.setScale(0)
     addChild(cat)
     // 2
     let appear = SKAction.scale(to: 1.0, duration: 0.5)
     cat.zRotation = -π / 16.0
     let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
     let rightWiggle = leftWiggle.reversed()
     let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
     let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
     let scaleDown = scaleUp.reversed()
     let fullScale = SKAction.sequence(
      [scaleUp, scaleDown, scaleUp, scaleDown])
     let group = SKAction.group([fullScale, fullWiggle])
     let groupWait = SKAction.repeat(group, count: 10)
     let disappear = SKAction.scale(to: 0, duration: 0.5)
     let removeFromParent = SKAction.removeFromParent()
     //let actions = [appear, wiggleWait, disappear, removeFromParent] // rotate action
     let actions = [appear, groupWait, disappear, removeFromParent] //group action
        cat.run(SKAction.sequence(actions))
    }
}
