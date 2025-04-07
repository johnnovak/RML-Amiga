# Troubleshooting


## Restoring configs

A copy of the original configurations is stored in the `$RML_BASE\Original
Configurations` folder. These config are never changed. To revert one or more
configs, copy them from `Original Configurations` to `Configurations`.

To revert all configs, delete the `Configurations` folder, make a copy of
`Original Configurations`, then rename the copy `Configuration`.


## Scrolling jitter with vsync enabled

If you use the **Standard** vsync mode on a non-VRR (Variable Refresh Rate)
monitor with a 60 Hz desktop refresh rate, 60 Hz NTSC games will have
perfectly smooth scrolling without any jitter or tearing.

However, scrolling in 50 Hz PAL games will appear jittery (not smooth) because
of the 50 vs 60 Hz mismatch. The only way to make scrolling perfectly smooth
in 50 Hz PAL games on a non-VRR monitor is to set your desktop refresh rate to
50 Hz. You might need to create a custom resolution for this (e.g., in your
Windows settings or in Nvidia Control Panel).

The best option is to get a VRR monitor and use the **Off** vsync mode, then
you don't need to worry about setting 50/60 Hz manually.

!!! important "PAL, NTSC, and NTSC50"

    NTSC games need 60 Hz, PAL games need 50 Hz, but NTSC50 games also need 50
    Hz (hence the "50" in the name). They're basically PAL games, just the
    graphics assume the NTSC stetching factor.

    You can check whether a game is PAL, NTSC, or NTSC50 in the included game
    spreadsheet, or you can check the **Hardware / Chipset** tab in the WinUAE
    settings after loading the game config. If the **NTSC** checkbox is
    ticked, it's an NTSC game (set your desktop to 60 Hz), otherwise it's
    either PAL or NTSC50 (set it to 50 Hz).


## Distorted audio in NTSC games

If you set 50 Hz desktop refresh rate and you use the **Standard** vsync mode,
you'll get distorted audio in NTSC games running at 60 Hz. You need to either set vsync to
**Off** or set your desktop to 60 Hz to fix this.

Running 50 Hz PAL games with a 60 Hz desktop refresh rate won't result in
audio distortions, but smooth scrolling will appear jittery as explained in
the [previous point](#scrolling-jitter-with-vsync-enabled).


## Too much input lag

You're probably using the **Standard** vsync mode which noticeably increases
the input lag. Depending on your sensitivity, this can be annoying even in
games with mostly static screens because the mouse pointers can feel "laggy".

If you're on a VRR (Variable Refresh Rate) monitor, use the **Off** vsync mode
for the best results. This will result in  low input lag and no tearing.

On a non-VRR (fixed refresh rate) monitor, you can try disabling vsync too
(**Off** vsync mode). This will minimise the input lag, and as most RPG,
adventure, and strategy games feature mostly static screens, you will hardly
notice any tearing.

But in games that feature smooth scrolling and fast animations (most action
games), this will likely result in unacceptable levels of tearing. You might
want to experiment with the **Lagless** vsync mode in these games, but that
doesn't work in **Windowed** mode, only **Full-windowed** and **Fullscreen**.
You should use **Fullscreen** for the best results, and you'll need to find a
**Lagless vsync slices** setting that works well on your particular setup. You
might also need to increase the **Sound buffer size** if you're getting audio
dropouts.

If you're using a joystick, low-quality USB joysticks and joystick adapters
can be another source of increased input lag. Do your research and get another
joystick or adapter with confirmed low input lag.


## Black screen or stuck image at startup

You are probably using some global frame limiter, frame capper, or you have
changed the default global settings of your GPU driver to force vsync in all
programs.

The solution is to disable any such frame limiters and frame cappers for
WinUAE, and use the "let the application decide" vsync setting for WinUAE in
your GPU driver's settings.


## Weird vsync issues

If vsync behaves really erratically, see the [previous point](#black-screen-or-stuck-image-at-startup)---disable all
frame limiters and don't force vsync globally at the driver level.


## Mysterious random crashes

If WinUAE starts crashing with mysterious error messages out of the blue when
you try to start any game, some other program running on your system is
probably the culprit. These mysterious crashes might come and go; sometimes
they resolve themselves over time, sometimes a reboot fixes them, etc.

The root cause is that certain third-party programs and tools with OSD
(on-screen display) functionality will try to inject OSD messages into
WinUAE's videou output, but this will result in random crashes are they're
badly written (e.g., **Asus GPU Tweak** is one such program; other extra
programs included with GPU drivers can often introduce similar problems).

The only solution is to disable the OSD feature of these flaky programs or not
use them at all, and report these problems to their authors.
