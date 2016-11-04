//
//  info.swift
//  VirtualSPF
//
//  Created by brettywhite on 7/26/15.
//  Copyright (c) 2015 brettywhite. All rights reserved.
//

import UIKit

class info: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        self.navigationItem.title = "Virtual SPF"
        self.navigationController!.navigationBar.barTintColor = UIColor.yellow
        
        //call function
        setLabel()
    }
    
    func setLabel(){
        
        // grab version number (This is set in the "General" section)
        let version:String = self.appVersion()
        
        // build the string
        let versionString: String = "Version: \(version)"
        
        // set the text
        versionLabel?.text = versionString
        
        // set main text
        descLabel?.text="vSPF was made out of necessity to assist me in choosing the best times to go outside to exercise. \n\nI figured other people might it useful as well, so I put it on the App Store. \n\nIt is not meant to replace or be used as medical advice. Please see your doctor for information specific to you. Use at your own risk. \n\nLocation is only used to access weather information from the EPA's Envirofacts Data Service API. Location is converted to a ZIP code, and used to grab the UV Index. \n\nEnjoy!"
    }
    
    func appVersion() -> String {
        
        // this is what actually grabs the version number
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
    }

}
