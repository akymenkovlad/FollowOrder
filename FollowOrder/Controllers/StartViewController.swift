//
//  StartViewController.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToWebView), name: Notification.Name("Track"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        guard UserDefaults.standard.value(forKey: "track") == nil else {
            moveToWebView()
            return
        }
    }
    
    @objc private func moveToWebView() {
        print("nothing")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        print("go to web screen")
        NotificationCenter.default.removeObserver(self, name: Notification.Name("Track"), object: nil)
        self.present(vc, animated: true)
    }
    
    @IBAction func startGame(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        print("go to game screen")
        self.present(vc, animated: true)
    }
    
}
