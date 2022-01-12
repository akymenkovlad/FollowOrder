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

class gameItem: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "cool_emoji")
        super.init(texture: texture, color: .clear, size: CGSize(width: 75, height: 75))
    }
    init(with name:String,index: Int) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: CGSize(width: 75, height: 75))
        self.name = String(index+1)
        self.userData = ["value":(index+1)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pulse() {
        self.run(.sequence([.scale(to: 1.5, duration: 0.3),
                            .scale(to: 1, duration: 0.3)]))
    }
}

class GameScene: SKScene {
    
    private var levelLabel: SKLabelNode!
    private var gameItems = [gameItem]()
    
    private var game: Game?
    
    deinit {
        print("\n THE SCENE \((type(of: self))) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
    
    override func didMove(to view: SKView) {
        isUserInteractionEnabled = false
        let currentLevel = UserDefaults.standard.integer(forKey: "Level")
        scene?.backgroundColor = .systemBackground
        game = Game(level: currentLevel)
        if let game = game {
            for i in 0..<game.elements {
                let emojiName = Emoji.allCases.randomElement()?.rawValue
                let item = gameItem(with: emojiName!, index: i)
                gameItems.append(item)
                gameItems[i].position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                addChild(gameItems[i])
            }
        }
        levelLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        levelLabel.alpha = 0.0
        levelLabel.run(SKAction.fadeIn(withDuration: 1.0))
        levelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 120)
        levelLabel.fontColor = .black
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.fontSize = 78
        self.addChild(levelLabel)
        
        for item in gameItems {
            item.alpha = 0.0
            item.run(SKAction.fadeIn(withDuration: 1.0))
            moveToRandomPosition(item: item)
        }
        self.run(.wait(forDuration: 1.5), completion: { [weak self] in
            guard let self = self else { return }
            self.showNextItem()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if let name = touchedNode.name {
            for item in gameItems {
                if name == item.name {
                    item.pulse()
                    guard let game = game else{
                        print("game object is nil")
                        return
                    }
                    if game.readyForUser {
                        checkIfCorrect(item.userData!["value"] as! Int)
                    }
                }
            }
        }
    }
    
    //MARK: Game logic functions
    private func showNextItem() {
        guard let game = game else {
            print("game object is nil")
            return
        }
        if game.currentItem <= game.playlist.count-1 {
            let selectedItem = game.playlist[game.currentItem]
            switch selectedItem {
            case 1...game.elements:
                print(selectedItem)
                for item in gameItems {
                    if String(selectedItem) == item.name {
                        item.pulse()
                    }
                }
                break
            default:
                break
            }
            game.currentItem += 1
            self.run(.wait(forDuration: 1), completion: { [weak self] in
                guard let self = self else { return }
                self.showNextItem()
            })
        }
        else {
            game.readyForUser = true
            isUserInteractionEnabled = true
        }
    }
    
    func checkIfCorrect(_ button:Int) {
        print(button)
        guard let game = game else {
            print("game object is nil")
            return
        }
        if button == game.playlist[game.numberOfTaps] {
            if game.numberOfTaps == game.playlist.count-1 {
                self.run(.wait(forDuration: 0.5), completion: { [weak self] in
                    guard let self = self else { return }
                    guard let delegate = self.delegate else { return }
                    self.view?.presentScene(nil)
                    (delegate as! TransitionDelegate).goToResultScreen(isVictory: true)
                    return
                })
            }
            game.numberOfTaps += 1
        } else {
            self.run(.wait(forDuration: 0.5), completion: { [weak self] in
                guard let self = self else { return }
                guard let delegate = self.delegate else { return }
                self.view?.presentScene(nil)
                (delegate as! TransitionDelegate).goToResultScreen(isVictory: false)
                return
            })
        }
    }
    private func moveToRandomPosition(item: SKSpriteNode){
        print(self.frame.minX)
        print(self.frame.width)
        let itemWidth = item.size.width
        let itemHeigth = item.size.height
        var itemY = CGFloat.random(in: (self.frame.minY + itemHeigth+10)...(self.frame.maxY-120-itemHeigth))
        var itemX = CGFloat.random(in: (self.frame.minX + itemWidth+10)...(self.frame.maxX-10-itemWidth))
        var check = true
        //Check if gameItems are collided
        while check {
            check = false
            itemY = CGFloat.random(in: (self.frame.minY + itemHeigth+10)...(self.frame.maxY-120-itemHeigth))
            itemX = CGFloat.random(in: (self.frame.minX + itemWidth+10)...(self.frame.maxX-10-itemWidth))
            for btn in gameItems {
                if item.name != btn.name {
                    if abs(itemX - btn.position.x) <= itemWidth, abs(itemY - btn.position.y) <= itemHeigth{
                        print("Emojis collide")
                        print(btn.position.x)
                        print(itemX)
                        print(btn.position.y)
                        print(itemY)
                        check = true
                    }
                }
            }
        }
        item.position.y = itemY
        item.position.x = itemX
        print("Button \(String(describing: item.name)) cordinates x:\(item.position.x) y:\(item.position.y)")
    }
}
