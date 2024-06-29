# Floppy games

All Amigas come with one floppy drive as standard equipment, but they can be
optionally expanded to up to four drives in total. The first floppy drive is called
**DF0** (**D**rive **F**loppy **0**), the second **DF1**, the third **DF2**,
and the fourth **DF3**.

Most floppy games are in the **IPF** format (Interchangeable Presentation Format).
These are exact copies of the original disks with the copy protection intact.

A small set of games are provided as regular **ADF** files (Amiga Disk File).
These games either don't use copy protection, or are only available
in cracked from.


## Single-disk games

All floppy game configurations have the first floppy pre-inserted in the
first drive (DF0). For single-disk games, that's all you need.


## Multi-disk games

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


## Speeding up floppy loading times

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

