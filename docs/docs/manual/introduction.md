# Introduction

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

