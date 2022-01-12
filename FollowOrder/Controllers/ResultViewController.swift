//
//  ResultViewController.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import UIKit
import SpriteKit


class ResultViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    //MARK: UI elements
    var isVictory = false
    weak var delegate: TransitionDelegate?
    
    private let skView = SKView()
    private lazy var spinner: UIActivityIndicatorView = {
        let loginSpinner = UIActivityIndicatorView(style: .medium)
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()

    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        if isVictory {
            view.addSubview(spinner)
            spinner.startAnimating()
            spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            fetchWish()
        } else {
            messageTextView.text = "Oooops"
            resultLabel.text = "Lose"
            messageTextView.isHidden = false
            playAgainButton.isHidden = false
            resultLabel.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if isVictory {
            let defaults = UserDefaults.standard
            let currentLvl = defaults.integer(forKey: "Level")
            defaults.set(currentLvl+1, forKey: "Level")
        }
    }
    
    private func configureUI() {
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
    
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.goToGameScreen()
    }
    
    //MARK: Victory case functions
    private func fetchWish() {
        guard let url = URL(string: "http://yerkee.com/api/fortune") else { fatalError("Invalid URL") }

        // Create the network manager
        let networkManager = NetworkManager()

        // Request data from the backend
        networkManager.request(fromURL: url) { [weak self] (result: Result<Wish, Error>) in
            guard let self = self else{return}
            switch result {
            case .success(let wish):
                debugPrint("We got a successful wish result: \(wish).")
                self.messageTextView.text = wish.fortune
            case .failure(let error):
                debugPrint("We got a failure trying to get the data. The error we got was: \(error.localizedDescription)")
                self.messageTextView.text = "You won!!!"
            }
            self.spinner.stopAnimating()
            self.resultLabel.text = "Victory"
            self.playAgainButton.isHidden = false
            self.messageTextView.isHidden = false
            self.resultLabel.isHidden = false
            self.showWinAnimation()
         }
    }
    
    private func showWinAnimation() {
        if isVictory {
            view.addSubview(skView)
            let scene: SKScene = SKScene(size: view.bounds.size)
            scene.scaleMode = .aspectFit
            scene.backgroundColor = .clear
            let emitterNode1 = SKEmitterNode(fileNamed: "VictoryParticle.sks")!
            let emitterNode2 = SKEmitterNode(fileNamed: "VictoryParticle.sks")!
            let emitterNode3 = SKEmitterNode(fileNamed: "VictoryParticle.sks")!
            emitterNode1.position = CGPoint(x: 0, y: view.viewHeight)
            emitterNode2.position = CGPoint(x: view.viewWidth, y: view.viewHeight)
            emitterNode3.position = CGPoint(x: view.viewWidth/2, y: view.viewHeight/2)
            scene.addChild(emitterNode1)
            scene.addChild(emitterNode2)
            scene.addChild(emitterNode3)
            skView.presentScene(scene)
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: { [weak self] in
                self?.skView.removeFromSuperview()
            })
        }
    }
}
