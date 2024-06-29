# Saving your progress

Some games give you continuation codes at certain checkpoints, while others
let your save your progress to disk whenever you want. Some other games don't
have any built-in continuation or save support---luckily, you can use WinUAE
[Save states](#save-states) for these.

Let's have a look at each of these options!


## Dedicated save disks

Many floppy games support saving your progress to disk. Most such games
require you to use a dedicated _save disk_ for this purpose. The collection
includes blank save disks for these games for convenience. This disk is
located in the `Savedisk` subfolder of the game's folder, and it's always
available in the 9th disk swapper slot (so you can insert the save disk by
pressing ++end+9++).

!!! warning "Not all blank disks are created equal"

    Always use the save disk included with the game. A regular empty AmigaDOS
    ADF disk image won't work with games that use special encoding schemes,
    such as the floppy version of **Canon Fodder**. A pristine blank save disk
    is always included in a ZIP archive as well, should you want to reset your
    save disk.

!!! tip "ProTip(tm)"

    If you know what you're doing, feel free to create your own save disks.
    You'll need to consult the game's manual to do so as the exact steps vary
    per game.

    Always use _Extended ADF_ images for save disks that are about 2 MB in
    size. The regular 880 KB ADF images will give you problems in many games.


## Saving to the game disk

Some games save your progress directly to the game disk. These games are
configured to never modify the original floppy images, but to create
so-called _save images_ instead that only contain the changes compared to the
original disks.

Save images have the `.save_adf` file extensions and are located in the same
folder as the game disks.

If you wish to revert such a "virtually modified" game disk to its original
pristine state, click on the **Delete save image** button in the **Floppy**
configuration tab (you don't need to re-save the config after this). TODO tick
writeable checkbox?

TODO ? Alternatively, you can delete the `.save_adf` file manually.

!!! tip "ProTip(tm)"

    Of course, the resourceful among you can create copies of these save
    images to emulate multiple save points in games that only support a single
    save slot.


## Hard drive games

Most hard drive installed games store the save games on the hard drive; using
the save and restore game functionality in these games should be
straightforward. A minority of games insist on using a save disk even when
installed to the hard drive---these special games are mentioned on the [Game
notes](game-notes.md) page.

:material-folder-open:
:material-file-outline:
:material-arrow-left-top-bold:


## Save states

TODO
