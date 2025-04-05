# Keyboard shortcuts

!!! warning "Not all keyboards are created equal"

    You might not be able to use some of the 3-key shortcuts if you do not
    have a *3-key rollover* (3KRO) or better keyboard.


The ++end++ key functions as a special modifier key to access various emulator
features.


## General

<div class="compact" markdown>
| Shortcut             | Description                                           |
| --------             | -----------                                           |
| ++f12++              | Pause emulation and open the WinUAE settings window   |
| ++end+f12++          | Toggle between windowed and full windowed mode        |
| ++pause++            | Toggle pausing the emulation                          |
| ++end+pause++        | Toggle [warp mode](getting-started.md#warp-mode) (run the emulation at maximum speed) |
| ++end+print-screen++ | Save PNG screenshot to `$RML_BASE\Screenshots`        |
</div>


## Input

<div class="compact" markdown>
| Shortcut   | Description                |
| --------   | -----------                |
| ++end+j++  | Swap joystick ports        |
| ++home+w++ | Enable [WASD movement keys](./input-handling.md#wasd-movement-keys) (in supported games) |
| ++home+q++ | Disable WASD movement keys |
</div>


## Audio

<div class="compact" markdown>
| Shortcut         | Description     |
| --------         | -----------     |
| ++end+multiply++ | Mute audio      |
| ++end+subtract++ | Decrease volume |
| ++end+add++      | Increase volume |
</div>


## Floppy

<div class="compact" markdown>
| Shortcut                   | Description                                                 |
| --------                   | -----------                                                 |
| ++end+ctrl+1++ -- ++4++    | Set target floppy drive to DF0--DF3 for the [disk swapper](floppy-games.md#multi-disk-games) |
| ++end+1++ -- ++9++         | Insert disk 1--9 from the swap list into the target drive   |
| ++end+f1++ -- ++f4++       | Open insert disk (floppy image) dialog into DF0--DF3 dialog |
| ++end+shift+f1++ -- ++f4++ | Eject disk (floppy image) from DF0--DF3                     |
</div>


## Save states

<div class="compact" markdown>
| Shortcut                       | Description                        |
| --------                       | -----------                        |
| ++end+shift+num1++ -- ++num9++ | [Quick save](save-states.md#quick-saves) state to slot 1--9 |
| ++end+num1++ -- ++num9++       | Quick restore state from slot 1--9 |
| ++end+shift+f6++               | Open the save state dialog (see [Named save states](save-states.md#named-save-states) |
| ++end+f6++                     | Open the restore state dialog      |
</div>


## Special Amiga keys

<div class="compact" markdown>
| Shortcut                      | Description                |
| --------                      | -----------                |
| ++lwin++ / ++home++           | Left "Amiga" modifier key  |
| ++rwin++ / ++ins++ / ++home++ | Right "Amiga" modifier key |
| ++delete++                    | "Delete" key               |
| ++next++                      | "Help" key                 |
</div>


## Miscellaneous

<div class="compact" markdown>
| Shortcut                        | Description                             |
| --------                        | -----------                             |
| ++lctrl++ / ++lwin++ / ++rwin++ | Three-key "Ctrl+Amiga+Amiga" soft-reset |
</div>
