//
//  GlobalVariables.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 17/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class GlobalVariables: NSObject {
    static let shared: GlobalVariables = GlobalVariables()
    
    var user_master_id = String()
    var Service_amount = String()
    var main_catID = String()
    var sub_catID = String()
    var catServicetID = String()
    var viewPage = String()
    var order_id = String()
    var reuseID = String()
    var Advanceamount = String()
    var payableAmount = String()
    var rowCount = Int()
    var serviceCount = String()
    var serviceOrderId = String()
    var walletAmount = String()
    var serviceId = String()
    var addressArrayCount = [Int]()


}
