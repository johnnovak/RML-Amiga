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

Start by downloading the **Base** and **Systems** packs---these are mandatory.
The **ROMs** pack is not necessary if you have acquired the ROM files from
other sources (see
[Supplying your own Kickstart ROMs](#supplying-your-own-kickstart-roms)).

Download these packs, then extract them into the same folder (e.g.,
`D:\Emulation\Amiga\RML-Amiga`). We will refer to this folder as `$RML_BASE`
from now on.

!!! note 

    If you already have WinUAE installed, no problem. The collection uses its own
    copy of WinUAE in portable mode, so it won't interfere with existing
    installations. The included WinUAE will never save any data outside of the
    `$RML_BASE` folder.

After this, download the **Games** pack, and **Demos** if you're interested in
watching glorious Amiga demoscene productions. Move the **Games** and
**Demos** ZIP files into `$RML_BASE\Updates`, then run
`RML_BASE\install-updates.exe` (this will take a while).

It's a good idea to create a shortcut for `$RML_BASE\winuae.exe` on your
desktop at this point.

!!! note 

    TODO
    Alternatively, you can grab only the games you're interested in. Each game resides
    in its own ZIP archive inside the big **Games** ZIP file.

!!! warning "This voids your warranty, pal!"

    The games are only guaranteed to work with the bundled WinUAE version.
    Switching to any other version is asking for trouble---don't do it.


## About the packs

Here is a detailed descriptions of the packs:

- **Base** -- Contains 64-bit versions of WinUAE, the CAPS IPF disk image
  plugin, a custom-compiled version of ReShade (with auto-updates and the nag
  screen disabled), and the CRT shader setup.

- **Systems** --- Minimal Workbench 1.3 and 3.1 hard drive setups as directory
  hard drive. Just the bare minimum required to run games. The Workbench 3.1
  installation contains WHDLoad as well.

- **ROMs** --- ROM images (e.g., Kickstart ROMs) necessary to emulate
  the various Amiga models and other required hardware. (Note: The Amiga is
  *not* a console! Games are *not* called "ROMs" on the Amiga.)

- **Games** --- Each game has its own subfolder which contains the disk images
  or directory hard drives with the game files, manuals, extras, savedisks,
  savestates, and the original source media.

- **Demos** --- Glorious demoscene productions from the Amiga's heyday (and
  beyond!). Each demo has its own subfolder.


The **Games** and **Demos** archives will get the most frequent updates, the
rest only rarely.

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
    decide to pay for them, you'll need to purchase the full ROM set, not the
    "value edition".


## Versioning & updates

"Point zero" versions of packages (e.g., v1.0, v2.0, v3.0, etc.) always
contain a snapshot of all the files in the collection.

"Point releases" (e.g., v1.1, v1.2. v1.3, etc.) are updates; they need to be
applied in order. So, for example, if you're currently on **Games** v1.2 and
you want to upgrade to the latest v1.5 release, you'll need to apply the v1.3,
v1.4, and v1.5 update packages _in order_.


## Supplying your own Kickstart ROMs

If you've acquired the Kickstart ROMS from alternative sources, this is how to
install them. Unpack the **Base** and **System** packs first, then do the
following:

- Copy all the Kickstart ROM files you have into `$RML_BASE/ROMs` and
  WinUAE will auto-detect them by their contents on the first startup (the
  filenames don't matter). You can force a re-scan by pressing the **Rescan
  ROMs** button in the **Paths** WinUAE configuration tab.

- Copy the Amiga 500 and Amiga 1200 ROMs into the
  `$RML_BASE/System-3.1/Devs/Kickstarts` folder. You'll need to name them
  `kick34005.A500.RTB` and `kick40068.A1200.RTB`, respectively. This is needed
  for the small handful of WHDLoad games in the collection.


These are the ROM files needed by the setup:

**Amiga 500**

_Either_ of the following three files are required (only one):

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

**CDTV**

TODO


**Amiga CD32**

_Both_ files are required:

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

