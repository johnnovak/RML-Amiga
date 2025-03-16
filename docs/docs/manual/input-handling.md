# Input handling

All Amiga computers come with a keyboard and a mouse. Including a mouse as a
standard accessory was a big selling point back in the day, so most Amiga
games are primarily mouse-operated. The exceptions are action,
sports, and racing games---these usually need a joystick (or two for "player
vs player" gaming).

All Amigas have two **controller ports** for connecting your input devices.
The mouse usually needs to be plugged into **port 1**, and the game controller
(typically a joystick) into **port 2**.


## Input capturing

When you start a game, the emulator automatically captures your mouse and
keyboard. What this means is your Windows mouse pointer disappears, and all
mouse events and keyboard button presses are sent to the emulated Amiga
instead of Windows. In windowed mode, input capturing is indicated by the the
following text in the WinUAE window's title bar:

```
[ALT+TAB or middle mouse button untraps the mouse - F12 opens settings]
```


This tells you how to uncapture the mouse and keyboard: either press the
middle mouse button or ++alt+tab++ to switch to a different window (but
"alt-tabbing" only works if you have at least on more other window open).

To capture the input again, "alt-tab" into the WinUAE window, or press any
mouse button inside it.

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

The left and right mouse buttons work as expected, and you can press the
middle mouse button to uncapture the mouse (uncapturing means you get back
your Windows mouse pointer). You can toggle betwenn windowed and full windowed
mode with ++end+f12++. Pressing ++alt+tab++ to switch to another window also
uncaptures, but the ++alt++ keypress might trigger something in the game
(e.g., skip the intro if the game is programmed to accept any keypress for
skipping skip it).


## Keyboard

Amiga keyboards are very similar to standard PC keyboards. Even the numeric
keypad is present on most Amiga models. This means you can use your normal PC
keyboard rather seamlessly to control your emulated Amiga.

There are a few minor differences, though:

- There are only 10 function keys in the top row (++f1++ to ++f10++).

- The special **Help** key is mapped to the ++next++ key, and the **Delete**
  key to the (surprise!) ++delete++ key above the standard cursor keys.

- Similarly to the Windows keys, all Amiga keyboards have
  two special "Amiga keys" (next to the **Alt** keys with the big **A**
  letters on them). The left Amiga key is mapped to the ++lwin++ and ++home++
  keys (you can press either), and the right Amiga key to ++rwin++, ++ins++
  and ++home++. For example, if a game asks you to use the left Amiga plus
  ++s++ key combination to save your game, you'll need to press ++lwin++-++s++
  or ++home++-++s++.


### WASD movement keys

Many RPGs in the first-person dungeon crawler category (e.g., [Dungeon
Master](../games/d.md#dungeon-master-v36) and
[Eye of the Beholder](../games/e-f.md#eye-of-the-beholder-ocs)) only support
the standard cursor keys or the numeric keypad to move your party around.
However, some people might prefer to use the **WASD** keys instead.

All such RPGs in the collection feature optional WASD-style movement via a
custom WinUAE input mapping:

- Press ++home+w++ to switch to the alternative input mapping which maps the
  cursor keys to the WASD keys.

- To return to the normal input mapping, press ++home+q++.

You'll need to return to the normal input mapping if you want to type in some
text that contains the letters "WASD" (e.g., to name your characters, the name
of your save game, when entering a password, etc.)

Some games might remap a few more keys in WASD mode. For example, in [Dungeon
Master] you can turn left and right with the ++q++ and ++e++ keys, and
++ctrl+s++ has been remapped to ++ctrl+x++ to save the game (because it
clashes with the remapped ++s++ key).

Refer to the [Game notes](../games/index.md) to learn about the exact WASD
mode remappings for each RPG.


## Joysticks

Most games in the collection are controlled with the mouse and the keyboard,
but a few need a joystick. Games that support or need a joystick are
configured for an emulated joystick in **port 2**. You can use the regular
cursor keys (not the numeric keypad) for movement, and the ++ralt++,
++rshift++, or ++rctrl++ keys for the fire button.

TODO customise keymappings

To use a real joystick, press the fire button on your joystick after starting
the game. WinUAE will auto-detect the joystick and plug it into either port 1
or port 2 of your emulated Amiga depending on which fire button you pressed.
Most games look for the joystick in **port 2**, so if WinUAE plugged it into
the wrong port, press ++end+j++ to swap the joystick ports.

!!! tip 

    Some action games are next to unplayable with the virtual joystick
    keyboard mappings (typically sports and fighting games). You really need
    to use a **digital joystick** to play these games (analog sticks found on
    game controllers won't do).

    There are many USB joysticks available, but quite a few have unacceptably
    high input latencies, so make sure to do your research before buying one.
    Generally, you're better off with 9-pin DIN plug digital joysticks also
    usable with real hardware Amigas, and a USB digital joystick adapter.

    This is not an advertisement, but I can wholeheartedly recommend the TODO
    USB adapter and the TODO joystick. This combination is relatively cheap
    and works 100% reliably with very low hardware-like input latencies. It's
    a dual adapter, so you can connect two joysticks for two-player games. 


!!! note

    Extra input latency can be added by the USB joystick adapter and the
    joystick themselves, but also by vertical syncing (vsync). Both need to be
    kept low if you want hardware-like low latencies in action games.

    See the customising your setup TODO for details.


### Two-player games

The Amiga was one of the last machines in a long line of home computers that
had a healthy dose of two-player games. Many sports and fighting games (e.g.,
[Speedball 2: Brutal Deluxe](../games/s.md#speedball-2-brutal-deluxe-ocs) and
[IK+](../games/g-j.md#ik)) support "player vs player" gameplay. 

Two-player games are great fun, so make sure to try them if you have two
joysticks and a friend not afraid of some healthy competition!


## Gamepads

Many CDTV or Amiga CD32 games are best played with the mouse, but some are
almost unplayable without a physical gamepad (the keyboard mappings tend to be
very awkward to use). To use your physical gamepad (e.g., an Xbox 360
controller), press the green **A** button on it after starting the game and
WinUAE will auto-plug it into **port 2**.

Similarly to joysticks, you might need to activate the **Swap joystick ports**
feature with ++end+j++ if your gamepad was plugged into the wrong port.
