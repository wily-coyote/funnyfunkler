# FunnyFunkler
FunnyFunkler is an expansion for Etterna's Til Death theme.
It adds familiar visual elements from Friday Night Funkin', making it easier to migrate from FNF to Etterna.

### Features
- Animations for judgments (when hitting a note)
- BPM animations (Girlfriend, parallax zoom, idle animation)
- Assets used from the original Funkin repo

### TODO
- Miss animations
- Countdown at beginning of song
- CustomizeGameplay

## Installation
1. Clone or download the ZIP file of this repository
2. Move the contents to `/path/to/etterna/Themes/Til Death/`, merging any folders if needed.
3. Make Til Death load `funnyfunkler.lua` by editing `default.lua` under `Til Death/BGAnimations/ScreenGameplay underlay/`:
```lua
t[#t + 1] = LoadActor("funnyfunkler")
```
4. To change the characters, open `funkler.lua`

### Adding your characters
Under the Graphics folder, there is a `fnf` folder. Each character is a subfolder and each animation is its own image spritesheet.
The spritesheet is organized in a grid such that per-animation offsets are not needed unlike the original game. This however increases the size of the spritesheets since more transparent pixels are stored.

In-game, the scripts have an internal table for each character which contains the number of frames for each animation, offset and whether or not it's player-based.