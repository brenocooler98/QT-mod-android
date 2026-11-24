# FNF: QT Mod (Android)

Android port of the **QT Mod** for Friday Night Funkin', built on the **Legacy Kade Engine (1.4.2)** version of the mod.

This repository only targets **Android (ARM64)**. The Psych Engine version and the raw art/music source files were removed.

## Features

- Touch hitbox for gameplay, with a dedicated **DODGE** area on Termination and Tutorial
- Virtual pad on every menu (story, freeplay, options, pause, game over, replays)
- Android back button pauses the game and goes back on menus
- Lua modcharts load straight from the APK assets
- Replays and crash logs are saved to the app's internal storage
- Per-song offsets are kept in the game save instead of files

## Building

Every push to `main` builds a signed APK on GitHub Actions (`QTMod-Android` artifact).

To build locally:

```
haxelib install hxcpp 4.3.2
haxelib install lime 8.1.3
haxelib install openfl 9.3.4
haxelib install flixel 5.6.2
haxelib install flixel-addons 3.2.2
haxelib install flixel-ui 2.6.1
haxelib install hscript 2.5.0
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib run lime setup android
haxelib run lime build android -final
```

Android NDK **r21e** and Java **17** are required.

## Credits

- **Programming, Music, Animations:** Hazard24
- **Art:** CountNightshade
- **Engine:** Kade Engine
- **Boyfriend's vocals soundfont:** https://github.com/NyxTheShield/FNFSoundfonts
- **Original mod:** https://gamebanana.com/mods/299714
- **Android port:** Brenninho

Shoutouts to the original creators of Friday Night Funkin' and the entire modding community!
