//
//  GameScene.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import SpriteKit
import GameplayKit

protocol TransitionDelegate: SKSceneDelegate {
    func goToResultScreen(isVictory:Bool)
    func goToGameScreen()
}

class GameScene: SKScene {
    
    private var levelLabel: SKLabelNode!
    private var gameItems = [GameItem]()
    private var startButton: SKSpriteNode!
    
    private var game: Game?
    
    deinit {
        print("\n THE SCENE \((type(of: self))) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
    
    override func didMove(to view: SKView) {
        let currentLevel = UserDefaults.standard.integer(forKey: "Level")
        levelLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        levelLabel.alpha = 0.0
        levelLabel.run(SKAction.fadeIn(withDuration: 1.0))
        levelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 120)
        levelLabel.fontColor = .black
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.fontSize = 78
        self.addChild(levelLabel)
        
        startButton = SKSpriteNode(imageNamed: "start")
        startButton.alpha = 0.0
        startButton.run(SKAction.fadeIn(withDuration: 1.0))
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY+100)
        startButton.size = CGSize(width: 250, height: 200)
        startButton.name = "start"
        self.addChild(startButton)
        
        backgroundColor = .systemBackground
        game = Game(level: currentLevel)
        guard let game = game else { return }
        
        let matrix = Int.isqrt(game.elements)
        
        if let grid = Grid(blockSize: 90.0, rows:matrix, cols:matrix) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
            for i in 0..<game.elements {
                let emojiName:String! = Emoji.allCases.randomElement()?.rawValue
                let item = GameItem(with: emojiName, index: game.playlist[i],size: CGSize(width: grid.blockSize-1, height: grid.blockSize-1))
                item.alpha = 0.0
                var row = 0
                var col = 0
                var check = true
                repeat{
                    check = false
                    row = Int.random(in: 0..<matrix)
                    col = Int.random(in: 0..<matrix)
                    item.userData?.setValue(row, forKey: "gridRow")
                    item.userData?.setValue(col, forKey: "gridColumn")
                    gameItems.forEach{ node in
                        if node.userData!["gridRow"] as! Int == row,node.userData!["gridColumn"] as! Int == col{
                            check = true
                        }
                    }
                } while (check)
                gameItems.append(item)
                gameItems[i].position = grid.gridPosition(row: row, col: col)
                grid.addChild(gameItems[i])
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        if let touchedNode = self.atPoint(touchLocation) as? GameItem {
            guard let game = game else {
                print("game object is nil")
                return
            }
            let value = touchedNode.userData!["value"] as! Int
            if value == game.playlist[game.numberOfTaps] {
                touchedNode.firework()
                if game.numberOfTaps == game.playlist.count-1 {
                    sendResult(is: true)
                }
                game.numberOfTaps += 1
            } else{
                touchedNode.tintToRed()
                sendResult(is: false)
            }
        }
        guard let touchedNode = self.atPoint(touchLocation) as? SKSpriteNode else { return }
        if touchedNode.name == "start"{
            print("start")
            isUserInteractionEnabled = false
            guard let game = game else { return }
            startButton.removeFromParent()
            let matrix = Int.isqrt(game.elements)
            showItems(gameItems,matrix:matrix)
            self.run(.wait(forDuration: 1.5), completion: {
                self.animateItems(self.gameItems)
            })
        }
    }
    
    //MARK: Game logic functions
    func sendResult(is result:Bool) {
        self.run(.wait(forDuration: 1.5), completion: {
            guard let delegate = self.delegate else { return }
            self.view?.presentScene(nil)
            (delegate as! TransitionDelegate).goToResultScreen(isVictory: result)
            return
        })
    }
    
    func animateItems(_ items: [GameItem]) {
        var actions = [SKAction]()
        items.forEach { item in
            actions.append(.wait(forDuration: 1))
            actions.append(.run {
                item.pulse()
                print(item.userData!["value"] as! Int)
            })
        }
        actions.append(.run {
            self.isUserInteractionEnabled = true
        })
        run(.sequence(actions))
    }
    
    func showItems(_ items: [GameItem],matrix: Int) {
        var actions = [SKAction]()
        for i in 0..<matrix {
            for j in 0..<matrix {
                _ = items.first(where: { item in
                    if (item.userData!["gridRow"] as! Int) == i,(item.userData!["gridColumn"] as! Int) == j {
                        actions.append(SKAction.wait(forDuration: 0.3))
                        actions.append(SKAction.run{
                            item.run(SKAction.fadeIn(withDuration: 0.6))
                        })
                        return true
                    }
                    return false
                })
            }
        }
        run(.sequence(actions))
    }
}
