//
//  DarkModeAwareNavigationController.swift
//  Radio 360
//
//  Created by Hadi Ali on 23/06/2021.
//

import UIKit

class DarkModeAwareNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.updateBarTintColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateBarTintColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateBarTintColor()
    }
    
    private func updateBarTintColor() {
        if #available(iOS 13.0, *) {
            self.navigationBar.barStyle = UITraitCollection.current.userInterfaceStyle == .dark ? .blackTranslucent : .default
            //            self.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
        }
    }
}
