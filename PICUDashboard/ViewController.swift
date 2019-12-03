//
//  ViewController.swift
//  PICUDashboard
//
//  Created by LurieLocalAdmin on 7/23/19.
//  Copyright © 2019 Lurie Children's Hospital. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView!
    var webViewLoaded: Bool=false
    
    private var usersBrightness = UIScreen.main.brightness
    private var willEnterForegroundWasCalled = false
    private var viewWillDisappearWasCalled = false
    
    //override func loadView() {
    //    webView = WKWebView()
    //    webView.navigationDelegate = self
    //    view = webView
    //}
    
    /*
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
             scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    */
    
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.ignoresViewportScaleLimits = false
        
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
        
        print("viewDidLoad kicked off")
        usersBrightness = UIScreen.main.brightness
        
        DispatchQueue.main.async(execute: {
            /* Do UI work here */
            
            
 NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
 
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            /*
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            */
        })

        
        setupWebView()
        
        //UIAlertAction('Before Loading View')
        loadWebVew()
        
        /*
        Monitor().startMonitoring { [weak self] connection, reachable in
            guard let strongSelf = self else { return }
            strongSelf.doSomething(connection, reachable: reachable)
        }
        */
        
        /*
        //check if brightness changed
        let noteCenter = NotificationCenter.default
        noteCenter.addObserver(self,
                               selector: #selector(brightnessDidChange),
                               name: UIScreen.brightnessDidChangeNotification,
                               object: nil)
        */
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
        UIScreen.main.brightness = CGFloat(1.0)
        //scrollView.panGestureRecognizer.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        usersBrightness = UIScreen.main.brightness
        UIScreen.main.animateBrightness(to: 1, duration: 0.6)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewWillDisappearWasCalled = true
        UIScreen.main.animateBrightness(to: usersBrightness, duration: 0.3)
    }

    @objc private func applicationWillResignActive() {
        UIScreen.main.animateBrightness(to: usersBrightness, duration: 0.3)
    }

    @objc private func applicationWillEnterForeground() {
        willEnterForegroundWasCalled = true
        usersBrightness = UIScreen.main.brightness
        UIScreen.main.animateBrightness(to: 1, duration: 0.6)
    }

    @objc private func applicationDidBecomeActive() {
        // When the app enters the foreground again because the user closed notification
        // or control center then `UIApplicationWillEnterForeground` is not called, necessitating
        // also listening to `UIApplicationDidBecomeActive`.

        // This guard ensures the brightness is not increased when the app is opened from the home
        // screen, the multitasker, etc., and also when the view controller is dismissing, which can
        // occur if the user closes the view control quickly after closing notification or control center
        guard !willEnterForegroundWasCalled, !viewWillDisappearWasCalled else {
            willEnterForegroundWasCalled = false
            return
        }
        
        usersBrightness = UIScreen.main.brightness
        UIScreen.main.animateBrightness(to: 1, duration: 0.6)
    }
    
    @objc func brightnessDidChange() {
        print("From brightnessDidChange Event \(UIScreen.main.brightness)")
        UIScreen.main.brightness = CGFloat(1.0)
    }
    
    func loadWebVew() {
        
        webViewLoaded = true
        //UIScreen.main.brightness = CGFloat(1.0)
        
        //setupWebView()
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://picudash.luriechildrens.org/")!
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
        webView.scrollView.delegate = self
        
        print("IsLoading: \(self.webView.isLoading)")
        //print(WKWebView.)
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
    
    private func doSomething(_ connection: Connection, reachable: Reachable) {
        print("Current Connection : \(connection) Is reachable: \(reachable)")
        
        

        let reach = reachable == Reachable.yes ? "On" : "Off"

        DispatchQueue.main.async {
            print("ViewLoaded: \(self.webViewLoaded)")

            
            if reach == "Off" {
                self.performSegue(withIdentifier: "NetView", sender: nil)
                //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false //doesn't work
            } else {
                self.dismiss(animated: true, completion: nil)
                
                /*
                if(self.webViewLoaded){
                    self.webView.reload()
                }else{
                    self.setupWebView()
                    self.loadWebVew()
                }
 */
                self.webView.reload()
            }
        }
    }
}



