//
//  explainationView.swift
//  VirtualSPF
//
//  Created by brettywhite on 7/26/15.
//  Copyright (c) 2017 brettywhite. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ExplainationView: BaseViewController {

    var UVValue: String!

    @IBOutlet weak var uviLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var expLabel: UILabel?

    class ExplainationView {
        init () {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
       // self.setScreenSize()
    }

    func setScreenSize() {

        // play with adjusting sizing on different screens
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height

        if screenWidth <= 320 {
            expLabel!.font = UIFont(name: expLabel!.font.fontName, size: 10)
            descLabel!.font = UIFont(name: descLabel!.font.fontName, size: 10)
        }
    }

    func initView() {

        let uvint: Int = Int(UVValue)!
        if uvint >= 11 {

            self.view.backgroundColor = Colors.Red
            uviLabel?.text = UVValue
            descLabel?.text = VSPFExplainations.ElevenDisc
            expLabel?.text = VSPFExplainations.ElevenExp
        } else if uvint >= 8 {

            self.view.backgroundColor = Colors.Orange
            uviLabel?.text = UVValue
            descLabel?.text = VSPFExplainations.EightDisc
            expLabel?.text = VSPFExplainations.EightExp
        } else if uvint >= 6 {

            self.view.backgroundColor = Colors.Yellow
            uviLabel?.text = UVValue
            descLabel?.text = VSPFExplainations.SixDisc
            expLabel?.text = VSPFExplainations.SixExp
        } else if uvint >= 3 {

            self.view.backgroundColor = Colors.LightYellow
            uviLabel?.text = UVValue
            descLabel?.text = VSPFExplainations.ThreeDisc
            expLabel?.text = VSPFExplainations.ThreeExp
        } else if uvint >= 0 {

            self.view.backgroundColor = Colors.Green
            uviLabel?.text = UVValue
            descLabel?.text = VSPFExplainations.ZeroDisc
            expLabel?.text = VSPFExplainations.ZeroExp
        }
    }
}
