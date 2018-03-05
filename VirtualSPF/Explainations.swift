//
//  Explainations.swift
//  VirtualSPF
//
//  Created by Bretty White on 3/5/18.
//  Copyright © 2018 Bretty White. All rights reserved.
//

import Foundation

/*
 *   This project was not meant to be fancy. Since the information is rarely updated and there is so little of
 *   it, we will just manually set it in the controller itself. No reason to make a network request for it.
 *
 *   Information gathered from http://www2.epa.gov/sunwise/uv-index-scale
 */
struct VSPFExplainations {

    // Descriptions
    static let ElevenDisc = "A UV Index reading of 11 or more means extreme risk of harm from unprotected sun exposure. Take all precautions because unprotected skin and eyes can burn in minutes."
    static let EightDisc = "A UV Index reading of 8 to 10 means very high risk of harm from unprotected sun exposure. Take extra precautions because unprotected skin and eyes will be damaged and can burn quickly."
    static let SixDisc = "A UV Index reading of 6 to 7 means high risk of harm from unprotected sun exposure. Protection against skin and eye damage is needed."
    static let ThreeDisc = "A UV Index reading of 3 to 5 means moderate risk of harm from unprotected sun exposure."
    static let ZeroDisc = "A UV Index reading of 0 to 2 means low danger from the sun's UV rays for the average person."

    // Explainations
    static let ElevenExp = "•Try to avoid sun exposure between 10 a.m. and 4 p.m. \n\n•If outdoors, seek shade and wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
    static let EightExp = "•Minimize sun exposure between 10 a.m. and 4 p.m. \n\n•If outdoors, seek shade and wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
    static let SixExp = "•Reduce time in the sun between 10 a.m. and 4 p.m. \n\n•If outdoors, seek shade and wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
    static let ThreeExp = "•Stay in shade near midday when the sun is strongest. \n\n•If outdoors, wear protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. \n\n•Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."
    static let ZeroExp =  "•Wear sunglasses on bright days.\n\n•If you burn easily, cover up and use broad spectrum SPF 30+ sunscreen. \n\n•Watch out for bright surfaces, like sand, water and snow, which reflect UV and increase exposure."

}
