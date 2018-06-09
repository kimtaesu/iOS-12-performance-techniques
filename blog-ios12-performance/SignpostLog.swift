//
//  SignpostLog.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/9/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation
import os

final class SignpostLog {
    
    static let pointsOfInterest = OSLog(subsystem: "com.captech.blog-ios12-performance", category: OSLog.Category.pointsOfInterest)
}
