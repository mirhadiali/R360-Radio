//
//  MenuViewController.swift
//  Radio 360
//
//  Created by Hadi Ali on 23/06/2021.
//

import UIKit

protocol MenuViewControllerDelegate: NSObjectProtocol {
    func didSelect(_ link: String)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    weak var delegate: MenuViewControllerDelegate?
    
    let controllers: [[String: Any?]] = [
        ["title_en": "Home","link": nil],
        ["title_en": "Schedule", "link": Constants.Menu.schedule],
        ["title_en": "Podcast", "link": Constants.Menu.podcast],
        ["title_en": "Settings", "link": Constants.Menu.settings],
        ["title_en": "Contact Us", "link": Constants.Menu.contactUs]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = controllers[indexPath.row]["title_en"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        let item = controllers[indexPath.row]
        if let link = item["link"] as? String {
            delegate?.didSelect(link)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
