# Input handling

All Amiga computers came with a keyboard and a mouse. Including a mouse as a
standard accessory was a big selling point back in the day, so most Amiga
games are primarily mouse-operated. The exceptions are action, sports, and
racing games---these usually need a joystick (or two for "player vs player"
gaming).

All Amigas have two **controller ports** for connecting your input devices.
The mouse usually needs to go into **port 1**, and the game controller
(typically a joystick) into **port 2**.


## Input capturing

When you start a game, the emulator automatically captures all your mouse and
keyboard input. What this means is your Windows mouse pointer disappears, and
all mouse events and keyboard button presses are sent to the emulated Amiga
instead of Windows. In windowed mode, input capturing is indicated by the the
following text in the WinUAE window's title bar:

```
[ALT+TAB or middle mouse button untraps the mouse - F12 opens settings]
```

This tells you how to uncapture the mouse and keyboard: either press the
middle mouse button or ++alt+tab++ to switch to a different window (but
"alt-tabbing" only works if you have at least on more other window open).

!!! tip

    Pressing the ++alt++ key might trigger something in the game when
    attempting to "alt-tab" out of the WinUAE window. For example, many games
    skip the intro sequence if you press any key on the keyboard, including
    the ++alt++ key. Using the middle mouse button is the 100% safe way as
    middle button presses are not forwarded to the emulated Amiga.

To capture the input again, "alt-tab" into the WinUAE window, or press any
mouse button inside it.

Now, not all games support the mouse or display a mouse pointer. If you see
neither the Windows mouse pointer nor the "emulated" mouse pointer in the
WinUAE window with the mouse captured, it means you're dealing with such a
game.

!!! warning

    Due to a bug, if the WinUAE window is unfocused _and_ you left-click on
    the title bar of the WinUAE window, the window will rapidly move downwards
    on the screen as long as you're holding the left mouse button pressed.
    Currently, there is no solution to this minor issue so the advice is
    simple: just don't do this.

    The bug will be fixed in the next WinUAE version, which will be
    incorporated into a future RML Amiga release.


## Mouse

All Amigas came with a 2-button mouse, so the vast majority of games that are
not action games are mouse-operated. Even most text adventures have some
rudimentary mouse-driven interface---that's how big of a deal built-in mouse
support was back in the 80s.

