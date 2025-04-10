# Installation

The collection is split into several packs: **Base**, **Systems**, **ROMs**,
**Games**, and **Demos**.

Links to the latest versions of the packs:

<div class="compact" markdown>
- [RML-Amiga-Base-v1.0](TODO)
- [RML-Amiga-Systems-v1.0](TODO)
- [RML-Amiga-ROMs-v1.0](TODO)
- [RML-Amiga-Games-v1.0](TODO)
- [RML-Amiga-Demos-v1.0](TODO)
</div>


## Automatic installation

The easiest way to install RML Amiga is to download all five packs and
`install-full.bat` (it's included in the **Base** pack [here](TODO)), then put
the packs and the batch file into a folder where you want the collection to
live. This must be outside of `C:\Program Files` or any system folders.
For example, `D:\Emulation\Amiga\RML-Amiga` is a good location.

Now double-click on `install-full-v10.bat` in Windows Explorer to start the
installation. A window will appear, you'll be asked a few questions, then
you'll be informed about the progress of the installation. The whole process
shouldn't take more than 5-10 minutes. I recommend to
read the [Why play Amiga games?](why-play-amiga-games.md) and [CRT
emulation](crt-emulation.md) chapters while waiting, especially if you're new
to the Amiga.

Once the installation has succeeded, you can start WinUAE (the Amiga
emulator) by running `winuae.exe` from your RML Amiga folder. It's a good idea
to create a shortcut for `winuae.exe` on your desktop at this point so you can
start it more easily.

!!! note "RML Amiga is fully portable"

    RML Amiga is fully self-contained in this folder of your choosing; in
    other words, it's portable. RML Amiga won't create or modify any files
    outside of its designated folder and it uses relative file paths
    everywhere. This means you can freely move it between different drives or
    even different computers without any problems.

You can safely skip the rest of this section if you went the automatic
installation route. Now it's time to play some games! Onwards to the [getting
started](getting-started.md) section!


## About the packs

Here is a detailed descriptions of the packs:

- **Base** --- Contains 64-bit versions of WinUAE, the CAPS IPF disk image
  plugin, a custom-compiled version of ReShade (with auto-updates and the nag
  screen disabled), and the CRT shader setup.

- **Systems** --- Minimal Workbench 1.3 and 3.1 hard drive setups as directory
  hard drives. Just the bare minimum required to run games (these files are
  included on many AmigaDOS floppy games as well). The Workbench 3.1
  installation contains WHDLoad too.

- **ROMs** --- ROM images (e.g., Kickstart ROMs) necessary to emulate
  the various Amiga models and other required hardware. (Note: The Amiga is
  *not* a console! Games are *not* called "ROMs" on the Amiga!)

- **Games** --- Nested ZIP archive with each game having its own
  self-contained ZIP file. Each game lives in its own dedicated subfolder
  which contains the disk images or directory hard drives, manuals, extras,
  savedisks, savestates, and the original source media.

- **Demos** --- Demoscene productions from the Amiga's glorious past (and
  present!). It's a nested ZIP archive, similarly to the **Games** pack.


The folder structure in all packs are relative to the `$RML_BASE` folder. In
other words, if you expand all archives into `$RML_BASE` (double-expand in
case of the **Games** and **Demos** packs), you'll get the correct folder
structure.

!!! note "The practical reality we live in"

    The main reason for separating out the Kickstart ROMs and the minimal hard
    drive-based systems is to be able to share the collection on channels that
    don't want to risk harassment from the current rightholders of the Amiga
    Kickstart ROMs.

    In a practical sense, no one gives a damn about these 30+ years old ROMs
    anymore, so whether you purchase them "legally" from the "current
    rightholders" (who are far removed from Commodore and the original
    creators of the Amiga) or just download them from somewhere makes very
    little difference in the grand scheme of things. Up to you, really. If you
    decide to pay for them, make sure to purchase the full ROM set, _not_ just
    the "value edition".


## Versioning & updates

"Point zero" versions of packages (e.g., v1.0, v2.0, v3.0, etc.) always
contain a snapshot of all the files in the collection.

"Point releases" (e.g., v1.1, v1.2. v1.3, etc.) are updates; they need to be
applied in order. So, for example, if you're currently on **Games** v1.2 and
you want to upgrade to the latest v1.5 release, you'll need to apply the v1.3,
v1.4, and v1.5 update packages _in order_.

The **Games** and **Demos** archives will get the most frequent updates, the
rest only rarely.


