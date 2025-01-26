import std/lenientops
import std/options
import std/os
import std/strformat
import std/strutils

import glad/gl
import glfw
from glfw/wrapper import showWindow
import nanovg

import koi
import with

import core

# {{{ Globals
var vg: NVGContext

type
  App = object
    currTab:      MainTab
    applyTarget:  ApplyTarget
    helpText:     string

  MainTab = enum
    mtDisplay = "Display"
    mtAudio   = "Audio"
    mtGeneral = "General"

  ApplyTarget = enum
    atAll      = "All configs"
    atAllGames = "All games"
    atAllDemos = "All demos"

var app: App


var settings: Settings

# default
settings.display = DisplaySettings(
    displayMode:     (dmFullWindow, false),
    windowWidth:     ("1280", false),
    windowHeight:    ("960", false),
    resizableWindow: (true, false),
    showOsd:         (true, false),
    showClock:       (true, false),

    crtEmulation:    (true, false),
    shaderQuality:   (sqBest, false),
    palScaling:      (palScaling30, false),
    ntscScaling:     (ntscScaling30, false),

    sharperPal:      (false, false),
    interlacing:     (false, false),
    vsyncMode:       (vmStandard, false),
    sliceCount:      ("2", false)
)

const
  DialogLayoutParams = AutoLayoutParams(
    itemsPerRow:       2,
    rowWidth:          330.0,
    labelWidth:        190.0,
    sectionPad:        0.0,
    leftPad:           0.0,
    rightPad:          0.0,
    rowPad:            7.0,
    rowGroupPad:       20.0,
    defaultRowHeight:  22.0,
    defaultItemHeight: 22.0
  )

  CheckBoxSize = 18.0

let
  transparent = black().withAlpha(0.0)

# Icons

const
  NoIcon     = ""
  IconCheck  = "\ue900"
  IconFloppy = "\uf0c7"

# }}}

# {{{ setHelpText()
template setHelpText(s: string) =
  let y = koi.autoLayoutNextY()
  let oy = koi.drawOffset().oy

  if koi.my() >= oy + y and koi.my() <= oy + y + 22:
    const text = s.unindent.replace("\n", " ")
    app.helpText = text

