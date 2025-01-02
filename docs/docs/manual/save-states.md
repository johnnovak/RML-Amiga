# Save states

WinUAE save states capture the entire state of the emulated machine into a
file that you can restore later instantaneously. They are useful to save your
progress in games that don't have built-in save game support. You can also use
them in most (but not all) games as an alternative saving mechanism.

Compared to other emulators, WinUAE save states are very stable. The latest
WinUAE can can still load save states created 20 years ago. You can count on
it that all your save states will continue to work in future WinUAE versions.

Save state files have the `.uss` extension. You can create them in a few
slightly different ways that cater for different use cases, but at the end of
the day, there is just a single save state format.

!!! danger

    Not all games are compatible with save states, and you can mess things
    up royally in some games with save states if you don't know what you're
    doing!

    Make sure to read the [Save state best
    practices](#save-state-best-practices) section carefully before you start
    using save states in anger, and always check the [Games notes](games.md)
    to see if a game is incompatible with save states.


## Quick saves

This method is the most useful for "save scumming" over short periods of time.
You have nine quick save slots available for the currently loaded config.

To save the current state into slots 1--9, press ++end+shift+num1++ -- ++num9++.

To restore the state from slots 1--9, press ++end+num1++ -- ++num9++.

Save states created this way are stored in `$RMLBase\Quicksaves`. The state
files are named after the currently loaded config and the quick save slot. For
example, if you loaded the game config **Another World** and then quick saved
into slots 1, 2, and 5, you'll end up with the following state files:

<div class="compact" markdown>
- `$RMLBase\Quicksaves\Another World_1.uss`
- `$RMLBase\Quicksaves\Another World_2.uss`
- `$RMLBase\Quicksaves\Another World_5.uss`
</div>

TODO manual/quick save coupling

!!! warning "Using quick saves with config variants"

    Quick saves are named after the currently loaded config, but quite a
    few games have alternative configs to skip the intro or the manual-based
    copy protection checks.

    For example, the classic cinematic platformer **Another World** has two
    configs named **Another World** and **Another World [skip code check]**.
    If you start the "skip code check" variant and create a quick save in slot
    1, it will be named as `Another World_1.uss`. Then if you restart WinUAE
    and run the `Another World` config variant this time, you won't be able to
    restore the game from quick save slot 1 as the config and quick save file
    names won't match.

    The workaround is load your save state using the [Named save
    states](#named-save-states) method. Alternatively, you can rename the
    `.uss` files in `$RMLBase\Quicksaves` to make the names match, but that's
    fiddly and error-prone.


## Named save states

The quick save method is great for save scumming to get over a
difficult part in a game (especially in action games), but for more "permanent"
saves, it's better to use the named save states method.

Press ++end+shift+f6++ to bring up the save state dialog. Select the
destination folder for your save state, give it a name, then press the **OK**
button. It is highly recommended to use the dedicated `Savestates` subfolder
in your invididual game folders to keep things neatly organised.

To load a save state, press ++end+f6++ to bring up the the restore state
dialog.

!!! important

    Always start the game first before loading a save state!


!!! warning

    When restoring a save state, you must be running the same config you used
    when creating it. Failing to do so will likely result in a crash of the
    emulated machine or the game misbehaving.

    This is why putting your save states in the `Savestates` subfolder within
    the game's folder is the recommended best practice.

    Save states created with different config variants of the same game are
    compatible with each other (e.g., `Another World` and `Another World [skip
    code check]`). That's because they use the exact same emulated machine
    configuration.


## Creating your own config variants

If you want to create your own "skip intro" or "skip code check" config
variants for existing game configs, this is how to do it. We'll use the imaginary game **Bikini
Bandits** in our example.


1. Start the game using the `Bikini Bandits` config.
2. Wait until the game loads, then bring up the GUI with the ++f12++ key.
3. Go to the **Configurations** tab, create a new config variant by changing the
   config name to `Bikini Bandits [skip intro]` (or whatever else you fancy),
   then press the **Save** button.
4. Now go to the **Host / Miscellaneous** tab and press the **Save State**
   button. This will bring up the familiar save state file dialog.
5. Navigate to the `$RMLBase\Games\Bikini Bandits\Savestates` folder, enter
   `SkipIntro` as the name of the new state file, then press **Ok**.
6. Note that the state file's name now appears in the combo box left to the
   state management buttons, and the checkbox right to it is ticked. This
   is a "hidden feature"; it means the state file will be immediately loaded
   after starting the config.
7. Go back to the **Configurations** tab, make sure the name field still
   shows `Bikini Bandits [skip intro]`, then press the **Save** button to
   update your config.


To test your new config, restart WinUAE, then load your new `Bikini Bandits
[skip intro]` config. The game should now start from the saved state.

!!! warning

    Always create the new config first in the **Configurations** tab and make
    sure you press the **Save** button _before_ going to the **Miscellaneous**
    tab!

    If you don't save the new config first, the config name will revert to the
    last loaded (or saved) config when returning to the **Configurations**
    tab, so you'll need to type it in again. But this is error prone; it's
    very easy to overwrite your original config by mistake if you're doing
    things this way.


### Emulating "resume game"

You can use this method to emulate a "resume game" feature in games that have
no save game support. Just create `Bikini Bandits [save]` or something similar
with the above method, then use ++end+shift+f6++ to update your save state
whenever you want or before quitting the game.

Starting `Bikini Bandits [save]` will then always resume your game from your
last save point, which is pretty comfortable!


## Save state best practices


**Persistent game worlds** 

Some games, typically complex RPGs, change the data on the disk as you
progress through the game. Using save states in such games will invariably
result in crashes, bugs, and/or the loss of your all your progress. You
_must_ only use the in-game save feature in these games!

Games that lock you into using a single save slot always belong to this
category (e.g., **Ultima IV: Quest of the Avatar** and **Rogue**). Other
affected titles might instruct you to create copies of your original game
disks, or so-called scenario disks, before playing. Note that these
games might still support manual save files (e.g., **Amberstar**,
**Demon's Winter**, **Legend of Faerghail**, **Phantasie**, etc.)

The common problem is that these games write to the floppies or the hard drive
on certain actions without you explicitly saving the game (e.g., when
entering/exiting battles, when entering a city or a new area, etc.) Because of
this, the save states and the contents of the disks can become out of sync,
and the game is not expecting this. You can recognise these games by the
floppy or hard drive write indicators (flashing red lights) in the on-screen
display in the bottom-right corner.


**WHDLoad games**

WHDLoad games perform in-game saves to memory only, then write these cached
save games to disk when you exit the game with the ++f10++ key. The same sync
issues explained in the previus point apply---_never_ use save states with
WHDLoad games if you don't like losing your progress!


**Running a game for "too long"**

Some games might misbehave if you keep them running for a really long
time without a restart. Back in the day, people played a game for a few hours or
maybe half a day at most, then turned off their Amigas. Nobody tested how
the game would behave if you kept it running for tens of hours or days on end!
Certain can games can manifest really some weird bugs if you let them to run
for too long without a reboot (or they'll just simply crash).

The solution is to stay on the safe side and periodically "convert" your
WinUAE save states to in-game saves, then restart the game and load one of
your in-game saves. It's recommended to do this after every 5-10 hours of
using save states exclusively.