The left and right mouse buttons work as expected, and the middle mouse is
used to uncapture the mouse (see [Input capturing](#input-capturing)).


## Keyboard

Amiga keyboards are very similar to standard PC keyboards. Even the numeric
keypad is present on most Amiga models. This means you can use your normal PC
keyboard rather seamlessly to control your emulated Amiga.

There are a few minor differences, though:

- There are only 10 function keys in the top row (++f1++ to ++f10++).

- The special **Help** Amiga key is mapped to the ++next++ key, and the
  **Delete** Amiga key to the (surprise!) ++delete++ key above the standard
  cursor keys.

- Similarly to the Windows keys, all Amiga keyboards have two special "Amiga
  keys" (the keys in the bottom row with the big **A** letters on them, next
  to the **Alt** keys). The left Amiga key is mapped to the ++lwin++ and
  ++home++ keys (you can use either), and the right Amiga key to ++rwin++,
  ++ins++ and ++home++ (either will work). For example, if a game asks you to
  use the left Amiga plus ++s++ key combination to save your game, you'll need
  to press ++lwin++-++s++ or ++home++-++s++.


### WASD movement keys

Many RPGs in the first-person dungeon crawler category (e.g.,
[Dungeon Master](../games/d.md#dungeon-master-v36) and
[Eye of the Beholder](../games/e-f.md#eye-of-the-beholder-ocs)) only support
the standard cursor keys or the numeric keypad to move your party around.
However, some people might prefer to use the **WASD** keys instead.

All such RPGs in the collection feature optional WASD-style movement via a
custom WinUAE keyboard mapping:

- Press ++home+w++ to switch to the alternative keyboard mapping which maps
  the party-movement keys (usually the cursor keys) to the WASD keys.

- Press ++home+q++ to restore the normal keyboard mapping.

You'll need to return to the normal keyboard mapping if you want to type in
some text that contains the letters "WASD" (e.g., to name your characters, the
name of your save game, or when entering a password).

Some game configuration might remap a few more keys in WASD mode. For example,
in [Dungeon Master](../games/d.md#dungeon-master-v36) you can turn left and
right with the ++q++ and ++e++ keys, respectively, and the ++ctrl+s++ save
game shortcut has been remapped to ++ctrl+x++ (because it clashes with the
remapped ++s++ key used for movement).

Refer to the [Game notes](../games/index.md) to learn about the exact WASD
mode remappings for each game.


## Joysticks

Most games in the collection are controlled with the mouse and the keyboard,
but a few need a joystick. Games that support or need a joystick are
configured for an emulated joystick (usually in port 2). You can use the
regular cursor keys (*not* the numeric keypad) for movement, and the ++ralt++,
++rshift++, or ++rctrl++ keys for the fire button.

The vast majority of Amiga games only support single-button joysticks. The
[Game notes](../games/index.md) will mention if a game supports a two-button
joystick.

### Using a real joystick

To use a real joystick, press the fire button on your joystick *after*
starting the game. WinUAE will auto-detect the joystick and plug it into
either port 1 or port 2 of your emulated Amiga. The chosen ports depends on
which fire button you pressed on your physical joystick.

Most games look for the joystick in port 2, but some expect it in port 1. If
your joystick doesn't do anything or performs the wrong actions, WinUAE must
have plugged it into other port than what the game expects. In this case,
press ++end+j++ to swap the joystick ports. You might also try pressing a
different physical button on your joystick to auto-detect it the next time you
start this game, so you won't need to do the port swapping trick.

!!! tip 

    Some action games are next to unplayable with the virtual joystick
    keyboard mappings (typically sports and fighting games). You really need
    to use a **digital joystick** to play these games (analog sticks found on
    game controllers won't do).

    There are many USB joysticks available, but quite a few have unacceptably
    high input latencies, so make sure to do your research before buying one.
    Generally, you're better off with 9-pin plug (DB9) digital joysticks
    also usable with real retro computers and a USB DB9 adapter.

    This is not an advertisement, but I can wholeheartedly recommend the
    [ArcadeR 9-pin joystick](https://retroradionics.com/ArcadeR-9-pin-ATARI-standard-Joystick-With-new-extra-soft-and-durable-cable-p168982750)
    by [RetroRadionics](https://retroradionics.com/) and the
    [DaemonBite DB9 USB adapter](https://github.com/MickGyver/DaemonBite-Retro-Controllers-USB)
    (sold fully-assembled [here](https://ultimatemister.com/product/deamon-sega-db9/), for example).
    This combination is relatively cheap and works 100% reliably with
    hardware-like sub-millisecond input latency. It's a dual adapter, so you
    can connect two 9-pin digital joystick to it for two-player games. 

!!! note

    As noted, the input latency can be increased by the USB joystick adapter
    and the joystick themselves, but also by certain vertical syncing (vsync)
    methods. Both need to be kept low if you want hardware-like low latencies
    in action games.

    This is an advanced topic; see the
    [Customising your setup](customising-your-setup.md#graphics-customisation)
    section for details.


### Two-player games

The Amiga was one of the last machines in a long line of home computers that
had a healthy dose of two-player games. Many sports and fighting games (e.g.,
[Speedball 2: Brutal Deluxe](../games/s.md#speedball-2-brutal-deluxe-ocs) and
[IK+](../games/g-j.md#ik)) support "player vs player" gameplay. 

Two-player games are great fun, so make sure to try them if you have two
joysticks and a friend not afraid of some healthy competition!


## Gamepads

Many Commodore CDTV and Amiga CD32 games are best played with the mouse, but
some are almost unplayable without a physical gamepad (the keyboard mappings
tend to be very awkward to use). To use your physical gamepad (e.g., an Xbox
360 controller), press the green **A** button on it after starting the game
and WinUAE will auto-plug it into port 2.

Similarly to joysticks, you might need to activate the **Swap joystick ports**
feature with ++end+j++ if your gamepad was auto-plugged into the wrong port.
