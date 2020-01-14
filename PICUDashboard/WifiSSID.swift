//
//  WifiSSID.swift
//  PICUDashboard
//
//  Created by LurieLocalAdmin on 1/8/20.
//  Copyright © 2020 Lurie Children's Hospital. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation

func getWiFiSsid() -> String? {
    var ssid: String?
    
    /*
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                break
            }
        }
    }
    */
    return ssid
}
