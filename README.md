# FHS News iOS App

This is the repository for the source code of the iOS app for FHS News.

The FHS News App is an app that makes the distribution of school news easy. Most people have phones, so it makes it make sense to have school news as an app. This app also supports down to iOS 12.2 - this is really great, as we have to acknowledge that while most students here may have up-to-date devices, some are still on old devices, perhaps limited by financial situation or other reasons. iOS 12.2 supports A7+, basically every single 64bit iOS device. The jump to arm64 was forever ago with the iPhone 5S back in 2013, so I'm going to assume most people have at least this. Also for iOS 12.2+, we no longer have to embed libswift libraries in our app, benefitting app size.

This app is made lovingly in UIKit+Swift, and is open source, feel free to contribute!

Some note for future developers have been outlined, check `NoteForDevelopers.md`. If you have any questions regarding them, feel free to ask.



## NOTE: BEFORE RE-RELEASE, THESE TWO IMAGES:

So, the biggest note I should say before re-release is that two particular assets I have snabbed from some of my future projects. I'm involved in the jailbreak community, and those two assets are from there. The first thing, `SettingsSnoolieIconV2.png`, is from a theme I have yet to release that I have currently dubbed "Assonance". It is a theme, and *can* also be used for non-jailbroken devices. It is very obvious that this is a tribute/homage to the Settings icon Apple uses. This, currently, needs to be changed and removed from the app before we submit to Testflight or the iOS App Store, for obvious reasons. Read https://developer.apple.com/design/human-interface-guidelines/app-icons and you'll see the note "Don’t use replicas of Apple hardware products. Apple products are copyrighted and can’t be reproduced in your app icons.". I'm not completely 100% sold that this placeholder icon is a violation of copyright, as it is not an exact copy but rather a homage/reference; but I doubt Apple will accept that argument, if they see it, they'll reject. **Remove** this from the app before submitting. Don't worry, this is not really a big part of the app's development, I only use it as a placeholder image for some places in the app, so replacing won't really affect much and should be easy.

The other asset from my future project does not violate this rule. It is the current app icon used for this app. This is from my future iOS Tweak, Paged, a tweak for per-page wallpapers, and is the icon that I designed for it. It is not a homage to any intellectual property. It is completely original and was designed by me in Pixelmator Pro. Note that yes, I *do* hold rights to this, don't worry haha, of course I'm allowing its usage here. There is much less worry in using this than the first icon I mentioned, and for the most part, should be O-K for release. The only thing to maybe worry about a bit is Apple is not keen on having an app reference jailbreaking stuff, but as long as you don't explicitly say where it is from **in the app itself**, you should be fine. With that being said, I'm assuming this note won't matter to future devs, since likely they will just replace the app icon to be the FHS logo since it just makes more sense, but hey, decided to note anyway just in case.

## iOS Team

* 0xilis - Contact me at QuickUpdateShortcutSupport@protonmail.com, DM my twitter @QuickUpdate5, add me on discord (iAmNotSnoolee#1413) and DM me there. My github is https://github.com/0xilis.

## Non-iOS Team

* Jenna Curtis 
* Anderson
* Splittikin
* indigoliad
* Swanson

# API / Server-Side Docs:

* Server-Side Docs: https://splittikin.github.io/FHS-News-Docs/
