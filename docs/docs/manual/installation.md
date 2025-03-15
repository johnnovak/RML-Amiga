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


## Fully automatic installation

The easiest way to install RML Amiga is to download all the five packs and
`install-full.bat` (it's included in the **Base** pack [here](TODO)), then
put all of them into a folder where you want the collection to live. This must
be outside of `C:\Program Files` or similar system folders (e.g.,
`D:\Emulation\Amiga\RML-Amiga`).

Double-click on `install-full-v10.bat` in Windows Explorer, then wait 5-10 minutes
until the installation finishes. You will be informed of the progress of
this in the appearing window.

Once the installation has succeeded, you can start WinUAE (the Amiga
emulator) by running `winuae.exe` from your RML Amiga folder. It's a good idea
to create a shortcut to `winuae.exe` on your desktop at this point.

It's important to note that RML Amiga is fully self-contained in this folder
of your choosing; in other words, it's portable. Using the collection won't
create or modify any files outside of your RML Amiga folder, so you can move
it between different drives or even different computers without any problems.

Now let's play some games! Onwards to the
[Getting started](getting-started.md) section!


## Manual installation

This is for people who want complete control over what to install exactly
(e.g., if you don't want to download all games, just a few), and for those who
have problems with using certain parts of the collection for whatever reasons
(e.g., the Kickstart ROMs).

Start by downloading the **Base** and **Systems** packs---these are mandatory.
The **ROMs** pack is not necessary if you have acquired the ROM files from
other sources (see
[Supplying your own Kickstart ROMs](#supplying-your-own-kickstart-roms)).

Once you've downloaded these packs, extract them into a folder you have full
write access to (e.g., `D:\Emulation\Amiga\RML-Amiga`). We will refer to this
folder as `$RML_BASE` from now on.

!!! note 

    If you already have WinUAE installed, no problem. The collection uses its
    own copy of WinUAE in portable mode, so it won't interfere with existing
    installations. The included WinUAE will never save any data outside of the
    `$RML_BASE` folder.

Now download the **Games** pack and `install-games-v10.bat`, and **Demos** and
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


## About the packs

Here is a detailed descriptions of the packs:

- **Base** -- Contains 64-bit versions of WinUAE, the CAPS IPF disk image
  plugin, a custom-compiled version of ReShade (with auto-updates and the nag
  screen disabled), and the CRT shader setup.

- **Systems** --- Minimal Workbench 1.3 and 3.1 hard drive setups as directory
  hard drive. Just the bare minimum required to run games. The Workbench 3.1
  installation contains WHDLoad as well. Half the commercial games include
  similar minimal OS setups on the game disks, so this should not be a problem
  for anyone.

- **ROMs** --- ROM images (e.g., Kickstart ROMs) necessary to emulate
  the various Amiga models and other required hardware. (Note: The Amiga is
  *not* a console! Games are *not* called "ROMs" on the Amiga!)

- **Games** --- Nested ZIP archive with each game having its own
  self-contained ZIP file. Each game lives in its own dedicated subfolder
  which contains the disk images or directory hard drives, manuals, extras,
  savedisks, savestates, and the original source media.

- **Demos** --- Glorious demoscene productions from the Amiga's heyday (and
  beyond!). It's a nested ZIP archive, just like the **Games** pack.


The **Games** and **Demos** archives will get the most frequent updates, the
rest only rarely.

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


## Supplying your own Kickstart ROMs

If you've acquired the Kickstart ROMS from alternative sources, this is how to
install them:

- Identify the appropriate ROM files by checking their hashes, then copy them
  into `$RML_BASE/ROMs`. The file names must be matching _exactly_ the names
  listed below, so might need to rename them. WinUAE should then detect the
  available ROM files at first startup. You can force a re-scan by pressing
  the **Rescan ROMs** button in the **Paths** WinUAE configuration tab.

- Copy the Amiga 500 and Amiga 1200 ROMs into the
  `$RML_BASE/System-3.1/Devs/Kickstarts` folder, then rename them to
  `kick34005.A500.RTB` and `kick40068.A1200.RTB`, respectively. This is needed
  for the handful of WHDLoad games in the collection.


These are the ROM files required by the setup:

### Amiga 500

**Kickstart v1.1**

Only required by very few games.

```
Kickstart-v1.1-rev31.34-1985-Commodore-A1000.NTSC.rom
SHA-1: 4192c505d130f446b2ada6bdc91dae730acafb4c
```

**Kickstart v1.2**

Only required by very few games.

```
Kickstart-v1.2-rev33.166-1986-Commodore-A1000.rom
SHA-1: 6a7bfb5dbd6b8f179f03da84d8d9528267b6273b
```

**Kickstart v1.3**

The vast majority of games require Kickstart 1.3.

```
Kickstart-v1.3-rev34.50-1987-Commodore-A500-A1000-A2000-CDTV.rom
SHA-1: 891e9a547772fe0c6c19b610baf8bc4ea7fcb785
```

### Amiga 1200

```
Kickstart-v3.1-rev40.68-1993-Commodore-A1200.rom
SHA-1: e21545723fe8374e91342617604f1b3d703094f1
```

### Commodore CDTV

Same Kickstart v1.3 ROM which is required for the Amiga 500, plus the extended
CD32 ROM.


```
Kickstart-v1.3-rev34.50-1987-Commodore-A500-A1000-A2000-CDTV.rom
SHA-1: 891e9a547772fe0c6c19b610baf8bc4ea7fcb785
```

```
CDTV Extended-ROM v2.7 (1992)(Commodore)(CDTV).rom
SHA-1: 5bc114bba29f60a614a311745b3e2464bfa06846 

```

### Amiga CD32

_Both_ files are required:

```
Kickstart-v3.1-rev40.60-1993-Commodore-CD32.rom
SHA-1: 3525be8887f79b5929e017b42380a79edfee542d
```

```
CD32 Extended-ROM r40.60 (1993)(Commodore)(CD32).rom
SHA-1: 5bef3d628ce59cc02a66e6e4ae0da48f60e78f7f
```


### Roland MT-32

Only required by very few games that support Roland MT-32 sound. These must be
in `$RML_BASE\ROMs\mt32-roms\`:

```
ctrl_cm32l_1_02.rom
SHA-1: a439fbb390da38cada95a7cbb1d6ca199cd66ef8 
```

```
ctrl_mt32_1_07.rom
SHA-1: b083518fffb7f66b03c23b7eb4f868e62dc5a987 
```

```
pcm_cm32l.rom
SHA-1: 289cc298ad532b702461bfc738009d9ebe8025ea 
```

```
pcm_mt32.rom
SHA-1: f6b1eebc4b2d200ec6d3d21d51325d5b48c60252 
```
