import std/dirs
import std/options
import std/os
import std/paths
import std/streams
import std/strformat
import std/strutils
import std/sugar
import std/syncio
import std/tables

import with

# {{{ Config
type
  Config = ref object
    cfg: OrderedTable[string, string]

const CommentKeyPrefix = "#comment-"

# }}}
# {{{ Settings
const
  NoFilter       = "D3D:Point-Prescale.fx"
  PalFilter      = "D3D:CRT-A2080-PAL.fx"
  PalSharpFilter = "D3D:CRT-A2080-PAL-Sharp.fx"
  NtscFilter     = "D3D:CRT-A2080-NTSC.fx"

type
  Settings* = object
    display*: DisplaySettings
    audio*:   AudioSettings
    general*: GeneralSettings

  # {{{ Display settings
  # -------------------------------------------------------------------------
  DisplaySettings* = object
    displayMode*:     tuple[value: DisplayMode,   set: bool]
    windowWidth*:     tuple[value: string,        set: bool]
    windowHeight*:    tuple[value: string,        set: bool]
    resizableWindow*: tuple[value: bool,          set: bool]
    showOsd*:         tuple[value: bool,          set: bool]
    showClock*:       tuple[value: bool,          set: bool]

    crtEmulation*:    tuple[value: bool,          set: bool]
    shaderQuality*:   tuple[value: ShaderQuality, set: bool]
    palScaling*:      tuple[value: PalScaling,    set: bool]
    ntscScaling*:     tuple[value: NtscScaling,   set: bool]

    sharperPal*:      tuple[value: bool,          set: bool]
    interlacing*:     tuple[value: bool,          set: bool]
    vsyncMode*:       tuple[value: VsyncMode,     set: bool]
    vsyncSlices*:     tuple[value: string,        set: bool]

  ShaderQuality* = enum
    sqFast = "Fast"
    sqBest = "Best"

  DisplayMode* = enum
    dmWindowed   = "Windowed"
    dmFullWindow = "Full-window"
    dmFullscreen = "Fullscreen"

  PalScaling* = enum
    palScaling30 = "3.0x"
    palScaling32 = "3.2x"
    palScaling35 = "3.5x"
    palScaling40 = "4.0x"
    palScaling45 = "4.5x"
    palScaling50 = "5.0x"

  NtscScaling* = enum
    ntscScaling30 = "3.0x"
    ntscScaling32 = "3.2x"
    ntscScaling35 = "3.5x"
    ntscScaling40 = "4.0x"
    ntscScaling42 = "4.2x"

  VsyncMode* = enum
    vmStandard = "Standard"
    vmLagless  = "Lagless"
    vmOff      = "Off"

  # }}}
  # {{{ Audio settings
  # -------------------------------------------------------------------------
  AudioSettings* = object
    audioDevice:      AudioDevice
    sampleRate:       SampleRate
    soundBufferSize:  SoundBufferSize
    volume:           Natural
    stereoSeparation: StereoSeparation
    floppySounds:     bool

  AudioDevice* = enum
    adDirectSound = "DirectSound"
    adWasapi      = "WASAPI"

  SampleRate* = enum
    sr44100 = "44100"
    sr48000 = "48000"
    sr88200 = "88200"
    sr96000 = "96000"

  StereoSeparation* = enum
    ss100 = "100%"
    ss90  = "90%"
    ss80  = "80%"
    ss70  = "70%"
    ss60  = "60%"
    ss50  = "50%"
    ss40  = "40%"
    ss30  = "30%"
    ss20  = "20%"
    ss10  = "10%"
    ss0   = "0%"

  SoundBufferSize* = enum
    sbsMin = "Min"
    sbs1   = "1"
    sbs2   = "2"
    sbs3   = "3"
    sbs4   = "4"
    sbs5   = "5"
    sbs6   = "6"
    sbs7   = "7"
    sbs8   = "8"

  # }}}
  # {{{ General settings
  # -------------------------------------------------------------------------
  GeneralSettings* = object
    discard

  # }}}
