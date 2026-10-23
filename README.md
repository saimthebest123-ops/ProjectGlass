# Project Glass — iOS starter

This is SwiftUI source code for an iOS app prototype with Home, Wallpapers, AOD Studio, Glass Studio, and a demo Store.

## Important limitations
- This ZIP is source code, **not an IPA**.
- It must be opened and built in Xcode on a Mac, then signed with an Apple development team before it can be installed on a physical iPhone.
- The AOD screen is an in-app preview only. A regular app cannot enable native Always-On Display on the base iPhone 16 or keep its own interface visible while the phone is locked.
- Store packs are demo selections, not jailbreak tweaks or installed system modifications.

## Build
1. On a Mac, open Xcode and create a new iOS App project named `ProjectGlass` using SwiftUI.
2. Replace the generated `ProjectGlassApp.swift` and `ContentView.swift` with the files in this folder.
3. In Signing & Capabilities, choose your own Apple development team and a unique bundle identifier.
4. Build and run on your device.

A valid IPA needs to be compiled and signed. This environment has not compiled or signed this project.
