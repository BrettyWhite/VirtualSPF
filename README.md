# Virtual SPF [![Build Status](https://travis-ci.org/brettywhite/VirtualSPF.svg?branch=master)](https://travis-ci.org/brettywhite/VirtualSPF)  [![CC 4.0][license-image]][license-url]

<p align="center">
<img src="http://buhzhyve.com/vspf.png" width="200">
</p>

## Overview

Uses Swift 4 (working on Xcode 9)

I created this project as a way to 1. play with Swift and 2. I wanted to build it for my own use. vSPF uses Dark Sky's API and GPS to display the UV Index for the day, and gives a brief explaination of things to do to help mitigate UV exposure. Dark Sky lets you have 1000 calls a day for free [Dark Sky API](https://darksky.net/dev)

I wanted to publish this to potentially help out people getting into iOS and Swift development. I am extremely thankful for the other devs who published their work for me to learn, so consider this a pay-it-forward, I guess. 

Why might this interest you????

* Uses common libraries, like [AlamoFire](https://github.com/Alamofire/Alamofire)
* Simple prototype cells are used (I'll admit they were confusing when I learned them)
* JSON response handeling with [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* Use of GPS (CLLocationManager) to grab GPS coordinates to get the UV Index for where you are
* Swift is the hip thing to do nowadays, so I'm told
* You are interested in not being sunburned
* Why not?

## Installation

#### Step 1: 
As this project does use [CocoaPods](https://cocoapods.org/), you will need to run this from the project directory. I am assuming you already have CocoaPods installed on your computer:

```bash
$ pod install
```

If you are not familiar with CocoaPods yet, after running that command you will now open VirtualSPF.xcworkspace and not VirtualSPF.xcodeproj in Xcode

#### Step 2:
Once that is done, inside XCode, look for the Constants folder. In there you will see a file called `sampleEnvVars.swift`. You will need to make a new file called `envVars.swift` and copy the contents of the sample file into it - being careful to change the struct name to: `VSPFProtectedConstants`. This has been added to `.gitignore` already, and is the spot where you need to put your keys. 

#### Step 3: 

If you haven't done so already, go to the [Dark Sky API](https://darksky.net/dev) and sign up for your free key. Place that key in `envVars.swift`. At this point you can build the project.

## Support

As I did this as a first Swift Project, there may be things that could be done better than they are (unit tests, view stuff, etc. - I never claimed to be perfect). I will try to update when possible and respond to any issues. 

[license-url]: http://www.wtfpl.net
[license-image]: https://img.shields.io/badge/License-WTFPL%202.0-lightgrey.svg?style=flat-square
