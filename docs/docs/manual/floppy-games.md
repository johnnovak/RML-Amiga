# Floppy games

All Amigas come with one floppy drive as standard equipment, but they can be
optionally expanded to up to four drives. The first floppy drive is called
**DF0:** (**D**rive **F**loppy **0**), the second **DF1:**, the third
**DF2:**, and the fourth **DF3:**.

Most floppy games are in the **IPF** format (Interchangeable Presentation
Format), and some in the **RAW** (KyroFlux CT-RAW) format. These are accurate
representations of the original disks with the copy protection intact.

A small set of games are provided as regular **ADF** files (Amiga Disk File).
These games either don't use copy protection, or are only available in cracked
form at the time being.


## Single-disk games

All floppy game configurations have the first floppy pre-inserted in drive
DF0: (the first floppy drive). For single-disk games, that's all you need.


## Multi-disk games

Multi-disk games fall into two categories: some support multiple floppy
drives, some only a single drive. The best case scenario is when a game
supports as many drives as the number of disks it comes on. Such games are
configured with the game disks pre-inserted into the drives (e.g., the
two-disk game *Lemmings**; and the four-disk game **Perihelion**).

The other scenario is that the game supports *less* drives than the number of
disks it has (e.g., a two-disk game supporting a single drive, or a four-disk
game supporting two drives). In these games, you'll need to swap the disks
when the game prompts you. Fortunately, WinUAE has a convenient disk swapper
feature to make this easy:

- Press ++end+1++ to ++9++ to insert floppy number 1 to 9 into drive
  DF0: (the first floppy drive).

- By default, the disk swapper targets the first floppy drive. To insert a
  floppy into any of the four drives, you need to select the target drive
  with ++end+ctrl+1++ to ++4++ first.

For example:

- To insert the second game disk into drive DF0: (first drive), press ++end+2++.
- To insert the third game disk into drive DF1: (second drive) next, press
  ++end+ctrl+2++ to select the second drive as the target, then  ++end+3++ to
  insert the third disk.
- To insert the fourth game edisk into DF0: again, press ++end+ctrl+1++
  followed by ++end+4++ .


!!! warning "Not all keyboards are created equal"

    You might not be able to use some of the drive selection shortcuts
    (++end+ctrl+1++ to ++4++) if you do not have a *3-key rollover* (3KRO) or
    better keyboard.


## Workbench

Most floppy games start automatically when you launch their configs, but
some need to be started manually from the Workbench screen.

The Workbench is the graphical interface of AmigaOS. It is a very simple
graphical operating environment that resembles the Windows desktop. To launch
the game from Workbench, usually you need to double-click on a disk icon in
the upper right corner which opens a window, then double-click on the game's
icon in that window.


## Speeding up loading times

To reduce loading times, use _warp mode_ that speeds up the emulated Amiga to
faster-than-realtime (as fast as your computer can handle). You can toggle
warp mode with the ++end+pause++ shortcut.

!!! warning

    *Never* increase the floppy emulation speed of WinUAE as that will break
    most disk-based copy protections. It might initially seem that all is
    fine, but many games *do not* advertise if their protection checks failed!
    They will casually let you keep playing but put the game silently into an
    unwinnable state.

    Warp mode works 100% reliably because it speeds up the whole emulated
    computer, not just the floppy drive separately from the rest of the
    system.

!!! tip "ProTip(tm)"

    If you know what you're doing, you can create a [save
    states](save-states.md) right after the game finished loading. You can
    save this as a new config and use it to start the game instantaneously.


## Saving your progress

Some games give you continuation codes at certain checkpoints, while others
let your save your progress to disk whenever you want. Some other games don't
have any built-in continuation or save support---luckily, you can use WinUAE
[save states](save-states.md) for these.

### Save disks

Many floppy games support saving your progress to disk. Most such games
require you to use a dedicated _save disk_ for this purpose. The collection
includes blank save disks for these games for convenience. This disk is
located in the `Savedisk` subfolder of the game's folder, and it's always
available in the 9th disk swapper slot (so you can insert the save disk by
pressing ++end+9++).

Some games ask you to enter a full path of your save file, e.g.,
`DF0:MySave1`, or you might need to enter `DF0:` and press enter to list
the save games on the floppy in the first drive. Make sure *not* to leave the
semicolon off in such scenarios. The semicolon after **DF0:** signals that
we're dealing with a drive, not just a file called **DF0**. This is similar to
the **C:** drive in Windows.

!!! warning "Not all blank disks are created equal"

    Always use the save disk included with the game. A regular empty AmigaDOS
    ADF disk image won't work with games that use special encoding schemes
    (e.g., [Canon Fodder](TODO)). A blank save disk is always included in a
    ZIP archive as well, should you want to reset your save disk.

!!! tip "ProTip(tm)"

    If you know what you're doing, feel free to create your own save disks.
    You'll need to consult the game's manual to do so as the exact steps vary
    per game.

    Always use _Extended ADF_ images for save disks that are about 2 MB in
    size. The regular 880 KB ADF images will give you problems in many games.


### Saving to the game disk

Some games save your progress directly to the game disk. These games are
configured to never modify the original floppy images, but to create
so-called _save images_ instead that only contain the changes compared to the
original disks.

Save images have the `.save_adf` file extension and are located in the
`Disks` folder within the game folder next to the game disks.

If you wish to revert such "virtually modified" game disks to their original
pristine state, click on the **Delete save image** button in the **Floppy**
configuration tab TODO. TODO tick
writeable checkbox?

Alternatively, you can delete the `.save_adf` file manually.

!!! tip "ProTip(tm)"

    Of course, the resourceful among you can create copies of these save
    images to emulate multiple save points in games that only support a single
    save slot.


