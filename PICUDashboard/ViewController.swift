//
//  ViewController.swift
//  PICUDashboard
//
//  Created by LurieLocalAdmin on 7/23/19.
//  Copyright © 2019 Lurie Children's Hospital. All rights reserved.
//

import UIKit
import WebKit
//import CoreLocation //for wifi SSID
import Foundation
//import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView!
    var webViewLoaded: Bool=false
    
    private var usersBrightness = UIScreen.main.brightness
    private var willEnterForegroundWasCalled = false
    private var viewWillDisappearWasCalled = false
    
    //var locationManager = CLLocationManager() // for wifi SSID
    
    var timer = Timer()
    
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
        
        //this will adjust the screen to fit full screen
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(),
            metrics: nil, views: ["v0":webView!]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView!]))
 
         
    }
    
    func TouchScreen(){
        let pointOnTheScreen = CGPoint(x: 50, y: 50)
        view.hitTest(pointOnTheScreen, with: nil)
        print("screen touched")
    }
    /*
    func updateWiFi() {
        let arr = currentSSIDs()
        print(arr)

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            updateWiFi()
        }
    }
    
    func currentSSIDs() -> [String] {

        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }

        return interfaceNames.compactMap { name in
          
            print(name)

            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {

                return nil

            }

            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {

                return nil

            }

            return ssid
        }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        print("isIdleTimerDisabled viewDidLoad: \(UIApplication.shared.isIdleTimerDisabled)")
        print("viewDidLoad kicked off")
        
        //get wifi ssid
        /*
        let wifissid: String?
        wifissid = getWiFiSsid()
        print("WIFI SSID:\(String(describing: wifissid))")
        */
        /*
        if #available(iOS 13.0, *) {

            let status = CLLocationManager.authorizationStatus()

            if status == .authorizedWhenInUse {

                updateWiFi()

            } else {

                locationManager.delegate = self

                locationManager.requestWhenInUseAuthorization()

            }

        } else {

            updateWiFi()

        }
        */
        
        usersBrightness = UIScreen.main.brightness
        
        
        
        DispatchQueue.main.async(execute: {
            /* Do UI work here */
            print("isIdleTimerDisabled viewDidLoad in Queue: \(UIApplication.shared.isIdleTimerDisabled)")
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
 
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            /*
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            */
        })

        
        setupWebView()
        
        //UIAlertAction('Before Loading View')
        loadWebVew("https://picudash.luriechildrens.org")
        
        //This will monitor network connectivity and then refresh view once it's back up.
        Monitor().startMonitoring { [weak self] connection, reachable in
            guard let strongSelf = self else { return }
            strongSelf.doSomething(connection, reachable: reachable)
        }
        
        //code that reloads website
            
        //testing timer logic
        timer = Timer.scheduledTimer(timeInterval: 45, target: self, selector: #selector(ViewController.doStuff), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ViewController.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
        
        
        /*
        //check if brightness changed
        let noteCenter = NotificationCenter.default
        noteCenter.addObserver(self,
                               selector: #selector(brightnessDidChange),
                               name: UIScreen.brightnessDidChangeNotification,
                               object: nil)
        */
    }
    
    @objc func doStuff() {
       // perform any action you wish to
       //print("User inactive for more than 30 seconds .")
        
        //self.webView.reload()
        TouchScreen() //for auto touch function
        let url = webView.url?.absoluteURL //get url
        if url?.absoluteString.range(of: "Dashboard") != nil {
            //print("Current URL in doStuff: \(String(describing: url))")
            webView?.reload()
        }
       //timer.invalidate()
    }
    @objc func resetTimer() {
       timer.invalidate()
       timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.doStuff), userInfo: nil, repeats: true)
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
    
    func loadWebVew(_ loadURL: String) {
        
        webViewLoaded = true
        //UIScreen.main.brightness = CGFloat(1.0)
        
        //setupWebView()
        
        // Do any additional setup after loading the view.
        let url = URL(string: loadURL)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true // true if you want to allow back and forward geatures
        
        
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
        print("manual refresh called")
        let url = webView.url?.absoluteURL
        print("Current URL \(String(describing: url))")
        webView?.reload()
        sender.endRefreshing()
    }
    
    //This is triggered when network monitors and checks condition
    private func doSomething(_ connection: Connection, reachable: Reachable) {
        print("Current Connection : \(connection) Is reachable: \(reachable)")
        
        let reach = reachable == Reachable.yes ? "On" : "Off"

        DispatchQueue.main.async {
            //print("ViewLoaded: \(self.webViewLoaded)")

            
            if reach == "Off" {
                self.performSegue(withIdentifier: "NetView", sender: nil)
                
                //print("isIdleTimerDisabled when wifi not reachable: \(UIApplication.shared.isIdleTimerDisabled)")
                
            } else {
                self.dismiss(animated: true, completion: nil)
                //print("isIdleTimerDisabled when wifi is reachable: \(UIApplication.shared.isIdleTimerDisabled)")
                /*
                if(self.webViewLoaded){
                    self.webView.reload()
                }else{
                    self.setupWebView()
                    self.loadWebVew()
                }
 */
                //self.webView.reload() //original working refresh view
                //self.webView?.reload()
                
                let url = self.webView.url?.absoluteURL //get url
                if url?.absoluteString.range(of: "Dashboard") != nil {
                    print("Reconnected to wifi reloading webview: \(String(describing: url))")
                    self.webView.reload()
                }else{
                    //print("Connected on: \(String(describing: connection))")
                    //self.webView.reload()
                    
                    if (url == nil){
                        self.loadWebVew("https://picudash.luriechildrens.org")
                    }
                    
                }
            }
        }
    }
}