# }}}
# {{{ Scaling factors

# Non-laced
let palScalingFactors = {
  palScaling30: (1000, 1000),
  palScaling32: (1200, 1200),
  palScaling35: (1500, 1500),
  palScaling40: (2000, 2000),
  palScaling45: (2500, 2500),
  palScaling50: (3000, 3000)
}.toTable

let ntscScalingFactors = {
  ntscScaling30: (1000, 1600),
  ntscScaling32: (1200, 1840),
  ntscScaling35: (1500, 2200),
  ntscScaling40: (2000, 2800),
  ntscScaling42: (2200, 3040)
}.toTable


# Laced
let lacedPalScalingFactors = {
  palScaling30: (1000, 4000),
  palScaling32: (1200, 4400),
  palScaling35: (1500, 5000),
  palScaling40: (2000, 6000),
  palScaling45: (2500, 7000),
  palScaling50: (3000, 8000)
}.toTable

let lacedNtscScalingFactors = {
  ntscScaling30: (1000, 5200),
  ntscScaling32: (1200, 5680),
  ntscScaling35: (1500, 6400),
  ntscScaling40: (2000, 7600),
  ntscScaling42: (2200, 8080)
}.toTable

# }}}

# {{{ getConfigPaths*()
proc getConfigPaths*(path: Path): seq[Path] =
  if fileExists($path):
    @[path]
  elif dirExists(path):
    collect:
      for p in walkDirRec(path):
        let (_, _, ext) = p.splitFile
        if ext == ".uae": p
  else:
    @[]

# }}}
# {{{ readConfig*()
proc readConfig*(file: Path): Config =
  let contents = readFile($file)
  var
    stream = newStringStream(contents)
    line   = ""
    lineNo = 1

  result = new Config
  result.cfg = initOrderedTable[string, string]()

  while stream.readLine(line):
    if line.strip().startsWith(";"):
      result.cfg[fmt"{CommentKeyPrefix}{lineNo}"] = line
    else:
      let p = line.find('=')
      if p > -1:
        let key = line[0..p-1].strip
        let val = line[p+1..^1].strip

        # This will allow duplicates, e.g., for `filesystem2` that can occurr
        # multiple times.
        result.cfg[key] = val

    inc(lineNo)

# }}}
# {{{ writeConfig*()
proc writeConfig*(c: Config, path: Path) =
  let f = open($path, fmWrite)

  for (key, val) in c.cfg.pairs():
    if key.startsWith(CommentKeyPrefix):
      f.write(val)
    else:
      f.write(fmt"{key}={val}")
    f.write("\r\n")

  f.close

# }}}

# {{{ Set display settings
# {{{ setDisplayMode()
proc setDisplayMode(c: Config, dm: DisplayMode) =
  c.cfg["gfx_fullscreen_amiga"] = case dm
                                  of dmWindowed:   "false"
                                  of dmFullWindow: "fullwindow"
                                  of dmFullscreen: "true"

# }}}
# {{{ setResizableWindow()
proc setResizableWindow(c: Config, resizable: bool) =
  c.cfg["gfx_resize_windowed"] = $resizable

# }}}
# {{{ setWindowSize()
proc setWindowSize(c: Config, width, height: string) =
  c.cfg["gfx_width"]          = width
  c.cfg["gfx_width_windowed"] = width

  c.cfg["gfx_height"]          = height
  c.cfg["gfx_height_windowed"] = height

# }}}
# {{{ setShowOsd()
proc setShowOsd(c: Config, showOsd: bool) =
  c.cfg["show_leds"] = $showOsd

# }}}
# {{{ isLaced()
proc isLaced(c: Config): bool =
  c.cfg.getOrDefault("gfx_linemode", "double2") == "none"

