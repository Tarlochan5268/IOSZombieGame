//
//  GameViewController.swift
//  IOSZombieGame
//
//  Created by Das Tarlochan Preet Singh on 2020-06-10.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size:CGSize(width: 2048, height: 1536))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true // SpriteKit makes no guarantee as to the order in which a node draws its child nodes that share the same zPosition.
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
