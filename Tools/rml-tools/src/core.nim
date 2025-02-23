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

const
  AppVersion* = staticRead("../CURRENT_VERSION").strip

# {{{ UaeConfig
type
  UaeConfig* = ref object
    cfg*: OrderedTable[string, string]

const CommentKeyPrefix = "#comment-"

# }}}
# {{{ Settings
const
  NoFilter        = "D3D:Point-Prescale.fx"

  PalFilter       = "D3D:CRT-A2080-PAL.fx"
  PalSharpFilter  = "D3D:CRT-A2080-PAL-Sharp.fx"

  NtscFilter      = "D3D:CRT-A2080-NTSC.fx"
  NtscSharpFilter = "D3D:CRT-A2080-NSTC-Sharp.fx"

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
    windowPosX*:      tuple[value: string,        set: bool]
    windowPosY*:      tuple[value: string,        set: bool]
    resizableWindow*: tuple[value: bool,          set: bool]
    showOsd*:         tuple[value: bool,          set: bool]

    crtEmulation*:    tuple[value: bool,          set: bool]
    shaderQuality*:   tuple[value: ShaderQuality, set: bool]
    palScaling*:      tuple[value: PalScaling,    set: bool]
    ntscScaling*:     tuple[value: NtscScaling,   set: bool]

    sharperPal*:      tuple[value: bool,          set: bool]
    sharperNtsc*:     tuple[value: bool,          set: bool]
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
    audioInterface*:   tuple[value: AudioInterface,   set: bool]
    sampleRate*:       tuple[value: SampleRate,       set: bool]
    soundBufferSize*:  tuple[value: SoundBufferSize,  set: bool]
    volume*:           tuple[value: string,           set: bool]
    stereoSeparation*: tuple[value: StereoSeparation, set: bool]
    floppySounds*:     tuple[value: bool,             set: bool]

  AudioInterface* = enum
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
    confirmQuit*:         tuple[value: bool,              set: bool]
    pauseWhenUnfocused*:  tuple[value: bool,              set: bool]

    windowDecorations*:   tuple[value: WindowDecorations, set: bool]
    showToolbar*:         tuple[value: bool,              set: bool]
    captureMouseOnFocus*: tuple[value: bool,              set: bool]

    rawScreenshots*:      tuple[value: bool,              set: bool]

  WindowDecorations* = enum
    wdNone    = "None"
    wdMinimal = "Minimal"
    wdNormal  = "Normal"

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

# {{{ parseFloatOrDefault()
func parseFloatOrDefault(s: string, default: float): float =
  try:
    parseFloat(s)
  except ValueError:
    default

# }}}
# {{{ parseBoolOrDefault()
func parseBoolOrDefault(s: string, default: bool): bool =
  try:
    parseBool(s)
  except ValueError:
    default

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
# {{{ readUaeConfig*()
proc readUaeConfig*(file: Path): UaeConfig =
  let contents = readFile($file)
  var
    stream = newStringStream(contents)
    line   = ""
    lineNo = 1

  result = new UaeConfig
  result.cfg = initOrderedTable[string, string]()

  var filesystem2Index = 0

  while stream.readLine(line):
    if line.strip().startsWith(";"):
      result.cfg[fmt"{CommentKeyPrefix}{lineNo}"] = line
    else:
      let p = line.find('=')
      if p > -1:
        let key = line[0..p-1].strip
        let val = line[p+1..^1].strip

        if key == "filesystem2":
          # `filesystem2` can occur multiple times.
          result.cfg[fmt"{key}#{filesystem2Index}"] = val
          inc(filesystem2Index)
        else:
          result.cfg[key] = val

    inc(lineNo)

# }}}
# {{{ write*()
proc write*(c: UaeConfig, path: Path) =
  let f = open($path, fmWrite)

  for (key, val) in c.cfg.pairs():
    if key.startsWith(CommentKeyPrefix):
      f.write(val)
    elif key.startsWith("filesystem2"):
      f.write(fmt"filesystem2={val}")
    else:
      f.write(fmt"{key}={val}")
    f.write("\r\n")

  f.close

# }}}

# {{{ toOpt()
proc toOpt[T](a: tuple[value: T, set: bool]): Option[T] =
  if a.set: a.value.some
  else: T.none

