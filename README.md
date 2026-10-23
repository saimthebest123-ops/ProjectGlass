# Project Glass

Project Glass is a dark SwiftUI customisation studio prototype for iPhone. It includes Home, Wallpapers, AOD Studio, Glass Studio, and a demo Store.

## Current features

- Dark interface with five tabs.
- Selectable wallpaper-color concepts.
- Adjustable in-app AOD clock preview.
- In-app Liquid Glass intensity and tint controls.
- Demo Store selections.
- Roadmap card for **Lock Screen AOD**, planned as a richer lock-screen concept preview.

## Important limitations

- The Lock Screen AOD roadmap item is not a shipped system-level feature.
- An ordinary iOS app cannot replace the native lock screen, keep its own interface running while the phone is locked, or enable native Always-On Display on a base iPhone 16.
- Glass controls and themes affect this app's own preview only.
- The Codemagic workflow packages an **unsigned IPA**. A valid archive is not the same as a signed, installable app. Use a signing workflow or a compatible sideloading signer such as KSign, with a valid signing identity/provisioning arrangement.
- This project has not been claimed as tested on a physical device until a successful signed install is verified.

## Build with Codemagic

The repository includes `project.yml` for XcodeGen and `codemagic.yaml` for a cloud macOS build. The workflow:
1. Installs XcodeGen.
2. Generates `ProjectGlass.xcodeproj`.
3. Builds the iOS app without code signing.
4. Verifies the app bundle, executable, and bundle identifier.
5. Packages the app under `Payload/ProjectGlass.app` into `ProjectGlass.ipa` and validates the ZIP archive.

Check the build logs for **Verify app and package unsigned IPA**. The app-bundle and executable sizes are printed separately so a packaging problem can be distinguished from a small SwiftUI binary.

## Bundle ID

`com.projectglass.app`

Change it if it conflicts with an identifier already used by your Apple account.
