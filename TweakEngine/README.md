# ProjectGlass Tweak Engine (experimental)

This folder is the first attempt at a real, jailbreak-dependent SpringBoard tweak, separate from the SwiftUI preview app.

## First proof of concept

`ProjectGlassClockTint` attempts to tint labels inside `SBFLockScreenDateView` in SpringBoard. It is deliberately small so it can be tested independently of the main app.

## Important status

- This is source code, **not a jailbreak** and not an installable IPA.
- It requires a compatible jailbreak/tweak-injection environment and Theos on a Mac or Linux build host.
- iOS 27.2 beta 4 on iPhone 16 (`iPhone17,3`) is **not confirmed supported** by this prototype.
- The SpringBoard class and view structure are private implementation details and may have changed. This must be tested on a spare/test device before daily use.
- Do not install until it has been built, checked against the exact iOS build, and there is a reliable way to disable/remove it if SpringBoard misbehaves.

The SwiftUI app will remain a settings UI; the tweak is the separate component that would apply a real system change when a compatible injection environment exists.