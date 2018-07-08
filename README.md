[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=5a144ecae2978a000134c466&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/5a144ecae2978a000134c466/build/latest?branch=master)
<p><img align="left" width="100" height="100" src="https://raw.githubusercontent.com/lscardinali/PontoConcrete-iOS/develop/PontoConcrete/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76%402x.png"></p>
<h1>PontoConcrete</h1> 
<p>PontoConcrete is an iOS app that improves the way you check-in at Concrete</p>

<p align="center">
  <img width="460" height="300" src="https://raw.githubusercontent.com/lscardinali/PontoConcrete-iOS/develop/PontoConcrete/Assets.xcassets/tutorial.imageset/tutorial%402x.png">
</p>

## Start

We use mint to manage Swift tools dependency. To install it see on [[mint repository](https://github.com/yonaskolb/Mint)]. After installing it, run ```mint bootstrap``` to install all dependencies.

After cloning this repo, you should run ```mint run carthage carthage bootstrap``` to begin working on the project

## Xcode Server Bots

Tab `Trigger`
`Pre-Integration Scripts`
```
#!/bin/sh
export LC_ALL="en_US.UTF-8"
PATH=$PATH:/usr/local/bin
cd "${XCS_PRIMARY_REPO_DIR}"
gem install bundler --user-install executable-hooks
bundler install
pod install
```

## Fastlane
```
fastlane scan
fastlane lint
fastlane slather
```
