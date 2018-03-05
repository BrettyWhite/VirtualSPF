//
//  info.swift
//  VirtualSPF
//
//  Created by brettywhite on 7/26/15.
//  Copyright (c) 2017 brettywhite. All rights reserved.
//

import UIKit

class Info: BaseViewController {

    @IBOutlet weak var versionLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?

    class Info {
        init () {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }

    func setLabel() {

        let version: String = self.appVersion()
        let versionString: String = "Version: \(version)"
        versionLabel?.text = versionString
        descLabel?.text = VSPFConstants.InfoText
    }

    func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