# }}}
# {{{ findByValue()
proc findByValue[K, V](t: Table[K, V], value: V): Option[K] =
  for (k, v) in t.pairs:
    if v == value:
      return k.some
  return K.none

# }}}

# {{{ Set display settings
# {{{ isLaced()
proc isLaced(c: UaeConfig): bool =
  c.cfg.getOrDefault("gfx_linemode", "double2") == "none"

# }}}
# {{{ getScalingFactors()
proc getScalingFactors(c: UaeConfig): tuple[horiz, vert: int] =
  const Default = 1000.0

  let h = c.cfg.getOrDefault("gfx_filter_horiz_zoomf", $Default)
            .parseFloatOrDefault(Default)

  let v = c.cfg.getOrDefault("gfx_filter_vert_zoomf",  $Default)
            .parseFloatOrDefault(Default)

  (h.int, v.int)

# }}}
# {{{ getFilter()
proc getFilter(c: UaeConfig): string =
  c.cfg.getOrDefault("gfx_filter", "")

# }}}
# {{{ getPalScaling()
proc getPalScaling(c: UaeConfig): Option[PalScaling] =
  let f = c.getScalingFactors()
  if c.isLaced(): lacedPalScalingFactors.findByValue(f)
  else:                palScalingFactors.findByValue(f)

# }}}
# {{{ getNtscScaling()
proc getNtscScaling(c: UaeConfig): Option[NtscScaling] =
  let f = c.getScalingFactors()
  if c.isLaced(): lacedNtscScalingFactors.findByValue(f)
  else:                ntscScalingFactors.findByValue(f)

# }}}
# {{{ getVideoStandard()
type VideoStandard = enum
  vsPal, vsNtsc, vsNtsc50

proc getVideoStandard(c: UaeConfig): VideoStandard =
  let isNtsc = c.cfg.getOrDefault("ntsc", "false").parseBoolOrDefault(false)
  if isNtsc:
    vsNtsc
  else:
    if c.getNtscScaling().isSome: vsNtsc50
    else: vsPal

# }}}

# {{{ setDisplayMode()
proc setDisplayMode(c: UaeConfig, dm: DisplayMode) =
  c.cfg["gfx_fullscreen_amiga"] = case dm
                                  of dmWindowed:   "false"
                                  of dmFullWindow: "fullwindow"
                                  of dmFullscreen: "true"

# }}}
# {{{ setResizableWindow()
proc setResizableWindow(c: UaeConfig, resizable: bool) =
  c.cfg["gfx_resize_windowed"] = $resizable

# }}}
# {{{ setWindowSize()
proc setWindowSize(c: UaeConfig, width, height: string) =
  c.cfg["gfx_width"]          = width
  c.cfg["gfx_width_windowed"] = width

  c.cfg["gfx_height"]          = height
  c.cfg["gfx_height_windowed"] = height

# }}}
# {{{ setWindowPos()
proc setWindowPos(c: UaeConfig, x, y: string) =
  # TODO
  c.cfg["gfx_pos_x"]  = x
  c.cfg["gfx_pos_y"] = x

# }}}
# {{{ setShowOsd()
proc setShowOsd(c: UaeConfig, showOsd: bool) =
  c.cfg["show_leds"] = $showOsd

# }}}
# {{{ setScalingFactors()
proc setScalingFactors(c: UaeConfig, f: tuple[horiz, vert: int]) =
  c.cfg["gfx_filter_horiz_zoomf"] = fmt"{f.horiz}.000000"
  c.cfg["gfx_filter_vert_zoomf"]  = fmt"{f.vert}.000000"

# }}}
# {{{ setScaling()
proc setScaling(c: UaeConfig, palScaling:  Option[PalScaling],
                              ntscScaling: Option[NtscScaling]) =

  case c.getVideoStandard()
  of vsPal:
    if palScaling.isSome:
      let s = if palScaling.isSome: palScaling.get
              else: c.getPalScaling().get(palScaling30)

      let f = if c.isLaced(): lacedPalScalingFactors[s]
              else:                 palScalingFactors[s]
      c.setScalingFactors(f)

  of vsNtsc, vsNtsc50:
    if ntscScaling.isSome:
      let s = if ntscScaling.isSome: ntscScaling.get
              else: c.getNtscScaling().get(ntscScaling30)

      let f = if c.isLaced(): lacedNtscScalingFactors[s]
              else:               ntscScalingFactors[s]
      c.setScalingFactors(f)

