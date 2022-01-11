//
//  GameViewController.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import UIKit
import SpriteKit
import GameplayKit
import RealmSwift

class GameViewController: UIViewController {
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let level = Level(level: 1)
        try! self.realm.write {
            if self.realm.objects(Level.self).isEmpty{
                self.realm.add(level)
            }
        }
        showScene()
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    private func showScene(){
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.delegate = self as TransitionDelegate
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
//MARK: RoundDelegate
extension GameViewController: TransitionDelegate{
    func goToGameScreen() {
        showScene()
    }
    
    func goToResultScreen(isVictory:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.isVictory = isVictory
        print("go to result screen")
        self.present(vc, animated: true)
    }
}
