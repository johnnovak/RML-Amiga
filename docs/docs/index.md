# User manual

## Introduction

Welcome to this curated collection of (mostly) cerebral Amiga
games! Adventures, RPGs, simulators, strategy, board and puzzle games are the
stars of the show, but a small number of arcade classics are also
included.


What differentiates this from all other Amiga game collections? Quite a few
things:


Authentic experience
: Every single game has been painstakingly set up for an optimal and
  authentic experience. The primary goal is to run unaltered originals on the
  systems they were developed for, which is a stock or expanded Amiga 500 for
  most titles.

Play floppy games like a boss
: Every floppy game comes pre-configured to use multiple disk drives if the game
  supports it. This means reduced or zero disk swapping in the best case.
  Blank save disks are also provided per game (creating these is often tedious
  and error-prone).

No more bad cracks
: For games designed to run from floppies, the original floppy
  images are preferred with the disk-based protection intact. Cracks,
  WHDLoad, and other hacks are avoided and are only used as a last resort.
  No more worrying about bad cracks in those 40+ hour RPGs!

Native hard drive installations
: Hard drive installations are preferred for games that natively support it.
  That's most big American releases, and many European RPG, adventure, and
  strategy titles.

Authentic CRT monitor emulation
: Pixel art drawn and intended to be viewed on Commodore CRT monitors looks
  broken on modern flat screen with the pixels displayed as razor sharp little
  rectangles. A CRT shader setup is included that authentically recreates the
  look of Commodore monitors people typically used their Amigas with.

PAL/NTSC & aspect ratio correctness
: All games are correctly set up for PAL or NTSC, prioritising developer
  intent. No more playing American releases with squashed graphics and 20%
  slower music or gameplay! Moreover, PAL games that assume "NTSC stretch" are
  correctly set up, too.

All necessary information included
: Manuals, code wheels, reference cards, box art, audio recordings, and
  various other extras are all included.


## Why play Amiga games?

Because they're fun! Duh.