# }}}
# {{{ renderDisplayTab()
proc renderDisplayTab() =
    group:
      koi.toggleButton(settings.display.displayMode.set, "Display mode")
      setHelpText("""
        Set the default display mode. You can always toggle between 'Windowed'
        and 'Full-windowed' with End+12. Use 'Fullscreen' for the best results
        with lagless vsync enabled.
      """)
      koi.dropDown(settings.display.displayMode.value,
                   disabled = not settings.display.displayMode.set)

      koi.toggleButton(settings.display.windowWidth.set, "Window size")
      setHelpText("Set the window size in windowed mode.")
      let y = koi.autoLayoutNextY()

      koi.nextItemWidth(60)
      koi.textField(
        settings.display.windowWidth.value,
        tooltip = "",
        constraint = TextFieldConstraint(
          kind:   tckInteger,
          minInt: 640,
          maxInt: 9999
        ).some,
        disabled = not settings.display.windowWidth.set
      )

      koi.label(x=256, y, w=20, h=22, "x")

      koi.textField(
        x=270, y, w=60, h=22,
        settings.display.windowHeight.value,
        constraint = TextFieldConstraint(
          kind:   tckInteger,
          minInt: 640,
          maxInt: 9999
        ).some,
        disabled = not settings.display.windowWidth.set
      )

      koi.toggleButton(settings.display.resizableWindow.set, "Resizable window")
      setHelpText("""
        Allow resizing the window in windowed mode.
      """)
      koi.nextItemHeight(CheckBoxSize)
      koi.checkBox(settings.display.resizableWindow.value,
                   disabled = not settings.display.resizableWindow.set)

    group:
      koi.toggleButton(settings.display.showOsd.set, "Show OSD")
      setHelpText("""
          Show on-screen display (OSD) in the bottom-right corner that
          indicates the HDD and floppy drive activity of the emulated machine,
          plus CPU and audio buffer utilisation, currnt FPS, pause/warp mode,
          etc.
      """)

      koi.nextItemHeight(CheckBoxSize)
      koi.checkBox(settings.display.showOsd.value,
                   disabled=not settings.display.showOsd.set)

      koi.toggleButton(settings.display.showClock.set, "Show clock")
      setHelpText("""
        Show clock in the top-right corner (only work if CRT emulation is
        enabled).
      """)
      koi.nextItemHeight(CheckBoxSize)
      koi.checkBox(settings.display.showClock.value,
                   disabled = not settings.display.showClock.set)

    group:
      koi.toggleButton(settings.display.palScaling.set, "PAL scaling")
      setHelpText("""
        Set the scaling factor for PAL games and demos. Fractional scaling
        factors (in particular the 3.2x factor) might result in some vertical
        interference artifacts on 1080p screens. This is especially noticeable
        on fade-in & fade-out effects.
      """)
      koi.nextItemWidth(60)
      koi.dropDown(settings.display.palScaling.value,
                   disabled = not settings.display.palScaling.set)

      koi.toggleButton(settings.display.ntscScaling.set, "NTSC scaling")
      setHelpText("""
        Set the scaling factor for NTSC and NTSC50 games. Fractional settings
        are not prone to vertical interference artifacts as the PAL shaders.
      """)
      koi.nextItemWidth(60)
      koi.dropDown(settings.display.ntscScaling.value,
                   disabled = not settings.display.ntscScaling.set)

    group:
      koi.toggleButton(settings.display.crtEmulation.set, "CRT emulation")
      setHelpText("""
        Enables authentic 15 kHz Commodore monitor CRT emulation. Pixels are
        rendered as sharp little rectangles if disabled. You might need to
        disable CRT emulation if you have a really weak GPU and you're getting
        slowdowns and glitchy audio.
      """)
      koi.nextItemHeight(CheckBoxSize)
      koi.checkBox(settings.display.crtEmulation.value,
                   disabled = not settings.display.crtEmulation.set)

      koi.toggleButton(settings.display.shaderQuality.set, "CRT emulation quality")
      setHelpText("""
        'Best' is recommended to minimise vertical interference artifacts.
        Only select 'Fast' if you have a weak GPU and you're getting slowdowns
        and audio stutters (it's three times faster than 'Best').
      """)
      koi.dropDown(settings.display.shaderQuality.value,
                   disabled = not settings.display.shaderQuality.set)

      koi.toggleButton(settings.display.sharperPal.set, "Sharper PAL CRT emulation")
      setHelpText("""
        Enable maximum horizontal sharpness for PAL CRT emulation. This
        increases the legibility of 80-column text (e.g., in text adventures),
        at the detriment of the 'natural antialiasing' and blending properties
        of the CRT shaders. This only exists for PAL because the NTSC shaders
        don't benefit from it.
      """)
      koi.nextItemHeight(CheckBoxSize)
      koi.checkBox(settings.display.sharperPal.value,
                   disabled = not settings.display.sharperPal.set)

      koi.toggleButton(settings.display.interlacing.set, "Interlacing emulation")
      setHelpText("""
        Enable interlacing flicker emulation in hi-res laced screen modes
        (400-pixel-high NTSC and 512-pixel-high PAL modes). Interlacing
        emulation works best on VRR monitors or with matched refresh rates on
        fixed-refresh displays (50 Hz for PAL and 60 Hz for NTSC; make sure
        your Windows desktop uses the appropriate refresh rate).
      """)
      koi.nextItemHeight(CheckBoxSize)
      koi.checkBox(settings.display.interlacing.value,
                   disabled = not settings.display.interlacing.set)

    group:
      koi.toggleButton(settings.display.vsyncMode.set, "Vsync mode")
      setHelpText("""
        'Standard' uses triple buffering and works well in both windowed and
        fullscreen. This should satisfy most users. 'Lagless' reduces input
        latency which might matter in fast-paced action games, but is finicky
        as it needs fullscreen for the best results and a VRR monitor or exact
        refresh rates (see 'Interlacing emulation').
      """)
      koi.dropDown(settings.display.vsyncMode.value,
                   disabled = not settings.display.vsyncMode.set)

      koi.toggleButton(settings.display.sliceCount.set, "Lagless vsync slices")
      setHelpText("""
        Number of frame slices in lagless vsync mode. Higher values reduce
        latency, but how far you can go without getting weird artifacts is
        very much setup-dependent. Value between 2 and 8 and the most useful.
        Generally you'll need slightly larger audio buffers in lagless vsync
        mode.
      """)
      koi.nextItemWidth(60)
      koi.textField(
        settings.display.sliceCount.value,
        constraint = TextFieldConstraint(
          kind:   tckInteger,
          minInt: 1,
          maxInt: 29
        ).some,
        disabled = not settings.display.sliceCount.set
      )

# }}}
# {{{ renderAudioTab()
proc renderAudioTab() =
  discard

# }}}
# {{{ renderGeneralTab()
proc renderGeneralTab() =
  discard

# }}}
# {{{ renderTabs()
proc renderTabs(x, y: float) =
  koi.beginView(x, y, w=1000, h=1000)

  var lp = DialogLayoutParams
  koi.initAutoLayout(lp)

  case app.currTab:
  of mtDisplay:
    renderDisplayTab()

  of mtAudio:
    renderAudioTab()

  of mtGeneral:
    renderGeneralTab()

  koi.endView()

