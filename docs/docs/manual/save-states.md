# Save states

WinUAE save states capture the entire state of the emulated machine so you can
restore it later. They are useful to save your progress in games that don't
have built-in save game support, or you can use them in any game as
an alternative saving mechanism.

Compared to other emulators, WinUAE save states are very stable. The latest
WinUAE can can still load save states from 20 years ago---how's that for
stability? So don't worry about save states, they will continue to work in
future versions of WinUAE.

Save state files have the `.uss` extension. You can create them in slightly
different ways that cater for different use cases, but at the end of the day,
there is just a single save state format. You can load a state created by one
of the methods via any other method.


## Quick saves

This method is the most useful for "save scumming". You have nine quick save
slots available for each game.

To save the current state into slot 1--9, press ++end+shift+num1++ -- ++num9++.

To restore state 1--9, press ++end+num1++ -- ++num9++.

Save states created this way are stored in `$RMLBase\Quicksaves`. The state
files are named after the currently loaded config and the quick save slot. For
example, if you loaded the game config **Another World** and then quick saved
into slots 1, 2, and 5, you'll end up with the following state files:

<div class="compact" markdown>
- `$RMLBase\Quicksaves\Another World_1.uss`
- `$RMLBase\Quicksaves\Another World_2.uss`
- `$RMLBase\Quicksaves\Another World_5.uss`
</div>


!!! warning "Using quick saves with config variants"

    Quick saves are named after the currently loaded config file, but quite a
    few games have alternative configs to skip the intro or the manual-based
    copy protection checks.

    For example, the classic cinematic platformer **Another World** has two
    configs: `Another World` and `Another World [skip code check]`. If you
    start the "skip code check" variant and create a quick save in slot 1, it
    will be named as `Another World_1.uss`. Then if you
    restart WinUAE and run the `Another World` config variant this time, you
    won't be able to restore the game from quick save slot 1 as the config and
    quick save file names won't match.

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

    When restoring a save state, you must use the same config you used when
    creating it. Failing to do so will likely result in a crash of the
    emulated machine or the game misbehaving.

    This is why the best practice is to put your save states for a given game
    in the `Savestates` subfolder in the game's folder.

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
   state management buttons, and a checkbox right to it is highlighted. This
   is a "hidden feature"; it means the state file will be immediately loaded
   after starting the config.
7. Go back to the **Configurations** tab, make sure the name field still
   shows `Bikini Bandits [skip intro]`, then press the **Save** button to
   update your config.

To test your new config, restart WinUAE, then load your new `Bikini Bandits
[skip intro]` config. The game should now start from the saved state.

### Emulating "resume game"

You can use this method to emulate a "resume game" feature in games that have
no save game support. Just create `Bikini Bandits [save]` or something similar
with the above method, then use ++end+shift+f6++ to update your save state
whenever you want or before quitting the game.

Starting `Bikini Bandits [save]` will then always resume your game from your
last save point, which is pretty comfortable!


## Save state best practices

- Some games might misbehave if you keep them running for a really long
  time without a restart. Back in the day, people played a game for a few hours or
  maybe half a day at most, then turned off their Amigas. Nobody tested how
  these games would behave if they keep running for tens of hours or days.
  Some might be fine, but you can trigger some really weird bugs or crashes in
  a few games if you let them run for too long.

    By only loading the game once then relying on save states to resume playing,
    you're effectively never turning off your emulated Amiga!
    This can be a problem in long-running RPGs that can go on for 50-100
    hours. Make sure to periodically "convert" your WinUAE save state to a
    "real" save game by using the game's in-built save mechanism, then restart
    the game and load your saved game via the game's "load game" feature.
    After this, you can use save states again for a while, then repeat the
    process after 5-10 hours of playing.

    If you don't this, you might lose all your progress and even your save
    states might get into an unrecoverable corrupt state.
