//
//  BaseViewController.swift
//  VirtualSPF
//
//  Created by Bretty White on 10/2/17.
//  Copyright © 2017 Bretty White. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationBar.barTintColor = UIColor(cgColor: UIColor(rgba: "#ffff66").cgColor)
        self.title = VSPFConstants.Name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
