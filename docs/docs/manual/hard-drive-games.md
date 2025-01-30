# Hard drive games

Most of the big multi-disk adventure games and RPGs, especially the ones
developed by American studios, can be installed to an emulated hard drive.
Hard drive installed games are the easiest to deal with. First of all, they
load much faster than floppy games and you don't need swap disks. Secondly,
most of these games can save your progress to the hard drive, so you don't
need to deal with save disks either.


## Hard drive basics

The first hard drive is called **DH0** (**D**rive **H**ard **0**), the second
**DH1**, and so on. Most hard drive games in the collection use the following
two hard drive configuration:

- **DH0** contains a heavily stripped-down AmigaOS---just the bare minimum
  necessary for running games. This drive has the **System** label.

- **DH1** contains the game itself and usually has the label **Game**, but
  this can vary (e.g., **ChampionsOfKrynn**, **PopulousII HD**, **LEGEND.0**,
  etc.). This drive is mapped to the `Harddisk` folder inside the game folder,
  which is just a regular Windows folder; you have full access to its contents
  from Windows. This is handy if you want to back up your save games or you
  want to transfer your characters in RPG series.

A small number of games that need very specific OS setups only use a single
**DH0** drive which contains both the OS and the game.


## Workbench

TODO link to floppy games

Some games have additional icons to launch the game with different options, or
for extras like level editors, etc. --- check the [Game
notes](../games/index.md) for details.



## Saving your progress

Most hard drive games store the save games on the hard drive; using the
in-game save and restore feature is usually straightforward in such games (but
in some the save game menu is a bit hidden; make sure to consult the manual if
you can't find it). If a game asks you to select the location of your save
file and lets you to use any location, you should use the **DH1** drive unless
the [Game notes](../games/index.md) instructs you otherwise.

There are some outliers, though. A handful of games insist on saving to a
floppy disk even when installed to the hard drive (e.g., [Future Wars](TODO)).
Then some RPGs save the "state of the world" to the data files as you keep
progressing through the game, so starting a new game with a new character
requires a full reinstall ([Amberstar] and [Demon's Winter] are such games).

The [Game notes](../games/index.md) contain detailed instructions for these
special snowflakes---make it a habit to always check these notes before
playing a new game.

!!! danger "Patience is a virtue"

    Never ever reset the emulated Amiga or quit the emulator _immediately_
    after saving your game to the hard drive! Always wait 2-3 seconds and make
    sure the hard drive activity indicator LED in the bottom-right corner
    isn't flashing red (red means write activity, green means read activity).
    If you don't do this, there is a good chance you'll lose or corrupt your
    save!

    The reasons for this is that hard drive writes usually happen in a
    slightly delayed manner on the Amiga. This is how things usually play out:

    - You do something that will cause writes to the hard drive (e.g., click
      the **Save** button in the save game dialog).
    - There is no hard drive activity for up to 1-2 seconds.
    - _After_ these 1-2 seconds, the actual write happens---the hard drive
      activity indicator is briefly flashing red.
    - The activity indicator then turns grey (no activity). Now
      it's safe to turn off you Amiga or quit the emulator.


## Key disks

One of the major selling points of the collection is preferring uncracked
originals. Some hard drive installable games need a so-called "key disk" to be
present in the drive DF0: (the first floppy drive). This is a form of copy
protection: what's stopping you from installing the game to all your friends'
Amigas? That's right, the key disk! This is usually the first disk of the game
that contains some special areas that cannot be copied by standard Amiga
floppy drives. The game checks the key disk at startup and perhaps even at
certain points later in the game, and if it's not present or an illegitimate
copy is detected, BadThings(tm) will happen. This can range from polite error
messages to outright crashes, black screens, and hard reboots.

Such games have the key disk already pre-inserted in DF0: so you don't need to do
anything special (unless the [Game notes](../games/index.md) tell you so). This
was just worth calling out as some people might be confused by the floppy
activity when starting key disk protected games.


## WHDLoad games

A handful of games in the collection use something called WHDLoad. This is a
tool people invented in the mid-1990s to play disk-only games from the hard
drive and to apply compatibility fixes to certain Amiga 500 games so they can
run on later models like the Amiga 1200.

This means WHDLoad conversions are effectively cracked and patched games, not
originals. RML-Amiga uses WHDLoad games only as a last resort because removing
the copy protection and altering the games' code can introduce all sorts of
problems (including making the game uncompletable which is really hard to test
in long 50+ hour RPGs).

Back in the day, WHDload was a necessity to allow people enjoy their game
collections on their new Amigas. But for games that are natively hard drive
installable (70% of the games in this collection), using WHDLoad is rather
pointless in an emulator context.

Games that support hard drive installations are OS-friendly by nature; they
must use operating system (OS) routines for hard drive access. But most floppy
games eschew the use of OS routines and interact with the floppy drive
controller directly. Therefore, WHDLoad conversions of floppy games running
from the hard drive have a new problem to solve. The save disk must be
emulated in memory, then the contents of this emulated disk is written to the
hard drive when exiting the game. The alternative solution is to do the saving
immediately in "real-time", but this gets even trickier as the OS and the
game's code need be swapped in and out of memory repeatedly as writing to the
hard drive is only possible via OS routines, but most floppy games "kill" the
OS at the start. The end result is the infamous flickering black screen in
WHDLoad conversions when saving and restoring a game, and an overall lengthy
save/restore process. As you can see, both solutions have their problems, but
saving to the emulated in-memory floppy is less jarring, therefore all WHDLoad
games in the collection are configured for that.

!!! important Always use the "quit key" in WHDLoad games

    The important point to remember is that you _must_ always exit WHDLoad
    games by pressing **F11** (the WHDLoad quit key) when you're finished with
    the game. If you don't do that, you'll lose your saves from the current
    gaming sessions! The [Game notes](../games/index.md) will remind you of
    this, and all WHDLoad games will also print out a similar warning before
    startup.

