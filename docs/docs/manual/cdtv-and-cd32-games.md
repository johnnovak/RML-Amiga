# CDTV and Amiga CD32 games

The **CDTV** (Commodore Dynamic Total Vision) and **Amiga CD32** were CD-ROM
game consoles based on the Amiga 500 and Amiga 1200 models, respectively. An
interesting trivia is that the Amiga CD32 was the world's first 32-bit
CD-based console (if we don't count the Japan-exclusive FM Towns Marty
released a few months earlier).

These Commodore consoles were not very successful, but a few games have really
cool CD release exclusive content (e.g., CD Audio in-game music in [Heimdall
2: Into the Hall of
Worlds](../games/g-j.md#heimdall-2-into-the-hall-of-worlds-cd32), voice acting
and a tutorial section in [Battle Chess](../games/b.md#battle-chess-cd32), and
there are a handful of CD-exclusive titles as well, such as [Defender of the
Crown II](../games/d.md#defender-of-the-crown-ii-cd32) and [Pirates!
Gold](../games/p-r.md#pirates-gold-cd32)).

TODO cdtv and cd32 pictures


## Gamepads

Most CDTV and Amiga CD32 games are meant to played with the gamepad that came
with the console. It's best to use a physical game controller with these games
as the keyboard mappings for the emulated gamepad can be rather awkward. To
use your physical gamepad (e.g., an Xbox 360 controller), press the green
**A** button on it after starting the game and WinUAE will auto-plug it into
port 2 (if you're using some other game controller, press the button that is
in the same location as the **A** button on the Xbox 360 controller).

Similarly to joysticks, you might need to activate the **Swap joystick ports**
feature with ++end+j++ if your gamepad was auto-plugged into the wrong port.

A smaller number of CDTV and CD32 games support the mouse as well (typically
point-and-click adventure games). Although you can play these games with a
gamepad, it's usually more convenient to use the mouse.

TODO cdtv and cd32 controller pictures


## Saving your progress

Most CD32 games support saving your game to the NVRAM, but they might only
support a limited number of save slots, or only allow you to save the game at
specific locations (e.g., **Frontier II: Elite (CD32)**). Then in some games
the save game implementation is rather buggy (e.g.,  [Heimdall 2: Into the
Hall of Worlds](../games/g-j.md#heimdall-2-into-the-hall-of-worlds-cd32)).

You can sidestep all these issues and limitations by ignoring the in-game save
functionality altogether and using [Save states](save-states.md) instead. Save
states are fully compatible with all CD games. Mixing NVRAM saves with save
states usually works fine, but you might want to use save states exclusively
for extra safety.
