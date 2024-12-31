# Customising your setup

## Graphics customisation

TODO

## Input customisation

TODO

## Sound customisation



You can customise the sound settings in the **Host / Sound** tab.

![Sound settings](img/sound-settings.png)

- **1** -- Adjust the **Master Volume**.

- **2** -- You can try to decrease the **Sound Buffer Size** for lower input latency and
    better audio-to-video sync, but too low settings might result in audio
    drop-outs and glitches.

- **3** -- The Amiga has four output channels hard-panned to left and right. The default **Stereo Separation** of 50% gives you a pleasant
    experience on headphones by mixing 50% of the left channels into the right
    channels and vice versa. You might want to set this to 100% (no
    crossfeed) if you're using speakers, or fine-tune the stereo separation to your
    liking.

- **4** -- Show/adjust **Floppy Drive Sound Emulation** settings for this drive.

- **5** -- You can adjust the floppy drive sound volume here for
    the drive selected with **6**.

- **6** -- Select **No sound** here to disable floppy sound for the selected drive.

- **7** -- Sound driver to use. **DSOUND** gives a good performance on
    most systems, but you might want to experiment with **WASAPI** or **WASAPI EX** if you want to achieve the lowest possible latency.

- **8** -- **Sample rate** of the sound emulation. This should be left at
  48000 (48 Khz) unless your audio device only supports 44.1 kHz, in which
  case change it to 44100.