# }}}
# {{{ renderUI()
proc renderUI() =
  koi.beginFrame()

  var
    x = 25.0
    y = 25.0

  # Clear background
  vg.beginPath()
  vg.rect(0, 0, koi.winWidth(), koi.winHeight())
  vg.fillColor(gray(0.28))
  vg.fill()

  # Tabs
  koi.radioButtons(x, y, 390, 24, app.currTab)

  y += 60
  renderTabs(x, y)

  # Help text
  y += 450
  koi.textArea(x, y, 390, 150, app.helpText, disabled=true)

  # Action buttons
  y = koi.winHeight() - 22 - 25

  if koi.button(x, y, 75, 24, "Reset"):
    discard

  if koi.button(x + 83, y, 75, 24, "Load"):
    discard

  if koi.button(koi.winWidth() - 90 - x - 98, y, 90, 24, "Apply to"):
#    case app.applyTarget:
#    of atAll:
#    of atAllGames:
#    of atAllDemos:
#
#    applySettings(app.applyTarget)
    discard

  koi.dropDown(koi.winWidth() - 90 - x, y, 90, 24, app.applyTarget)

  koi.endFrame()

# }}}

# {{{ GLFW callbacks
proc renderFrame(win: Window, res: tuple[w, h: int32] = (0,0)) =
  renderUI()
  glfw.swapBuffers(win)

proc windowPosCb(win: Window, pos: tuple[x, y: int32]) =
  renderFrame(win)

proc framebufSizeCb(win: Window, size: tuple[w, h: int32]) =
  renderFrame(win)

# }}}

# {{{ createWindow()
proc createWindow(): Window =
  var cfg           = DefaultOpenglWindowConfig
  cfg.size          = (w: 440, h: 760)
  cfg.title         = "RML Amiga Configuration Tool"
  cfg.resizable     = false
  cfg.visible       = false
  cfg.bits          = (r: some(8'i32), g: some(8'i32), b: some(8'i32),
                       a: some(8'i32),
                       stencil: some(8'i32), depth: some(16'i32))
  cfg.nMultiSamples = 4
#  cfg.decorated     = false
#  cfg.focusOnShow   = true
#  cfg.transparentFramebuffer = true

  when defined(macosx):
    cfg.version = glv32
    cfg.forwardCompat = true
    cfg.profile = opCoreProfile

  newWindow(cfg)

# }}}
# {{{ loadFonts()
proc loadFonts() =
  proc loadFont(fontName: string, path: string): Font =
    try:
      vg.createFont(fontName, path)
    except CatchableError as e:
      quit "Cannot load font '{path}'"
      raise e

  discard         loadFont("sans",       "data" / "Roboto-Regular.ttf")
  let boldFont  = loadFont("sans-bold",  "data" / "Roboto-Bold.ttf")
  let blackFont = loadFont("sans-black", "data" / "Roboto-Black.ttf")
  let iconFont  = loadFont("icon",       "data" / "Icons.ttf")

  discard addFallbackFont(vg, boldFont,  iconFont)
  discard addFallbackFont(vg, blackFont, iconFont)

# }}}
# {{{ setWidgetStyles()
proc setWidgetStyles() =
  # Check box
  var cbs = koi.getDefaultCheckBoxStyle()
  with cbs:
    icon.fontSize = 12
    iconActive    = IconCheck
    iconInactive  = NoIcon

  koi.setDefaultCheckBoxStyle(cbs)

  # Toggle button
  var tbs = koi.getDefaultToggleButtonStyle()
  with tbs:
    fillColor            = transparent
    fillColorHover       = transparent
    fillColorDown        = transparent
    fillColorActive      = transparent
    fillColorActiveHover = transparent
    fillColorDisabled    = transparent

  with tbs.label:
    align      = haLeft
    color      = gray(0.57)
    colorHover = gray(0.57)
    colorDown  = gray(0.57)

  with tbs.labelActive:
    align = haLeft

  koi.setDefaultToggleButtonStyle(tbs)

# }}}
# {{{ init()
proc init(): Window =
  glfw.initialize()

  var win = createWindow()

  nvgInit(getProcAddress)
  vg = nvgCreateContext({nifStencilStrokes, nifAntialias, nifDebug})

  if not gladLoadGL(getProcAddress):
    quit "Error initialising OpenGL"

  loadFonts()

  koi.init(vg, getProcAddress)

  setWidgetStyles()

  win.windowPositionCb  = windowPosCb
  win.framebufferSizeCb = framebufSizeCb

  # Center window before showing it
  let
    (winW, winH) = win.size
    (_, _, workAreaW, workAreaH) = glfw.getPrimaryMonitor().workArea

    cx = (workAreaW - winW) div 2
    cy = (workAreaH - winH) div 2

  win.pos = (cx, cy)

  wrapper.showWindow(win.getHandle())

  result = win

# }}}
# {{{ deinit()
proc deinit() =
  koi.deinit()
  nvgDeleteContext(vg)
  glfw.terminate()

# }}}

# {{{ main()
proc main() =
  let win = init()

  while not win.shouldClose:
    if koi.shouldRenderNextFrame():
      glfw.pollEvents()
    else:
      glfw.waitEvents()
    renderFrame(win)

  deinit()

# }}}

main()

# vim: et:ts=2:sw=2:fdm=marker