# }}}
# {{{ setInterlacing()
proc setInterlacing(c: UaeConfig, enabled: bool) =

  proc setInterlacing(enabled: bool) =
    c.cfg["gfx_linemode"] = if enabled: "none" else: "double2"

  case c.getVideoStandard()
  of vsPal:
    let s = c.getPalScaling().get(palScaling30)
    let f = if enabled: lacedPalScalingFactors[s]
            else:            palScalingFactors[s]
    c.setScalingFactors(f)
    setInterlacing(enabled)

  of vsNtsc, vsNtsc50:
    let s = c.getNtscScaling().get(ntscScaling30)
    let f = if enabled: lacedNtscScalingFactors[s]
            else:            ntscScalingFactors[s]
    c.setScalingFactors(f)
    setInterlacing(enabled)

# }}}
# {{{ setFilter()
proc setFilter(c: UaeConfig, s: string) =
  c.cfg["gfx_filter"] = s

# }}}
# {{{ setCrtEmulation()
proc setCrtEmulation(c: UaeConfig, enabled: bool) =
  if enabled:
    case c.getVideoStandard()
    of vsPal:            c.setFilter(PalFilter)
    of vsNtsc, vsNtsc50: c.setFilter(NtscFilter)
  else:                  c.setFilter(NoFilter)

# }}}
# {{{ setSharperPal()
proc setSharperPal(c: UaeConfig, sharperPal: bool) =
  case c.getVideoStandard()
  of vsPal:
    if c.getFilter() in @[PalFilter, PalSharpFilter]:
      c.setFilter(if sharperPal: PalSharpFilter else: PalFilter)
  of vsNtsc, vsNtsc50:
    discard

# }}}
# {{{ setSharperNtsc()
proc setSharperNtsc(c: UaeConfig, sharperNtsc: bool) =
  case c.getVideoStandard()
  of vsPal:
    discard

  of vsNtsc, vsNtsc50:
    if c.getFilter() in @[NtscFilter, NtscSharpFilter]:
      c.setFilter(if sharperNtsc: NtscSharpFilter else: NtscFilter)

# }}}
# {{{ setShaderQuality()
proc setShaderQuality(c: UaeConfig, shaderQuality: ShaderQuality) =
  case shaderQuality
  of sqFast:
    c.cfg["gfx_filter_mode"]  = "1x"
    c.cfg["gfx_filter_mode2"] = "2x"

  of sqBest:
    c.cfg["gfx_filter_mode"]  = "2x"
    c.cfg["gfx_filter_mode2"] = "3x"

# }}}
# {{{ setVsyncMode()
proc setVsyncMode(c: UaeConfig, vsyncMode: VsyncMode) =

  proc setDoubleBuffering() =
    c.cfg["gfx_backbuffers"] = "1"

  proc setTripleBuffering() =
    c.cfg["gfx_backbuffers"] = "2"

  case vsyncMode
  of vmStandard:
    c.cfg["gfx_vsync"]     = "autoswitch"
    c.cfg["gfx_vsyncmode"] = "normal"
    setTripleBuffering()

  of vmLagless:
    c.cfg["gfx_vsync"]     = "autoswitch"
    c.cfg["gfx_vsyncmode"] = "busywait"
    setDoubleBuffering()

  of vmOff:
    c.cfg["gfx_vsync"]     = "false"
    c.cfg["gfx_vsyncmode"] = "normal"
    setTripleBuffering()

# }}}
# {{{ setLaglessVsyncSlices()
proc setLaglessVsyncSlices(c: UaeConfig, vsyncSlices: string) =

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
# {{{ Set audio settings
# {{{ setAudioInterface()
proc setAudioInterface(c: UaeConfig, audioInterface: AudioInterface) =
  # TODO
  c.cfg[""] = $audioInterface

# }}}
# {{{ setSampleRate()
proc setSampleRate(c: UaeConfig, sampleRate: SampleRate) =
  # TODO
  c.cfg[""] = $sampleRate

