//
//  GameViewController.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: ["Level": 1])
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
    
    private func showScene() {
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.frame.size)
            let transition = SKTransition.fade(withDuration: 1.0)
            scene.scaleMode = .aspectFill
            scene.delegate = self as TransitionDelegate
            view.presentScene(scene, transition: transition)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
//MARK: RoundDelegate
extension GameViewController: TransitionDelegate {
    
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
