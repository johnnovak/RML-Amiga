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
    isn't flashing red anymore (red means write activity, green means read
    activity). If you don't wait, there is a good chance you'll lose or
    corrupt your save game!

    The reason for this is that hard drive writes happen in a slightly delayed
    manner on the Amiga.


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
drive on their later Amiga models (such as the Amiga 1200). The tool was also
used to apply compatibility fixes to finicky games that only ran correctly on
a stock (or close-to-stock) Amiga 500.

This means WHDLoad conversions are effectively cracked and patched games, not
originals. RML Amiga uses WHDLoad games only as a last resort because removing
the copy protection and altering the games' code can introduce all sorts of
problems (including making the game uncompletable which is really hard to test
in long 50+ hour RPGs; consequently, WHDLoad conversions of long and complex
games are plagued with the most problems).

Back in the day, WHDload was a necessity to allow people enjoy their game
collections on their new Amigas. But for games that are natively hard drive
installable (70% of the games in this collection), using WHDLoad is rather
pointless in an emulator where we can set up every Amiga model imaginable.

!!! important Always quit WHDLoad games to save your progress to disk!

    Due to various technical difficulties, WHDLoad games only write the save
    games to the hard drive when you quit the game (the saves are kept
    in-memory until then).

    Therefore, you _must_ always quit WHDLoad games by pressing ++F11++ at the
    end of your gaming session! If you just close WinUAE or load a different
    game, _you will lose_ the saves you made in your current gaming session!
    All WHDLoad games in the collection print out a warning message about this
    at startup, and the [Game notes](../games/index.md) also contains some
    reminders.

