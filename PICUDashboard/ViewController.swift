//
//  ViewController.swift
//  PICUDashboard
//
//  Created by LurieLocalAdmin on 7/23/19.
//  Copyright © 2019 Lurie Children's Hospital. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    //override func loadView() {
    //    webView = WKWebView()
    //    webView.navigationDelegate = self
    //    view = webView
    //}
    
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame:.zero , configuration: webConfiguration)
        webView.uiDelegate = self
        //view = webView
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        // Do any additional setup after loading the view.
        let url = URL(string: "http://lc-ofcwebapp01/Home/Index")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.black
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.navigationDelegate = self
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
    
}