More seriously, what's the point when most of these games have been ported to
DOS, so you might as well just play the DOS version in [DOSBox
Staging](https://dosbox-staging.github.io/)?

TODO


## Hardware requirements

The collection has been developed and tested on Windows 10 64-bit. It will
most likely work fine on more recent Windows versions, and probably on Windows
7 64-bit too.

Only 64-bit Windows versions are supported.

The CRT shader setup is optimised for 1080p monitors (1920&times;1080
resolution), but should work on any display. A variable refresh rate (VRR),
adaptive-sync display (e.g., Nvidia G-Sync or AMD FreeSync capable) is not
mandatory but highly recommended for an optimal experience.

A dedicated GPU released after 2015 is recommended. Integrated graphics
adapters might work too, but some tweaking of the defaults might be required.


## How to use the collection

The basic usage is very simple: follow the [Installation
instructions](#installation), read the tips below, then try a few games!


!!! warning "HALT! No one shall pass before reading this first!"

    If you've never used an Amiga before, you will _not_ get very far without
    reading this getting started section. You will probably not even make it
    past the intro of your first game...

    So please read these tips very carefully!

    Seasoned Amiga veterans who know the Amiga inside out should also read
    this because half of the information is emulation-related.


Starting a game

: Start the bundled portable Amiga emulator (`winuae.exe`). This should bring
  up the configuration browser. If the **Games** folder is not expanded,
  double-click on it to open it. You can use the search box to narrow down the
  list of game configs. Double-click on a config and the game will start (note
  that floppy games might take a bit of time to load).

      Alternatively, select a game from the list by single clicking on it,
      click on the **Load** button below the configuration browser, then click
      **Start** to launch the game.

      If you want to play a different game, it's best to quit WinUAE with
      ++alt+f4++ then start it again.

Skipping code checks
: Some games have additional special configs to skip the intro or the
  manual-based copy protection check at startup (e.g., `Altered Destiny [skip
  code check]`). It's advised to start the normal config for the first time,
  just to experience the original game at least once.


Use warp mode
: You can speed up floppy loading times by using "warp mode". This speeds up
  the emulation as much as your computer can handle it. Pressing ++end+pause++
  toggles warp mode; .

Read the manual

: It's important to understand that control schemes and user interfaces were a
  lot less standardised in the 1980s and early '90s. You won't get very far in
  most games without reading the manual or the reference card first. Look for
  these in the `Manuals` and `Extras` sub-folders within the individual game
  folders.

Joystick-based games

: Most games in the collection are controlled with the mouse and the keyboard,
  but a few need a joystick. These games are configured for an emulated
  joystick: use the regular cursor keys (not the numeric keypad) for movement, and the
  ++ralt++, ++rshift++, or ++rctrl++ key for the fire button. If you want to
  use a real joystick or a gamepad, press the fire button on the controller
  after starting the game and WinUAE will auto-detect it.

Floppy games
: Hard drive installed games are the easiest to deal with, floppy games need a
  bit of practice. Read the [Floppy games](#floppy-games) section for details.
  You can easily recognise a floppy game by the emulated floppy drive sounds.

Saving your progress
: When it comes to saving your game progress, it's a bit of a Wild West
  situation. Every game is slightly different, and floppy games that require
  dedicated save disks are the trickiest. But fear not, help is provided for
  you on the [Game notes](game-notes.md) page for these titles. Make sure to
  read the detailed [Saving your progress](#saving-your-progress) section as
  well for general tips.

Read the game notes
: Always check the [Game notes](game-notes.md) page for special instructions
  when trying a game for the first time. Some of the advice there is very hard
  to figure out on your own, or the information is deeply buried in the
  manual.

Customising your setup
: If you're a power user, you should definitely configure the games for proper
  vertical syncing (vsync) for the best results. This is an advanced topic
  detailed in the [Graphics customisation](#graphics-customisation) section.
  TODO

Useful websites

: These websites should help you find out more about Amiga games and
  decide which title to try next:

    - [Hall of Light](https://amiga.abime.net/) — The database of Amiga games

    - [Lemon Amiga](https://www.lemonamiga.com/) — Another popular database of Amiga games with user reviews

    - [Amiga Reviews](https://amigareviews.leveluphost.com/) — 7811 reviews of 2375 games from UK Amiga magazines

    - [Amiga Love](https://www.amigalove.com/games.php) — Comprehensive Amiga game reviews

    - [Moby Games](https://www.mobygames.com/game/platform:amiga/sort:moby_score/) — List of best Amiga games (ranked by user ratings)

    - [Moby Games](https://www.mobygames.com/game/platform:amiga/sort:critic_score/page:1/) — List of best Amiga games (ranking by professional critics)


## Installation

The collection is split into several packs: **Base**, **Systems**, **ROMs**,
**Games** and **Demos**.

The **Base** and **Systems** packs are mandatory. The **ROMs** packs is not
necessary if you have acquired the ROM files from other sources (see
[Supplying your own Kickstart ROMs](#supplying-your-own-kickstart-roms)).

You can either download the entire **Games** pack (recommended), or,
alternatively, only grab the games you're interested in. Each game resides in
its own ZIP archive.

Links to the latest versions of the packs:

<div class="compact" markdown>
- [RML-Amiga-Base-v1]()
- [RML-Amiga-Systems-v1]()
- [RML-Amiga-ROMs-v1]()
- [RML-Amiga-Games-v1]()
- [RML-Amiga-Demos-v1]()
</div>

Download the packs, then extract all ZIP archives into the same folder (e.g.,
`D:\Emulation\Amiga\RML-Amiga`). We will refer to this folder as `$RML_BASE`
from now on.

If you already have WinUAE installed, no problem. The collection uses its own
copy of WinUAE in portable mode, so it won't interfere with any existing
installations. The included WinUAE will never save any data outside of the
`$RML_BASE` folder.

It's a good idea to create a shortcut for ``$RML_BASE\winuae.exe` on your
desktop at this point.

!!! warning "This voids your warranty, pal!"

    The games are only guaranteed to work with the bundled WinUAE version.
    Switching to any other version is asking for trouble---don't do it.


### About the packs

Here is a detailed descriptions of the packs:

- **Base** -- Contains 64-bit versions of WinUAE, the IPF disk image plugin, a
  custom-compiled version of ReShade (with auto-updates and the nag screen
  removed), and the CRT shader setup.

- **Systems** --- Minimal Workbench 1.3 and 3.1 hard drive setups as directory hard disks.
Just the bare minimum to run the games. The 3.1 installation also
contains WHDLoad.

- **ROMs** --- Various ROM images (e.g., Kickstart ROMs) necessary to emulate the various Amiga models. _(Note: The Amiga is not a console. Games are not called "ROMs" on the Amiga.)_

- **Games** --- Can you guess?

- **Demos** --- Glorious demoscene productions from the Amiga's heyday (and
    beyond!)


The **Games** and **Demos** archives will get the most frequent updates, the
rest very rarely.


!!! note "The practical reality we live in"

    The main reason for separating out the Kickstart ROMs and the minimal hard
    drive-based systems is to be able to share the collection on channels that
    don't want to risk harassment from the current rightholders of the Amiga Kickstart ROMs.

    In a practical sense, no one gives a damn about these 30+ years old ROMs
    anymore, so whether you buy them "legally" or just download the ROM files
    from somewhere makes little difference. Up to you, really. If you decide
    to pay for them, make sure to purchase the full ROM set, not the "value
    edition".


### Supplying your own Kickstart ROMs

If you've acquired the Kickstart ROMS from alternative sources, this is how to
install them. Unpack the base and system packs first, then do the following:

- For WinUAE, you can simply chuck all the ROM files you have into `$RML_BASE/ROMs` and
  WinUAE will auto-detect them by their contents on the first startup. The
  filenames don't matter. You can force a re-scan by pressing the **Rescan
  ROMs** button in the **Paths** WinUAE configuration tab.

- For the very few WHDLoad games in the collection, you'll need to copy
  the Amiga 500 and Amiga 1200 ROMs into the
  `$RML_BASE/System-3.1/Devs/Kickstarts` directory. You'll need to name them
  `kick34005.A500.RTB` and `kick40068.A1200.RTB`, respectively.

These are the ROM files actually used by the setup:

**Amiga 500**

You need _either one_ of the following (any will do):

```
Kickstart v1.3 r34.5 (1987)(Commodore)(A500-A1000-A2000-CDTV)[!].rom
SHA-1: 891e9a547772fe0c6c19b610baf8bc4ea7fcb785
```

```
Kickstart v1.3 r34.5 (1987)(Commodore)(A500-A1000-A2000-CDTV)[o].rom
SHA-1: 90933936cce43ca9bc6bf375662c076b27e3c458
```

```
amiga-os-130.rom
(alternative name: kick130.rom)
SHA-1: c39bd9094d4e5f4e28c1411f3086950406062e87
```

**Amiga 1200**

```
Kickstart v3.1 r40.68 (1993)(Commodore)(A1200)[!].rom
(alternative name: amiga-os-310-a1200.rom)
SHA-1: e21545723fe8374e91342617604f1b3d703094f1
```

**Amiga CD32**

You need _both_ files:

```
Kickstart v3.1 r40.60 (1993)(Commodore)(CD32).rom
(alternative name: amiga-os-310-cd32.rom)
SHA-1: 3525be8887f79b5929e017b42380a79edfee542d
```

```
CD32 Extended-ROM r40.60 (1993)(Commodore)(CD32).rom
(alternative name: amiga-ext-310-cd32.rom)
SHA-1: 5bef3d628ce59cc02a66e6e4ae0da48f60e78f7f
```


## Hard drive installed games

Games that run from an emulated hard drive are the easiest to deal with. First
of all, they load much faster than floppy games and you don't need swap disks.
Secondly, most of these games can save your progress to the hard drive, so you
don't need to deal with save disks either.


## Floppy games

All Amigas come with one floppy drive as standard equipment, but they can be
optionally expanded to up to four drives in total. The first floppy drive is called
**DF0** (**D**rive **F**loppy **0**), the second **DF1**, the third **DF2**,
and the fourth **DF3**.

Most floppy games are in the **IPF** format (Interchangeable Presentation Format).
These are exact copies of the original disks with the copy protection intact.

A small set of games are provided as regular **ADF** files (Amiga Disk File).
These games either don't use copy protection, or are only available
in cracked from.


### Single-disk games

All floppy game configurations have the first floppy pre-inserted in the
first drive (DF0). For single-disk games, that's all you need.


### Multi-disk games

Multi-disk games fall into two categories: some support multiple drives, some
only a single drive. The best case scenario is when a game supports as many
drives as the number of disks it comes on. Such games are configured with the
game disks pre-inserted into each drive. One example is **Lemmings** (a two
disk game) and **Perihelion** (a four disk game).

The other scenario is that the game supports *less* drives than the number of
disks it comes on (e.g., a two disk game supporting a single drive, or a four
disk game supporting two drives). In these games, you'll need to swap the
disks when the game prompts you. Fortunately, WinUAE has a convenient
disk swapper feature to make this easy:

- Press ++end+1++ to ++9++ to insert floppy number 1 to 9 into the first drive
(DF0).

- By default, the disk swapper targets the first floppy drive. To insert a
  floppy into any of the four drives, you need to select the drive
  with ++end+ctrl+1++ to ++4++ first.

For example:

- To insert the second floppy into the first drive (DF0), press ++end+2++.
- To insert the third floppy into the second drive (DF1) next, press ++end+ctrl+2++
  to select the second drive, then  ++end+3++ to insert the third floppy.
- To insert the fourth floppy into the first drive again, press ++end+ctrl+1++
  then ++end+4++ .


!!! warning "Not all keyboards are created equal"

    You might not be able to use some of the drive selection shortcuts
    (++end+ctrl+1++ to ++4++) if you do not have a *3-key rollover* (3KRO) or
    better keyboard.


### Speeding up floppy loading times

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

    If you know what you're doing, you can create a [savestate](#) right after
    the game finished loading. You can save this as a new config and use it to
    start the game instantaneously.




## Saving your progress

Some games give you continuation codes at certain checkpoints, while others
let your save your progress to disk whenever you want. Some other games don't
have any built-in continuation or save support---luckily, you can use WinUAE
[Save states](#save-states) for these.

Let's have a look at each of these options!


### Dedicated save disks

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


### Saving to the game disk

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


### Hard drive games

Most hard drive installed games store the save games on the hard drive; using
the save and restore game functionality in these games should be
straightforward. A minority of games insist on using a save disk even when
installed to the hard drive---these special games are mentioned on the [Game
notes](game-notes.md) page.

:material-folder-open:
:material-file-outline:
:material-arrow-left-top-bold:


### Save states

TODO


## Customising your setup

### Graphics customisation

TODO

### Input customisation

TODO


## Keyboard shortcuts

<div class="compact" markdown>
| Shortcut                   | Description                                            |
| --------                   | -----------                                            |
| ++f12++                    | Pause emulation and bring up the WinUAE GUI            |
| ++end+f12++                | Toggle full windowed and windowed mode                 |
| ++pause++                  | Toggle pause                                           |
| ++end+pause++              | Toggle warp mode (speed up the emulation)              |
| ++end+ctrl+1++ -- ++4++    | Disk swapper: select target floppy drive               |
| ++end+1++ -- ++9++         | Disk swapper: insert disk 1 to 9 into the target drive |
| ++end+f1++ -- ++f4++       | Insert floppy image into DF0 -- DF3                    |
| ++end+shift+f1++ -- ++f4++ | Eject floppy image from DF0 -- DF3                     |
| ++end+f4++ | Eject floppy image from DF0 -- DF3                     |
| ++end+print-screen++       | Save screenshot                                        |
</div>

!!! warning "Not all keyboards are created equal"

    You might not be able to use some of the 3-key shortcuts if you do not
    have a *3-key rollover* (3KRO) or better keyboard.


## Folder organisation

<div class="dir-tree" markdown>

- :material-folder-open: **Configurations**
- :material-folder-open: **Games**
    - :material-folder-open: **Another World**
        - :material-folder-open: **Extras**
            - Another World - Manual.pdf
            - Another World - Front Cover.jpg
            - Another World - Back Cover.jpg
        - :material-folder-open: **Game**
            - AnotherWorld.ipf
        - :material-folder-open: **Savestates**
- :material-folder-open: **Screenshots**
- :material-folder-open: **WinUAE**
    - :material-folder-open: **ROMs**

</div>




