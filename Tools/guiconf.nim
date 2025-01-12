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
  ConfigUI = object
    currentTab: int

    audio:   AudioSettings
    video:   DisplaySettings
    general: GeneralSettings

  AudioDevice = enum
    adDirectSound = (0, "DirectSound"),
    adWasapi      = (1, "WASAPI")

  AudioSettings = object
    audioDevice:      AudioDevice
    sampleRate:       SampleRate
    soundBufferSize:  SoundBufferSize
    volume:           Natural
    stereoSeparation: StereoSeparation
    floppySounds:     bool

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


  DisplaySettings = object
    windowMode:    WindowMode
    crtEmulation:  bool
    shaderQualtiy: ShaderQuality
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

  WindowMode = enum
    wmWindowed   = (0, "Windowed")
    wmFullWindow = (1, "Full-window")
    wmFullscreen = (3, "Fullscreen")

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
    vmStandard = (0, "Standard")
    vmLagless  = (1, "Lagless")

  GeneralSettings = object
    discard


var gui: ConfigUI

# }}}

# {{{ renderUI()
proc renderUI() =
  koi.beginFrame()

  vg.beginPath()
  vg.rect(0, 0, koi.winWidth(), koi.winHeight())
  vg.fillColor(gray(0.3))
  vg.fill()

  let
    w = 110.0
    h = 22.0
    pad = h + 8

  var
    x = 30.0
    y = 30.0

  var labelStyle = getDefaultLabelStyle()
  labelStyle.fontSize = 15.0
  labelStyle.color = gray(0.8)

  koi.radioButtons(
    x, y, 440, h,
    labels = @["Audio", "Video", "General"],
    gui.currentTab
  )

  # Buttons
  y += 50
  if koi.button(x, y, w, h, "Start", tooltip = "I am the first!"):
    echo "button 1 pressed"

  y += pad
  if koi.button(x, y, w, h, "Stop (very long text)", tooltip = "Middle one..."):
    echo "button 2 pressed"

  y += pad
  if koi.button(x, y, w, h, "Disabled", tooltip = "This is a disabled button",
                disabled = true):
    echo "button 3 pressed"

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
  cfg.size          = (w: 500, h: 350)
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
