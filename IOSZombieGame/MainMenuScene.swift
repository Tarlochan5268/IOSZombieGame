//
//  MainMenuScene.swift
//  IOSZombieGame
//
//  Created by Das Tarlochan Preet Singh on 2020-06-12.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import Foundation
import SpriteKit
class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.zPosition = -1 //SpriteKit will draw it before anything else you add to the scene,
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position =  CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTapped(touchLocation: touchLocation)
    }
    func sceneTapped(touchLocation:CGPoint) {
        
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        // 2
        let reveal = SKTransition.doorway(withDuration: 1.5)
        // 3
        view?.presentScene(gameScene, transition: reveal)
    }
    
    
}
