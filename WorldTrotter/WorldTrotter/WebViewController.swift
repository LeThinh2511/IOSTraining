//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by ThinhLe on 3/3/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController
{
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
