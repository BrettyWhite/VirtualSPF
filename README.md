
## Overview

Uses Swift 3

I created this project as a way to 1. play with Swift and 2. I wanted to build it for my own use. vSPF uses the EPA's Envirofacts API and GPS to display the UV Index for the day, and gives a brief explaination of things to do to help mitigate UV exposure. Kudos to the EPA for this freely available weather API.

I wanted to publish this to potentially help out people getting into iOS and Swift development. I am extremely thankful for the other devs who published their work for me to learn, so consider this a pay-it-forward, I guess. 

Why might this interest you????

* Uses common libraries, like [AlamoFire](https://github.com/Alamofire/Alamofire)
* Simple prototype cells are used (I'll admit they were confusing when I learned them)
* JSON response handeling with [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* Use of GPS (CLLocationManager) to grab GPS coordinates and convert them to a ZIP code to get the UV Index for where you are
* Swift is the hip thing to do nowadays, so I'm told
* You are interested in not being sunburned
* Why not?

## Installation

As this project does use [CocoaPods](https://cocoapods.org/), you will need to run this from the project directory. I am assuming you already have CocoaPods installed on your computer:

```bash
$ pod install
```

If you are not familiar with CocoaPods yet, after running that command you will now open VirtualSPF.xcworkspace and not VirtualSPF.xcodeproj in Xcode

## Support

As I did this as a first Swift Project, there may be things that could be done better than they are. I will try to update when possible and respond to any issues. 

## License

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
