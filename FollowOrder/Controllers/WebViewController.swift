//
//  WebViewController.swift
//  FollowOrder
//
//  Created by Valados on 13.01.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate{

    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let url = UserDefaults.standard.value(forKey: "track") as? String {
                let myURL = URL(string:url)
                let myRequest = URLRequest(url: myURL!)
                webView.load(myRequest)
            }
            webView.frame = view.bounds
        }
    
}
