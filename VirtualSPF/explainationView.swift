//
//  explainationView.swift
//  VirtualSPF
//
//  Created by brettywhite on 7/26/15.
//  Copyright (c) 2015 brettywhite. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ExplainationView: UIViewController {

    // This value is what was set in the segue function in ViewController.swift
    var UVValue: String!

    //outlets
    @IBOutlet weak var uviLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var expLabel: UILabel?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Change title
        self.navigationItem.title = "Virtual SPF - Information"
        self.navigationController!.navigationBar.barTintColor = UIColor.yellow
        // call function to set the info
        self.initView()
        self.setScreenSize()
    }

    fileprivate func setScreenSize() {

        // play with adjusting sizing on different screens
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height

        if screenWidth <= 320 {
            expLabel!.font = UIFont(name: expLabel!.font.fontName, size: 10)
            descLabel!.font = UIFont(name: descLabel!.font.fontName, size: 10)
        }
    }
    /*
        This project was not meant to be fancy. Since the information is rarely updated and there is so little of
        it, we will just manually set it in the controller itself. No reason to make a network request for it.
    
        Information gathered from http://www2.epa.gov/sunwise/uv-index-scale on July 28, 2015
    */
    fileprivate func initView() {
        // convert to int
        let uvint: Int = Int(UVValue)!

        if uvint >= 11 {

            self.view.backgroundColor = UIColor(cgColor: UIColor(rgba: "#ff0000").cgColor)
            uviLabel?.text = UVValue
            descLabel?.text = "A UV Index reading of 11 or more means extreme risk of harm from unprotected sun exposure. Take all precautions because unprotected skin and eyes can burn in minutes."

            expLabel?.text = "•Try to avoid sun exposure between 10 a.m. and 4 p.m. \n\n•If outdoors, seek shade and wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."

        } else if uvint >= 8 {

            self.view.backgroundColor = UIColor(cgColor: UIColor(rgba: "#ff9900").cgColor)
            uviLabel?.text = UVValue
            descLabel?.text = "A UV Index reading of 8 to 10 means very high risk of harm from unprotected sun exposure. Take extra precautions because unprotected skin and eyes will be damaged and can burn quickly."
            expLabel?.text = "•Minimize sun exposure between 10 a.m. and 4 p.m. \n\n•If outdoors, seek shade and wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
        } else if uvint >= 6 {

            self.view.backgroundColor = UIColor(cgColor: UIColor(rgba: "#ffcc00").cgColor)
            uviLabel?.text = UVValue
            descLabel?.text = "A UV Index reading of 6 to 7 means high risk of harm from unprotected sun exposure. Protection against skin and eye damage is needed."
            expLabel?.text = "•Reduce time in the sun between 10 a.m. and 4 p.m. \n\n•If outdoors, seek shade and wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
        } else if uvint >= 3 {

            self.view.backgroundColor = UIColor(cgColor: UIColor(rgba: "#ffff66").cgColor)
            uviLabel?.text = UVValue
            descLabel?.text = "A UV Index reading of 3 to 5 means moderate risk of harm from unprotected sun exposure."
            expLabel?.text = "•Stay in shade near midday when the sun is strongest. \n\n•If outdoors, wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
        } else if uvint >= 0 {
            
            self.view.backgroundColor = UIColor(cgColor: UIColor(rgba: "#1cd61c").cgColor)
            uviLabel?.text = UVValue
            descLabel?.text = "A UV Index reading of 0 to 2 means low danger from the sun's UV rays for the average person."
            expLabel?.text = "•Wear sunglasses on bright days.\n\n•If you burn easily, cover up and use broad spectrum SPF 30+ sunscreen. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
        }
    }
}