# }}}
# {{{ getScalingFactors()
proc getScalingFactors(c: Config): tuple[horiz, vert: int] =
  # TODO parseIntOrDefault
  let h = parseFloat(c.cfg.getOrDefault("gfx_filter_horiz_zoomf", "1000.0"))
  let v = parseFloat(c.cfg.getOrDefault("gfx_filter_vert_zoomf",  "1000.0"))
  (h.int, v.int)

# }}}
# {{{ findByValue()
proc findByValue[K, V](t: Table[K, V], value: V): Option[K] =
  for (k, v) in t.pairs:
    if v == value:
      return k.some
  return K.none

# }}}
# {{{ getPalScaling()
proc getPalScaling(c: Config): Option[PalScaling] =
  let f = getScalingFactors(c)
  if isLaced(c): lacedPalScalingFactors.findByValue(f)
  else:               palScalingFactors.findByValue(f)

# }}}
# {{{ getNtscScaling()
proc getNtscScaling(c: Config): Option[NtscScaling] =
  let f = getScalingFactors(c)
  if isLaced(c): lacedNtscScalingFactors.findByValue(f)
  else:               ntscScalingFactors.findByValue(f)

# }}}
# {{{ getVideoStandard()
type VideoStandard = enum
  vsPal, vsNtsc, vsNtsc50

proc getVideoStandard(c: Config): VideoStandard =
  # TODO parseBoolOrDefault
  let isNtsc = c.cfg.getOrDefault("ntsc", "false").parseBool
  if isNtsc:
    vsNtsc
  else:
    if getNtscScaling(c).isSome: vsNtsc50
    else: vsPal

# }}}
# {{{ setScalingFactors()
proc setScalingFactors(c: Config, f: tuple[horiz, vert: int]) =
  c.cfg["gfx_filter_horiz_zoomf"] = fmt"{f.horiz}.000000"
  c.cfg["gfx_filter_vert_zoomf"]  = fmt"{f.vert}.000000"

# }}}
# {{{ setScaling()
proc setScaling(c: Config, palScaling:  Option[PalScaling],
                           ntscScaling: Option[NtscScaling]) =

  case getVideoStandard(c)
  of vsPal:
    if palScaling.isSome:
      let s = if palScaling.isSome: palScaling.get
              else: getPalScaling(c).get(palScaling30)

      let f = if isLaced(c): lacedPalScalingFactors[s]
              else:               palScalingFactors[s]
      setScalingFactors(c, f)

  of vsNtsc, vsNtsc50:
    if ntscScaling.isSome:
      let s = if ntscScaling.isSome: ntscScaling.get
              else: getNtscScaling(c).get(ntscScaling30)

      let f = if isLaced(c): lacedNtscScalingFactors[s]
              else:               ntscScalingFactors[s]
      setScalingFactors(c, f)

# }}}
# {{{ setInterlacing()
proc setInterlacing(c: Config, enabled: bool) =

  proc setInterlacing(enabled: bool) =
    c.cfg["gfx_linemode"] = if enabled: "none" else: "double2"

  case getVideoStandard(c)
  of vsPal:
    let s = getPalScaling(c).get(palScaling30)
    let f = if enabled: lacedPalScalingFactors[s]
            else:            palScalingFactors[s]
    setScalingFactors(c, f)
    setInterlacing(enabled)

  of vsNtsc, vsNtsc50:
    let s = getNtscScaling(c).get(ntscScaling30)
    let f = if enabled: lacedNtscScalingFactors[s]
            else:            ntscScalingFactors[s]
    setScalingFactors(c, f)
    setInterlacing(enabled)

# }}}
# {{{ setCrtEmulation()
proc setCrtEmulation(c: Config, enabled: bool) =

  proc setFilter(s: string) =
    c.cfg["gfx_filter"] = s

  if enabled:
    case getVideoStandard(c)
    of vsPal:            setFilter(PalFilter)
    of vsNtsc, vsNtsc50: setFilter(NtscFilter)
  else:                  setFilter(NoFilter)

