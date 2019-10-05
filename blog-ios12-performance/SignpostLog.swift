//
//  SignpostLog.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/9/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import os

struct SignpostLog {
    
    static let cellForRow = OSLog(subsystem: "com.captech.blog-ios12-performance", category: "cellForRow")
    static let networking = OSLog(subsystem: "com.captech.blog-ios12-performance", category: "networking")
    static let pointsOfInterest = OSLog(subsystem: "com.captech.blog-ios12-performance", category: OSLog.Category.pointsOfInterest)
    
}
