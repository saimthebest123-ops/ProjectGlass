# ProjectGlass: iOS 27.2 beta 4 capability status

Target reported for development: iPhone 16, device identifier `iPhone17,3`, iOS `27.2 beta 4 (24B5110a)`.

## Verified in this repository

- The SwiftUI app provides in-app wallpaper, clock/AOD-style, and glass-style previews.
- `TweakEngine/Tweak.xm` is a small Theos/Logos SpringBoard hook prototype that attempts to tint lock-screen date labels.
- The current GitHub Actions workflow builds an **unsigned app IPA**. It does not build, sign, or install a jailbreak.
- There is no device test evidence in this repository confirming the tweak works on the target build.

## Not verified / not implemented

- A jailbreak exploit chain compatible with build `24B5110a`.
- Privilege escalation, persistence, code-signing bypass, or tweak injection on that build.
- A system-wide Liquid Glass switch.
- A native AOD mode on the base iPhone 16, or an action triggered by pressing the physical Side button.
- Setting an iOS Live Photo/wallpaper directly from this app. The app can preview selected media; iOS controls wallpaper installation.

## Implementation plan

1. Keep the SwiftUI app and the privileged tweak as separate components.
2. Establish a verified jailbreak and tweak-injection environment for the exact device/build before writing or enabling SpringBoard hooks.
3. Build the tweak in CI with a pinned Theos/toolchain and fail the workflow if compilation fails.
4. Add a reversible, narrowly scoped tweak first (clock tint), with a documented disable/removal path.
5. Test on the exact build and record device/build, install method, logs, and pass/fail results before describing any system feature as working.
6. Implement native system changes only when a compatible privileged environment and verified API/hook are available. Otherwise label the feature as an in-app preview.

## Current status

**Experimental source only. Not a working jailbreak. Target compatibility: unverified.**

Do not install an untested SpringBoard tweak on a daily-use phone. A SwiftUI app or unsigned IPA cannot by itself grant jailbreak privileges.