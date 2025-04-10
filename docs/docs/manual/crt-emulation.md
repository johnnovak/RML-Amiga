# CRT emulation

CRT shaders, sharp pixels, black borders around the image---these are very
divisive topics in emulation circles, and the default graphics settings of RML
Amiga might not suit your preferences. That's fine, we're all a bit different.
Rest assured, you can customise these settings to your liking, including
turning off the CRT emulation altogether. But it's worthwhile to understand
the reasoning behind the defaults first before you change anything.

Out-of-the-box, RML Amiga emulates the output of a 15 kHz Commodore CRT
monitor. Most people used their Amigas with such monitors in the 1980s and 90s
(e.g., the iconic [Commodore 1084S]() or the [Philips CM8833-II]()). The
default 3.0x scaling mimics the physical dimensions of such 14" CRTs
rather closely on 24 to 27" widescreen desktop displays. Just grab a ruler and
measure the diagonal of the image in an NTSC game; it will be about 13" (33 cm)
on a 24" screen which is close to the diagonal of the viewable aread on a
typical 14" CRT.

So what, you might think. We have bigger and better monitors now, so why
not make the best of them and let the image fill the screen completely? Well,
because arguably that wouldn't be the "best" thing to do.

From a normal 1 to 1.5 meter viewing distance, the relatively small screen
size of a 14" monitor combined with the beneficial smoothing effects of CRTs
produced an image that looked very smooth and strangely higher resolution than
it really was. The CRT took off the edges of the "pixels" and added a subtle
texture to the image (CRTs don't have "pixels", but that's a longer story).
The perceived quality of 320&times;200 Amiga games on Commodore monitors
rivalled the experience of 640&times;480 games on much sharper PC CRT
monitors. Sure, the Amiga image was a bit blurrier and lacked fine detail, but
it was _nowhere near_ the extreme blockiness of how PC monitors presented
320&times;200 content! Most people moving on from the Amiga to the PC in the
1990s often complained about low resolution pixel art suddenly appearing
overly blocky on their comparably sized 14--15" PC monitor.[^1]

Let me stress this again: 320&times;200 content on the Amiga was _smooth_, not
blocky as on the PC! On well-made art, the "pixels" literally melted away; you
did not see jagged stairstep edges but smooth curves! 

That's all good and well, but some games still look subjectively better with
the graphics slightly enlarged. For example, I like playing [Pinball Dreams]()
with 4.0x scaling so it almost completely fills the screen; it's just more
immersive for me that way. So by all means, feel free to to adjust the image
size depending on your display size, viewing distance, and personal
preference. You also might want to use different scaling factors for different
games. The [Customising your setup](customising-your-setup.md) shows you how
to do that.

However, be aware that as you start deviating from the "canonical" 14" CRT
image size (3.0x scaling factor), you will start seeing the "pixels", and the
beneficial blur of the CRT shaders will also be enlarged, resulting in a
subjectively blurrier looking image. You can offset this by using the "sharp"
variants of the shaders which reduce the blurriness substantially, but as they
take away some of the smoothing effects, the pixels will start looking
blockier. Moreover, the scanlines are more apparent at higher scaling factors,
especially with the NTSC shader. You might want to force the PAL shader that
has more "densely packed" scanlines even in NTSC games to mitigate this.

As you can see, deviating from the canonical 14" CRT image size is all about
tradeoffs. Even on real CRT monitors, the experience is not the same on larger
17--21" displays. You just need to pick what's more important to you:
authenticity and image quality, or image size and getting rid of the "black
borders".

This is certainly a fascinating topic; you can read more about it [in my
article](https://blog.johnnovak.net/2022/04/15/achieving-period-correct-graphics-in-personal-computer-emulators-part-1-the-amiga/)
that describes the shader setup in detail.



[^1]: This is due to the fundamental design differences between Commodore and
    IBM PC CRT monitors. Commodore monitors such as the 1084S were effectively
    small high-quality TV sets with RGB input. Commodore was after the home
    computer and enthusiast market (at least in the beginning), so they found
    a way to effectively repurpose cheap small TVs into RGB monitors at an
    affordable price! These small-TVs-turned-monitors had great image quality,
    much better than your usual small TV, but their resolution and sharpness
    didn't come anywhere near specialised IBM PC monitors. PC monitors were
    the kings of sharpness, optimised for staring at spreadsheets all day at
    work, but they lacked the qualities of "lesser" CRTs that put pixel art in
    more favourable light. Being squarely aimed at the business market, they
    were several times more expensive than 15 kHz home computer monitors in
    the 1980s.

