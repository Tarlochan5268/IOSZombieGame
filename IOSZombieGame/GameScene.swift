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
    }
    
}
