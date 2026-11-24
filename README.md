# FNF: QT Mod (Android)

Android port of the **QT Mod** for Friday Night Funkin', built on the **Legacy Kade Engine (1.4.2)** version of the mod.

This repository only targets **Android (ARM64)**. The Psych Engine version and the raw art/music source files were removed.

## Features

- Touch hitbox for gameplay, with a dedicated **DODGE** area on Termination and Tutorial
- Direct touch on menus: tap an item to select it, tap it again to confirm, swipe to scroll
- Animated back button on menus (bottom right) and pause button in gameplay (top right)
- Android back button pauses the game and goes back on menus
- Lua modcharts load straight from the APK assets
- Replays and crash logs are saved to `Android/data/com.hazard24.qtmod/files`
- Screen stays on while playing, immersive fullscreen, and the game pauses itself when the app goes to the background
- FPS counter scaled to the screen (toggle in Mobile Options)
- Screen Style option: Original (16:9) or Full (uses the whole screen, including the notch area, without stretching)
- Per-song offsets are kept in the game save instead of files

## Building

Every push to `main` builds a signed APK on GitHub Actions (`QTMod-Android` artifact).

To build locally:

```
haxelib install hxcpp 4.3.2
haxelib install lime 8.3.2
haxelib install openfl 9.5.2
haxelib install flixel 6.2.1
haxelib install flixel-addons 4.0.1
haxelib git flixel-ui https://github.com/HaxeFlixel/flixel-ui
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git android-manager https://github.com/BrenninhoTools/android-manager
haxelib run lime setup android
haxelib run lime build android -final
```

Haxe **4.3.7**, Android NDK **r21e** and Java **17** are required.

## Credits

- **Programming, Music, Animations:** Hazard24
- **Art:** CountNightshade
- **Engine:** Kade Engine
- **Boyfriend's vocals soundfont:** https://github.com/NyxTheShield/FNFSoundfonts
- **Original mod:** https://gamebanana.com/mods/299714
- **Android port:** Brenninho

Shoutouts to the original creators of Friday Night Funkin' and the entire modding community!
