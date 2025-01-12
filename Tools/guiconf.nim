import std/lenientops
import std/options
import std/strformat

import glad/gl
import glfw
from glfw/wrapper import showWindow
import nanovg

import koi

# {{{ Globals
var vg: NVGContext

type
  App = object
    currTab: MainTab

  MainTab = enum
    mtDisplay = (0, "Display"),
    mtAudio   = (1, "Audio"),
    mtGeneral = (2, "General")

var app: App


type
  Config = object
    display: DisplaySettings
    audio:   AudioSettings
    general: GeneralSettings

  # Display settings
  # -----------------------------------------
  DisplaySettings = object
    displayMode:   DisplayMode
    crtEmulation:  bool
    shaderQuality: ShaderQuality
    palScaling:    PalScaling
    ntscScaling:   NtscScaling
    showOsd:       bool

    # advanced settings
    sharperPal:    bool
    interlacing:   bool
    vsyncMode:     VsyncMode
    sliceCount:    Natural

  ShaderQuality = enum
    sqFast = (0, "Fast")
    sqBest = (1, "Best")

  DisplayMode = enum
    dmWindowed   = (0, "Windowed")
    dmFullWindow = (1, "Full-window")
    dmFullscreen = (2, "Fullscreen")

  PalScaling = enum
    palScaling30 = (0, "3.0x")
    palScaling32 = (1, "3.2x")
    palScaling35 = (2, "3.5x")
    palScaling40 = (3, "4.0x")
    palScaling45 = (4, "4.5x")
    palScaling50 = (5, "5.0x")

  NtscScaling = enum
    ntscScaling30 = (0, "3.0x")
    ntscScaling32 = (1, "3.2x")
    ntscScaling35 = (2, "3.5x")
    ntscScaling40 = (3, "4.0x")
    ntscScaling42 = (4, "4.2x")

  VsyncMode = enum
    vmOff      = (0, "Off")
    vmStandard = (1, "Standard")
    vmLagless  = (2, "Lagless")

  # Audio settings
  # -----------------------------------------
  AudioSettings = object
    audioDevice:      AudioDevice
    sampleRate:       SampleRate
    soundBufferSize:  SoundBufferSize
    volume:           Natural
    stereoSeparation: StereoSeparation
    floppySounds:     bool

  AudioDevice = enum
    adDirectSound = (0, "DirectSound"),
    adWasapi      = (1, "WASAPI")

  SampleRate = enum
    sr44100 = (0, "44100")
    sr48000 = (1, "48000")
    sr88200 = (2, "88200")
    sr96000 = (3, "96000")

  StereoSeparation = enum
    ss100 = (0,  "100%")
    ss90  = (1,  "90%")
    ss80  = (2,  "80%")
    ss70  = (3,  "70%")
    ss60  = (4,  "60%")
    ss50  = (5,  "50%")
    ss40  = (6,  "40%")
    ss30  = (7,  "30%")
    ss20  = (8,  "20%")
    ss10  = (9,  "10%")
    ss0   = (10, "0%")

  SoundBufferSize = enum
    sbsMin = (0, "Min")
    sbs1   = (1, "1")
    sbs2   = (2, "2")
    sbs3   = (3, "3")
    sbs4   = (4, "4")
    sbs5   = (5, "5")
    sbs6   = (6, "6")
    sbs7   = (7, "7")
    sbs8   = (8, "8")

  # General settings
  # -----------------------------------------
  GeneralSettings = object
    discard


var cfg: Config

const
  DialogLayoutParams = AutoLayoutParams(
    itemsPerRow:       2,
    rowWidth:          280.0,
    labelWidth:        170.0,
    sectionPad:        0.0,
    leftPad:           0.0,
    rightPad:          0.0,
    rowPad:            8.0,
    rowGroupPad:       20.0,
    defaultRowHeight:  23.0,
    defaultItemHeight: 23.0
  )


# }}}

# {{{ renderDisplayTab()
proc renderDisplayTab() =
  group:
    koi.label("Display mode")
    koi.dropDown(cfg.display.displayMode)

  group:
    koi.label("CRT emulation")
    koi.checkBox(cfg.display.crtEmulation)

    koi.label("CRT emulation quality")
    koi.dropDown(cfg.display.shaderQuality)

  group:
    koi.label("PAL scaling")
    koi.dropDown(cfg.display.palScaling)

    koi.label("NTSC scaling")
    koi.dropDown(cfg.display.ntscScaling)

  group:
    koi.label("Show OSD")
    koi.checkBox(cfg.display.showOsd)

  group:
    koi.label("Sharper PAL mode")
    koi.checkBox(cfg.display.sharperPal)

    koi.label("Interlacing emulation")
    koi.checkBox(cfg.display.interlacing)

    koi.label("Vsync mode")
    koi.dropDown(cfg.display.vsyncMode)

#      koi.label("Lagless vsync slices")
#      koi.dropDown(cfg.display.sliceCount)

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

  let
    w = 110.0
    h = 22.0
    pad = h + 8

  var
    x = 30.0
    y = 30.0

  # Clear background
  vg.beginPath()
  vg.rect(0, 0, koi.winWidth(), koi.winHeight())
  vg.fillColor(gray(0.3))
  vg.fill()

  # Main tabs
  koi.radioButtons(x, y, 440, h, app.currTab)

  y += 50
  renderTabs(x+30, y)

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
  cfg.size          = (w: 500, h: 650)
  cfg.title         = "RML Amiga Configuration Tool"
  cfg.resizable     = true
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
# {{{ loadData()
proc loadData(vg: NVGContext) =
  let regularFont = vg.createFont("sans", "data/Roboto-Regular.ttf")
  if regularFont == NoFont:
    quit "Could not load regular italic.\n"

  let boldFont = vg.createFont("sans-bold", "data/Roboto-Bold.ttf")
  if boldFont == NoFont:
    quit "Could not load bold font.\n"

# }}}
# {{{ init()
proc init(): Window =
  glfw.initialize()

  var win = createWindow()

  nvgInit(getProcAddress)
  vg = nvgCreateContext({nifStencilStrokes, nifAntialias, nifDebug})

  if not gladLoadGL(getProcAddress):
    quit "Error initialising OpenGL"

  loadData(vg)

  koi.init(vg, getProcAddress)

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
