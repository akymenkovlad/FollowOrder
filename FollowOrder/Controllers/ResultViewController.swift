//
//  ResultViewController.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import UIKit
import Alamofire
import SpriteKit
import JGProgressHUD
import RealmSwift


class ResultViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    //MARK: UI elements
    var isVictory = false
    weak var delegate: TransitionDelegate?
    let realm = try! Realm()
    
    private let skView = SKView()
    private let spinner = JGProgressHUD(style: .dark)

    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        spinner.show(in: view)
        configureUI()
        if isVictory{
            fetchWish()
        }
        else{
            spinner.dismiss(animated: true)
            messageTextView.text = "Oooops"
            resultLabel.text = "Lose"
            messageTextView.isHidden = false
            playAgainButton.isHidden = false
            resultLabel.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if isVictory {
            let level = realm.objects(Level.self)
            if let level = level.first {
                try! realm.write {
                    level.level += 1
                }
            }
        }
    }
    private func configureUI(){
        skView.frame = view.bounds
        skView.backgroundColor = .clear
        playAgainButton.backgroundColor = .systemYellow
        playAgainButton.layer.cornerRadius = 10
        playAgainButton.layer.borderWidth = 1
        playAgainButton.layer.borderColor = UIColor.black.cgColor
        messageTextView.isHidden = true
        playAgainButton.isHidden = true
        resultLabel.isHidden = true
    }
    @objc func startNewRound(){
        
    }
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.goToGameScreen()
    }
    //MARK: Victory case functions
    private func fetchWish(){
        AF.request("http://yerkee.com/api/fortune")
            .validate()
            .responseDecodable(of: Wish.self) { [weak self] response in
                guard let self = self else{return}
                self.spinner.dismiss(animated: true)
                self.resultLabel.text = "Victory"
                guard let wish = response.value else {
                    self.messageTextView.text = "You won!!!"
                    self.showWinAnimation()
                    return
                }
                print(wish.fortune!)
                self.messageTextView.text = wish.fortune
                self.playAgainButton.isHidden = false
                self.messageTextView.isHidden = false
                self.resultLabel.isHidden = false
                self.showWinAnimation()
            }
    }
    private func showWinAnimation(){
        if isVictory{
            view.addSubview(skView)
            let scene: SKScene = SKScene(size: view.bounds.size)
            scene.scaleMode = .aspectFit
            scene.backgroundColor = .clear
            let en = SKEmitterNode(fileNamed: "VictoryParticle.sks")
            let en1 = SKEmitterNode(fileNamed: "VictoryParticle.sks")
            let en2 = SKEmitterNode(fileNamed: "VictoryParticle.sks")
            en?.position = CGPoint(x: 0, y: view.viewHeight)
            scene.addChild(en!)
            en1?.position = CGPoint(x: view.viewWidth, y: view.viewHeight)
            scene.addChild(en1!)
            en2?.position = CGPoint(x: view.viewWidth/2, y: view.viewHeight/2)
            scene.addChild(en2!)
            skView.presentScene(scene)
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: { [weak self] in
                self?.skView.removeFromSuperview()
            })
        }
    }
}
