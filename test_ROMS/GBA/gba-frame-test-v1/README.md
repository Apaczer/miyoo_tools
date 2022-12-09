# GBA Frame Test ROM

The program is a modified version of Joe Savage's awesome [Writing a
Game Boy Advance
Game](https://www.reinterpretcast.com/writing-a-game-boy-advance-game)
example of how to write a GBA game.

## Introduction

![Animation
GIF](https://github.com/veikkos/gba-frame-test/blob/master/animation.gif)

Frame Test ROM can be used to test that your GBA's display driving is
working as it should. It's mostly useful for people changing their
console displays to 3rd party models e.g. "IPS V2". These displays are
coming from several vendors and with varying quality. Some models can
have display tearing or are missing frames. With the test ROM you can
see how well your display works.

## Usage

See example video of Gameboy Advance SP AGS-001 recorded with 480 FPS
[from YouTube](https://www.youtube.com/watch?v=Zwg9IndS9is).

### Frame drop

Install test ROM to your GBA. You need a flash cart or similar
solution. Start the ROM and you should see vertical block going from
left to right over and over again.

Take your phone and record the screen with the quickest slow motion
video recording mode you can find. For example 240 or 480 FPS will do
nicely.

Then inspect the video to see that there are no missing frames. Since
the block moves one step every frame you should be easily notice that
if it sometimes jumps more which means you had a frame drop.

### Tearing

You can also try see if the [screen is
tearing](https://en.wikipedia.org/wiki/Screen_tearing).  It happens
when the display was still drawing the vertical block but the driver
doesn't synchronize the process correctly. Visually it can be seen so
that the block is not drawn fully before display prematurely jumps to
drawing next frame.

Tearing is not to be confused with normal banding when watching slow
motion footage since the display draws from top to bottom.

## Download

You can find ROM binary from [release
page](https://github.com/veikkos/gba-frame-test/releases).

## Compiling

You need [devkitPro](https://devkitpro.org/) for GBA.

See `build.sh`. 
