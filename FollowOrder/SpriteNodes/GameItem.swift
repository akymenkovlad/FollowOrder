//
//  GameItem.swift
//  FollowOrder
//
//  Created by Valados on 13.01.2022.
//

import SpriteKit

class GameItem: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "cool_emoji")
        super.init(texture: texture, color: .clear, size: CGSize(width: 75, height: 75))
    }
    
    init(with name:String,index: Int, size:CGSize) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: size)
        self.userData = ["value":index]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pulse() {
        self.run(.sequence([.scale(to: 1.5, duration: 0.3),
                            .scale(to: 1, duration: 0.3)]))
    }
    
    func firework() {
        let emitterNode = SKEmitterNode(fileNamed: "VictoryParticle.sks")
        self.addChild(emitterNode!)
        self.run(.fadeOut(withDuration: 1.0))
        self.run(.wait(forDuration: 1)){
            self.removeAllChildren()
            self.removeFromParent()
        }
    }
    
    func tintToRed() {
        self.run(.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.3))
    }
}