## Manual installation

This is for people who want complete control over their installation (e.g., if
you don't want to download all games, just a few), and for those who have
problems with using certain parts of the collection for whatever reasons
(e.g., the Kickstart ROMs).

Start by downloading the **Base** and **Systems** packs---these are mandatory.
The **ROMs** pack is not necessary if you have acquired the ROM files from
elsewhere (see [Supplying your own Kickstart
ROMs](#supplying-your-own-kickstart-roms)).

Once you've downloaded the packs, extract them into a folder you have full
write access to (e.g., `D:\Emulation\Amiga\RML-Amiga`). We will refer to this
folder as `$RML_BASE` from now on.

!!! note 

    If you already have WinUAE installed, no problem. The collection uses its
    own copy of WinUAE in portable mode, so it won't interfere with existing
    installations. The included WinUAE will never save any data outside of the
    `$RML_BASE` folder.

Now download the **Games** pack and `install-games-v10.bat`, then **Demos** and
`install-demos-v10.bat` if you're interested in watching glorious Amiga
demoscene productions. Move all these files into `$RML_BASE`, then run
`install-games-v10.bat` and `install-demos-v10.bat` (the installation will
take a while).

It's a good idea to create a shortcut to `$RML_BASE\winuae.exe` on your
desktop at this point.

!!! note 

    Alternatively, you can grab only the games you're interested in. Each game
    resides in its own ZIP archive inside the big **Games** ZIP file. You can
    view the list of nested ZIP files on archive.org by clicking on "View
    Files", then you can download them individually.

!!! warning "This voids your warranty, pal!"

    The games are only guaranteed to work with the bundled WinUAE version.
    Switching to any other version is asking for trouble---don't do it.


## Supplying your own Kickstart ROMs

If you've acquired the Kickstart ROMS from alternative sources, this is how to
install them:

- The easiest way is to copy all your ROM files into `$RML_BASE/ROMs`, then
  force a re-scan by pressing the **Rescan ROMs** button in the **Paths**
  WinUAE configuration tab. WinUAE will identify the ROM files by their CRC32
  checksums, so the file names don't matter.

- To get WHDLoad working (required by a handful of game), copy the Amiga 500
  (Kickstart 1.3 rev 34.50) and Amiga 1200 (Kickstart 3.1 rev 40.60) ROMs into
  the `$RML_BASE/System-3.1/Devs/Kickstarts` folder, then rename them to
  `kick34005.A500.RTB` and `kick40068.A1200.RTB`, respectively (the below table
  shows their typical file names in Kickstart ROM collections).


### ROMs

These are all the ROM files used by setup with their CRC32 checksums:

<div class="compact" markdown>
| Filename                                                         | CRC32      |
| --------                                                         | -----      |
| Kickstart-v1.1-rev31.34-1985-Commodore-A1000.NTSC.rom            | `D060572A` |
| Kickstart-v1.2-rev33.166-1986-Commodore-A1000.rom                | `9ED783D0` |
| Kickstart-v1.3-rev34.50-1987-Commodore-A500-A1000-A2000-CDTV.rom | `C4F0F55F` |
| Kickstart-v3.1-rev40.68-1993-Commodore-A1200.rom                 | `1483A091` |
| Kickstart-v3.1-rev40.60-1993-Commodore-CD32.rom                  | `1E62D4A5` |
| CDTV Extended-ROM v2.7 (1992)(Commodore)(CDTV).rom               | `CEAE68D2` |
| CD32 Extended-ROM rev 40.60 (1993)(Commodore)(CD32).rom          | `87746BE2` |
</div>


### Roland MT-32

These are only required by a handful of games that support Roland MT-32 sound.
You must copy these into `$RML_BASE\ROMs\mt32-roms\` and the file names must
match:

<div class="compact" markdown>
| Filename            | CRC32      | SHA-1                                      |
| --------            | -----      | -----                                      |
| ctrl_cm32l_1_02.rom | `B998047E` | `a439fbb390da38cada95a7cbb1d6ca199cd66ef8` |
| ctrl_mt32_1_07.rom  | `A7C1531B` | `b083518fffb7f66b03c23b7eb4f868e62dc5a987` |
| pcm_cm32l.rom       | `4B961EBA` | `289cc298ad532b702461bfc738009d9ebe8025ea` |
| pcm_mt32.rom        | `573E31CC` | `f6b1eebc4b2d200ec6d3d21d51325d5b48c60252` |
</div>

