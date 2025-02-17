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

Most hard drive games start automatically when you launch their configs, but
some need to be started manually from the so-called Workbench screen.

The Workbench is the graphical interface of AmigaOS. It is a very simple
graphical operating environment that resembles the Windows desktop. To launch
a game from Workbench, double-click on the disk icon located in the upper
right corner which opens a window, then double-click on the game's icon in
that window.

A few games have additional icons to launch the game with different options
(e.g., [King's Quest: Quest for the Crown (SCI)](TODO)), or to start extra
programs included with the game, such as level editors (e.g.,
[SimCity Collection](TODO)). So that's one of the reasons why some games don't
auto-start.

The other reason is that a handful of games feature beautifully designed icons
and Workbench screens with custom colour schemes. These works of art are worth
preserving, and to date RML Amiga is the only games collection that attempts
to do so.

Here are some good examples:

- [The Secret of Monkey Island](TODO)
- [Legend of Faerghail](TODO)
- [Pirates!](TODO)
- [Art of GO, The](TODO)
- [Battle Chess (OCS)](TODO)
- [Champions of Krynn](TODO)
- [Death Knights of Krynn](TODO)


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
special snowflakes---make it your habit to always check these notes before
playing a new game.

!!! danger "Patience is a virtue"

    _Never ever_ reset the emulated Amiga or quit the emulator _immediately
    after_ saving your game to the hard drive! Always wait 2-3 seconds and
    make sure the hard drive activity LED indicator in the bottom-right corner
    isn't flashing red anymore (red means write activity, green means read
    activity). If you don't wait, there is a good chance you'll lose or
    corrupt your save game!

    The reason for this is that hard drive writes happen in a slightly delayed
    manner on the Amiga.


## Key disks

One of the major selling points of the collection is preferring uncracked
originals. Some hard drive installable games need a so-called "key disk"
(usually the first game disk) to be present in drive DF0: (the first floppy
drive). This is a form of copy protection: the key disk contains some special
areas that cannot be copied by standard Amiga floppy drives. The game checks
the key disk at startup and perhaps even at later during the game, and if it's
not present or an illegitimate copy is detected, BadThings(tm) will happen.
This can range from polite error messages to outright crashes, black screens,
and hard reboots.

Such games have the key disk already pre-inserted in DF0: so you don't need to
do anything. This is just worth calling out as some people might be confused
by the floppy activity when starting key disk protected games.


## WHDLoad games

A handful of games in the collection use something called WHDLoad. This is a
tool people invented in the mid-1990s to play disk-only games from the hard
drive on their later Amiga models (such as the Amiga 1200). The tool was also
used to apply compatibility fixes to finicky games that only ran correctly on
a stock (or close-to-stock) Amiga 500.

This means WHDLoad conversions are not originals but cracked and patched games
(disk-based protections had to be bypassed and the game's disk access code
rewritten so it can run from a hard drive). RML Amiga uses WHDLoad games only
as a last resort because removing the copy protection and altering the games'
code can introduce all sorts of problems, including making the game
uncompletable. Issues introduced by these hacks are really hard to test in
long 50+ hour RPGs; consequently, WHDLoad conversions of long and complex
games are plagued with the most problems because they don't get enough
testing.

Back in the day, WHDLoad was a necessity to allow people enjoy their game
collections on their new Amigas. But for games that are natively hard drive
installable (70% of the games in this collection), using WHDLoad is rather
pointless in an emulator context where we can set up every Amiga model
imaginable.

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