# }}}
# {{{ setSoundBufferSize()
proc setSoundBufferSize(c: UaeConfig, bufSize: SoundBufferSize) =
  # TODO
  c.cfg[""] = $bufSize

# }}}
# {{{ setVolume()
proc setVolume(c: UaeConfig, volume: string) =
  # TODO
  c.cfg[""] = volume

# }}}
# {{{ setStereoSeparation()
proc setStereoSeparation(c: UaeConfig, sep: StereoSeparation) =
  # TODO
  c.cfg[""] = $sep

# }}}
# {{{ setFloppySounds()
proc setFloppySounds(c: UaeConfig, enabled: bool) =
  # TODO
  c.cfg[""] = $enabled

# }}}
# }}}
# {{{ Set general settings
# {{{ setConfirmQuit()
proc setConfirmQuit(c: UaeConfig, enabled: bool) =
  # TODO
  c.cfg[""] = $enabled

# }}}
# {{{ setPauseWhenUnfocused()
proc setPauseWhenUnfocused(c: UaeConfig, enabled: bool) =
  # TODO
  c.cfg[""] = $enabled

# }}}
# {{{ setWindowDecorations()
proc setWindowDecorations(c: UaeConfig, d: WindowDecorations) =
  # TODO
  c.cfg[""] = $d

# }}}
# {{{ setShowToolbar()
proc setShowToolbar(c: UaeConfig, enabled: bool) =
  # TODO
  c.cfg[""] = $enabled

# }}}
# {{{ setCaptureMouseOnFocus()
proc setCaptureMouseOnFocus(c: UaeConfig, enabled: bool) =
  # TODO
  c.cfg[""] = $enabled

# }}}
# {{{ setRawScreenshots()
proc setRawScreenshots(c: UaeConfig, enabled: bool) =
  # TODO
  c.cfg[""] = $enabled

# }}}
# }}}

# {{{ applySettings*()
proc applySettings*(cfg: UaeConfig, settings: Settings) =
  with settings.display:
    if displayMode.set:
      cfg.setDisplayMode(displayMode.value)

    if windowWidth.set or windowHeight.set:
      cfg.setWindowSize(windowWidth.value, windowHeight.value)

    if windowPosX.set or windowPosY.set:
      cfg.setWindowPos(windowPosX.value, windowPosY.value)

    if resizableWindow.set:
      cfg.setResizableWindow(resizableWindow.value)

    if showOsd.set: cfg.setShowOsd(showOsd.value)

    if crtEmulation.set:
      cfg.setCrtEmulation(crtEmulation.value)

    if sharperPal.set:
      # Must be called after `setCrtEmulation`
      cfg.setSharperPal(sharperPal.value)

    if sharperNtsc.set:
      # Must be called after `setCrtEmulation`
      cfg.setSharperNtsc(sharperNtsc.value)

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


  with settings.audio:
    discard

    #[ TODO
    if audioInterface.set:
      cfg.setAudioInterface(audioInterface.value)

    if sampleRate.set:
      cfg.setSampleRate(sampleRate.value)

    if soundBufferSize.set:
      cfg.setSoundBufferSize(soundBufferSize.value)

    if volume.set:
      cfg.setVolume(volume.value)

    if stereoSeparation.set:
      cfg.setStereoSeparation(stereoSeparation.value)

    if floppySounds.set:
      cfg.setFloppySounds(floppySounds.value)
    ]#

  with settings.general:
    discard

    #[ TODO
    if confirmQuit.set:
        cfgConfirmQuit.set(confirmQuit.value)

    if pauseWhenUnfocused.set:
        cfgPauseWhenUnfocused.set(pauseWhenUnfocused.value)

    if windowDecorations.set:
        cfg.setWindowDecorations(windowDecorations.value)

    if showToolbar.set:
        cfg.setShowToolbar(showToolbar.value)

    if captureMouseOnFocus.set:
        cfg.setCaptureMouseOnFocus(captureMouseOnFocus.value)

    if rawScreenshots.set:
        cfg.setRawScreenshots(rawScreenshots.value)
    ]#

# }}}

# vim: et:ts=2:sw=2:fdm=marker
