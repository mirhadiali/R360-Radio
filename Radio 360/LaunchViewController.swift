//
//  LaunchViewController.swift
//  Radio 360
//
//  Created by Hadi Ali on 22/03/2023.
//

import UIKit

class LaunchViewController: UIViewController {
    var timer: Timer!

    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(navigateToHome), userInfo: nil, repeats: true)
    }
    
    deinit {
       
    }
    
    @objc func navigateToHome() {
        count += 1
        print("hello \(count)")
        // Do any additional setup after loading the view.
        if count >= 3 {
            timer.invalidate()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DarkModeAwareNavigationController") as! UINavigationController
            
            if #available(iOS 13.0, *) {
                UIApplication.shared.windows.first?.rootViewController = controller
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            } else {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = controller
            }
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            if let navigationController = appDelegate?.window?.rootViewController as? UINavigationController {
                appDelegate?.viewController = navigationController.viewControllers.first as? ViewController
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
