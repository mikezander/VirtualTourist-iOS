//
//  GCD.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/29/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{

    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
        }
    }
}