# }}}
# {{{ setSharperPal()
proc setSharperPal(c: Config, sharperPal: bool) =

  proc getFilter(): string =
    c.cfg.getOrDefault("gfx_filter", "")

  proc setFilter(s: string) =
    c.cfg["gfx_filter"] = s

  case getVideoStandard(c)
  of vsPal:
    if getFilter() in @[PalFilter, PalSharpFilter]:
      setFilter(if sharperPal: PalSharpFilter
                else:          PalFilter)
  of vsNtsc, vsNtsc50:
    discard

# }}}
# {{{ setShaderQuality()
proc setShaderQuality(c: Config, shaderQuality: ShaderQuality) =
  case shaderQuality
  of sqFast:
    c.cfg["gfx_filter_mode"]  = "1x"
    c.cfg["gfx_filter_mode2"] = "2x"

  of sqBest:
    c.cfg["gfx_filter_mode"]  = "2x"
    c.cfg["gfx_filter_mode2"] = "3x"

# }}}
# {{{ setVsyncMode()
proc setVsyncMode(c: Config, vsyncMode: VsyncMode) =

  proc setDoubleBuffering() =
    c.cfg["gfx_backbuffers"] = "1"

  proc setTripleBuffering() =
    c.cfg["gfx_backbuffers"] = "2"

  case vsyncMode
  of vmStandard:
    c.cfg["gfx_vsync"] = "autoswitch"
    c.cfg.del("gfx_vsyncmode")
    setTripleBuffering()

  of vmLagless:
    c.cfg["gfx_vsync"]     = "autoswitch"
    c.cfg["gfx_vsyncmode"] = "busywait"
    setDoubleBuffering()

  of vmOff:
    c.cfg["gfx_vsync"] = "false"
    c.cfg.del("gfx_vsyncmode")
    setTripleBuffering()

# }}}
# {{{ setLaglessVsyncSlices()
proc setLaglessVsyncSlices(c: Config, vsyncSlices: string) =

  let vsyncMode = case c.cfg.getOrDefault("gfx_vsync", "false"):
    of "autoswitch":
      if c.cfg.getOrDefault("gfx_vsyncmode", "") == "busywait": vmLagless
      else: vmStandard
    else: vmOff

  case vsyncMode
  of vmLagless:
    c.cfg["gfx_frame_slices"] = vsyncSlices
  of vmStandard, vmOff:
    discard

# }}}
# }}}

# {{{ toOpt()
proc toOpt[T](a: tuple[value: T, set: bool]): Option[T] =
  if a.set: a.value.some
  else: T.none

# }}}
# {{{ applySettings*()
proc applySettings*(cfg: Config, settings: Settings) =
  with settings.display:
    if displayMode.set:
      cfg.setDisplayMode(displayMode.value)

    if windowWidth.set:
      cfg.setWindowSize(windowWidth.value, windowHeight.value)

    if resizableWindow.set:
      cfg.setResizableWindow(resizableWindow.value)

    if showOsd.set: cfg.setShowOsd(showOsd.value)

    # TODO
#    if showClock.set: c.setShowClock(showClock.value)

    if crtEmulation.set:
      cfg.setCrtEmulation(crtEmulation.value)

    if sharperPal.set:
      # Must be called after `setCrtEmulation`
      cfg.setSharperPal(sharperPal.value)

    if shaderQuality.set:
      cfg.setShaderQuality(shaderQuality.value)

    if palScaling.set or ntscScaling.set:
      cfg.setScaling(palScaling.toOpt, ntscScaling.toOpt)

    if interlacing.set:
      # Must be called after `setScaling`
      cfg.setInterlacing(interlacing.value)

    if vsyncMode.set:
      cfg.setVsyncMode(vsyncMode.value)

    if vsyncSlices.set:
      cfg.setLaglessVsyncSlices(vsyncSlices.value)

# }}}

# vim: et:ts=2:sw=2:fdm=marker
