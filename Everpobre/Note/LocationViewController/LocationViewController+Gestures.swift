//
//  LocationViewController+Gestures.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 21/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - Gestures
extension LocationViewController {
    
    // Swipe Down View: Close keyboard/datepicker
    @objc func closeKeyboard() {
        if (search.isFirstResponder) {
            search.resignFirstResponder()
        }
    }
}
