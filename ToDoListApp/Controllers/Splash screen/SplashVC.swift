//
//  SplashVC.swift
//  ToDoListApp
//
//  Created by Robert Loo on 11/07/24.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var btnGetStartedOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleToBar(title: "Just Do It", isLargeDisplayEnable: true, isNormalTitle: true)
    }
    
    @IBAction func btnGetStarted(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ToDoListVC") as! ToDoListVC
        // Try to avoid force casting like this,  it may crash the application when a simple warning that something went wrong could be enough.
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
