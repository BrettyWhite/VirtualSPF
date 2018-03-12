//
//  colorChooser.swift
//  VirtualSPF
//
//  Created by Mia da Kitty on 3/11/18.
//  Copyright © 2018 Brett Mcisaac. All rights reserved.
//

import UIKit

class ColorChooser {

  class func decideColor(_ uvint: Int) -> UIColor {
        var strokeColor: UIColor
        strokeColor = Colors.White

        if uvint >= 11 {
            strokeColor = Colors.Red
        } else if uvint >= 8 {
            strokeColor = Colors.Orange
        } else if uvint >= 6 {
            strokeColor = Colors.Yellow
        } else if uvint >= 3 {
            strokeColor = Colors.LightYellow
        } else if uvint >= 0 {
            strokeColor = Colors.Green
        }

        return strokeColor
    }

}
