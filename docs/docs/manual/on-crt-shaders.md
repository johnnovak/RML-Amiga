# On CRT shaders

CRT shaders, "black borders" around the image; these are very divisive topics
in emulation circles, and the default graphics settings might not suit your
preferences. That's fine, we're all a bit different. Rest assured, you can
customise these settings to your liking, including turning off the CRT
emulation completely. But it's worthwhile to understand the reasoning behind
the defaults first before you change anything.

Out-of-the-box, RML Amiga emulates the output of a 15 kHz home computer CRT
monitor. Most people used their Amigas with such monitors in the 1980s and 90s
(e.g., the iconic [Commodore 1084S]()] or the [Philips CM8833-II]()). The
default 3.0x scaling mimics the physical dimensions of such 14" monitors
rather closely on 24 to 27" widescreen desktop displays (measure the diagonal
of the image in an NTSC game; it will be TODO cm on a 24" screen which is
close to the TODO cm image diagonal of a typical 14" CRT).

From a normal viewing distance, which was about 1.5 meters back in the day
(yes, _further_ away than the normal 1 meter we tend to use with modern flat
screens), this resulted in an image where you did not really see any pixels.
The relatively small image size combined with the beneficial smoothing effects
of CRTs produced an image that looked very smooth and strangely higher
resolution than it really was, even in 320&times;200 games! The CRT took off
the edges of the "pixels" and added a subtle texture to the image. The
perceived quality of a 320&time;200 game on such an Amiga setup rivalled the
experience of a 640&times;480 games on a much sharper 14" PC monitor. Yes, the
Amiga image was a bit blurrier and was lacking the detail of the 640&times;480
PC game, but it was _nowhere near_ the extreme blockiness of 320&times;200
content on PC monitors!

Let me stress this again: 320&times;200 content on the Amiga was _smooth_, not
blocky as on the PC!

This was due to the fundamental differences between Commodore and PC monitors.
Commodore monitors were effectively small high-quality TV sets with RGB input,
and PC monitors were the kings of sharpness, optimised for staring at
spreadsheets all day at work---at the detriment of everything else.

That's all good and well, but some games still look subjectively better with
the graphics slightly enlarged. For example, I like playing [Pinball Dreams]
with 4.0x scaling so it almost completely fills the screen. It's just more
immersive for me that way. You might as well want to adjust the image size
depending on your display size, viewing distance, and personal preference, and
you might want to use different scaling factors for different games.

However, be aware that as you start deviating from the "canonical" image size
(3.0x scaling factor), you will start seeing the "pixels", and the beneficial
blur of the CRT shaders will _also_ be enlarged, resulting in a subjectively
blurrier looking image. You can offset this by using the "sharp variant" of
the CRT shaders, which gets rid of the blurriness substantially but reduces
the smoothing effects, so the pixels will look blockier. Moreover, the
scanline effect will be more pronounced, especially with the NTSC shader. You
might want to use the PAL shader instead with higher NTSC scaling factors to
combat this.

As you can see, deviating from the default 3.0x scaling is all about
tradeoffs. Even on real CRT monitors, the experience is not the same on larger
17"-21" displays. You just need to pick what's more important to you:
authenticity and image quality, or size and "filling the display". The
collection chooses the first option by default.

 The [Customising your
setup](customising-your-setup.md) shows you how to do that.

 This is certainly a fascinating topic; you can read more about it [in my
article](TODO) that describes the shader setup in detail.
