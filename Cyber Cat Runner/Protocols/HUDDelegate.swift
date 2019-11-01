//
//  HUDDelegate.swift
//  Cyber Cat Runner
//
//  Created by Tommy Andersson on 2019-04-21.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import Foundation

protocol HUDDelegate {
    
    func updateCoinLabel(coins: Int)
    func addSuperCoin(index: Int)
    
}
