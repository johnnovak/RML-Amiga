# Hard drive games

Most of the big multi-disk adventure games and RPGs, especially the ones
developed by American studios, can be installed to an emulated hard drive.
Hard drive installed games are the easiest to deal with. First of all, they
load much faster than floppy games and you don't need swap disks. Secondly,
most of these games can save your progress to the hard drive, so you don't
need to deal with save disks either.


## Hard drive basics

The first hard drive is called **DH0** (**D**rive **H**ard **0**), the second
**DH1**, and so on. Most hard drive games in the collection use two hard
drives:

- **DH0** contains a heavily stripped-down AmigaOS---just the bare minimum
  necessary for running games. This drive always has the **System** label.

- **DH1** contains the game itself and usually has the label **Game**, but
  this can vary (e.g., **ChampionsOfKrynn**, **PopulousII HD**, **LEGEND.0**,
  etc.). This drive is mapped to the `Harddisk` folder inside the game folder,
  which is just regular Windows folders; you have full access to its contents
  from Windows (which is handy when transferring your characters in RPG
  series).

A few games that need very specific OS setups only use a single **DH0** drive
which contains both the OS and the game. 


## Workbench

TODO link to floppy games

Some games have additional icons to launch the game with different options, or
for extras like level editors, etc. --- check the [Game
notes](../games/index.md) for details.



## Saving your progress

Most hard drive games store the save games on the hard drive so using the
in-game save and restore feature should be straightforward. If a game asks you
to select the location of your save file and lets you to use any location, you
should always use the **DH1** drive.

TODO check is DH0 can be made write protected

A handful games insist on saving to a floppy disk even when installed to the
hard drive (e.g., [Future Wars]), and some RPGs save the "state of the world"
to the data files, so starting a new game requires a full reinstall (e.g.
[Amberstar] and [Demon's Winter]).

The [Game notes](../games/index.md) contain detailed instructions for these
special games---make it a habit to always check these notes before playing a
new game.


## Key disks

One of the major selling points of the collection is preferring uncracked
originals. This means that some hard drive games need a so-called "key disk"
to be present in the first floppy drive (DF0). This is a form of copy
protection: some games allow hard drive installations, but then what's
stopping you from installing the game to all your friends' Amigas? The key
disk! This is usually the first disk of the game that contains some special
areas that cannot be copied by standard Amiga floppy drives. The game checks
the key disk at startup and perhaps even at certain points later in the game,
and if it's not present or an illegitimate copy is detected,
BadThings(tm) will happen. This can range from polite error messages to
outright crashes, black screens, and reboots.

Such games have the key disk already pre-inserted, so you don't need to do
anything special unless the [Game notes](../games/index.md) tell you so. This
was just worth explaining as some people might be confused by the floppy
activity when starting such games. Leave the key disk in DF0: as it's there
for good reason!


## WHDLoad games

TODO
