# {{{ Imports

import std/lenientops
import std/logging as log except Level
import std/options
import std/os
import std/parsecfg
import std/paths
import std/strformat
import std/strutils
import std/sugar
import std/tables

import glad/gl

import glfw
from glfw/wrapper import showWindow

import koi
import nanovg

import with
when not defined(DEBUG):
  import osdialog

import core
import utils

# }}}

# {{{ Types
type
  AppShortcut = enum
    scNextTextField
    scAccept
    scCancel

  App = object
    config:       Config
    settings:     Settings

    styles:       Styles
    currTab:      MainTab
    helpText:     string
    applyTarget:  ApplyTarget

    shortcuts:    Table[AppShortcut, seq[KeyShortcut]]
    dialogs:      Dialogs

    logFile:      File

  Styles = object
    helpText:     TextAreaStyle
    fileList:     TextAreaStyle

  MainTab = enum
    mtDisplay = "Display"
    mtAudio   = "Audio"
    mtGeneral = "General"

  ApplyTarget = enum
    atAll      = "All configs"
    atAllGames = "All games"
    atAllDemos = "All demos"


  Dialogs = object
    activeDialog:     Dialog

    applyError:       ApplyErrorDialogParams
    applyDragAndDrop: ApplyDragAndDropDialogParams

  Dialog = enum
    dlgNone
    dlgApplyError
    dlgResetSettings
    dlgApplyDragAndDrop

  ApplyErrorDialogParams = object
    paths:    seq[Path]
    pathList: string

  ApplyDragAndDropDialogParams = object
    paths:    seq[Path]
    pathList: string

# }}}
# {{{ Constants
const
  DialogLayoutParams = AutoLayoutParams(
    itemsPerRow:       2,
    rowWidth:          320.0,
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
  IconClose  = "\ue901"
  IconFloppy = "\uf0c7"
  IconTrash  = "\uf1f8"

const
  DlgItemHeight   = 24.0
  DlgButtonWidth  = 80.0
  DlgButtonPad    = 10.0
  DlgTopPad       = 50.0
  DlgLeftPad      = 20.0

  ConfirmDlgWidth  = 370.0
  ConfirmDlgHeight = 160.0

  # for fontSize = 14.0 and lineHeight = 1.4
  TextAreaLineHeight = 19.0

# }}}
# {{{ DefaultSettings
const DefaultSettings = Settings(
  display:  DisplaySettings(
    displayMode:         (dmFullWindow,  false),
    windowWidth:         ("1280",        false),
    windowHeight:        ("960",         false),
    resizableWindow:     (true,          false),
    showOsd:             (true,          false),

    crtEmulation:        (true,          false),
    shaderQuality:       (sqBest,        false),
    palScaling:          (palScaling30,  false),
    ntscScaling:         (ntscScaling30, false),

    sharperPal:          (false,         false),
    sharperNtsc:         (false,         false),
    interlacing:         (false,         false),
    vsyncMode:           (vmStandard,    false),
    vsyncSlices:         ("2",           false)
  ),

  audio: AudioSettings(
    audioInterface:      (adDirectSound, false),
    sampleRate:          (sr48000,       false),
    soundBufferSize:     (sbs4,          false),
    volume:              ("100",         false),
    stereoSeparation:    (ss50,          false),
    floppySounds:        (true,          false)
  ),

  general: GeneralSettings(
    confirmQuit:         (true,          false),
    pauseWhenUnfocused:  (false,         false),

    windowDecorations:   (wdNormal,      false),
    showToolbar:         (false,         false),
    captureMouseOnFocus: (true,          false),

    rawScreenshots:      (true,          false)
  )
)

# }}}
# {{{ Globals

var vg: NVGContext
var app: App

# }}}

# {{{ Logging

const LogFileName = "conftool.log"

# {{{ rollLogFile()
proc rollLogFile() =
  let fileNames = @[
    LogFileName & ".bak3",
    LogFileName & ".bak2",
    LogFileName & ".bak1",
    LogFileName
  ]

  for i, fname in fileNames:
    if fileExists(fname):
      if i == 0:
        discard tryRemoveFile(fname)
      else:
        try:
          moveFile(fname, fileNames[i-1])
        except CatchableError:
          discard

# }}}
# {{{ initLogger()
proc initLogger() =
  rollLogFile()
  app.logFile = open(LogFileName, fmWrite)

  var fileLog = newFileLogger(
    app.logFile,
    fmtStr = "[$levelname] $date $time - ",
    levelThreshold = if defined(DEBUG): lvlDebug else: lvlInfo
  )

  addHandler(fileLog)

# }}}
# {{{ logError()
proc logError(e: ref Exception, msgPrefix: string = "") =
  var msg = "Error message: " & e.msg & "\n\nStack trace:\n" & getStackTrace(e)
  if msgPrefix != "":
    msg = msgPrefix & "\n" & msg

  log.error(msg)

# }}}

# }}}

# {{{ Shortcuts

# {{{ hasKeyEvent()
proc hasKeyEvent: bool =
  koi.hasEvent() and koi.currEvent().kind == ekKey

# }}}
# {{{ checkShortcut()
proc isShortcutDown(ev: Event, shortcut: AppShortcut): bool =
  if ev.kind == ekKey:
    if ev.action in {kaDown}:
      let currShortcut = mkKeyShortcut(ev.key, ev.mods)
      if currShortcut in app.shortcuts[shortcut]:
        return true

# }}}

let DefaultAppShortcuts = {
  scNextTextField:      @[mkKeyShortcut(keyTab,           {})],

  scAccept:             @[mkKeyShortcut(keyEnter,         {}),
                          mkKeyShortcut(keyKpEnter,       {})],

  scCancel:             @[mkKeyShortcut(keyEscape,        {}),
                          mkKeyShortcut(keyLeftBracket,   {mkCtrl})]

}.toTable

# }}}

# {{{ closeDialog()
proc closeDialog() =
  koi.closeDialog()
  app.dialogs.activeDialog = dlgNone

# }}}
# {{{ dialogButtonsStartPos()
func dialogButtonsStartPos(dlgWidth, dlgHeight: float,
                           numButtons: Natural): tuple[x, y: float] =
  const BorderPad = 15.0

  let x = dlgWidth - numButtons * DlgButtonWidth - BorderPad -
          (numButtons-1) * DlgButtonPad

  let y = dlgHeight - DlgItemHeight - BorderPad

  result = (x, y)

# }}}

# {{{ applySettings()

# Returns failed paths
proc applySettings(configPaths: seq[Path]): seq[Path] =
  var failedPaths: seq[Path] = @[]

  for path in configPaths:
    try:
      let cfg = readUaeConfig(path)
      cfg.applySettings(app.settings)
      cfg.write(path)

    except CatchableError as e:
      logError(e, fmt"Error applying config, path: {path}")
      failedPaths.add(path)

  failedPaths

# }}}
#
# {{{ Apply error dialog

proc openApplyErrorDialog(failedPaths: seq[Path]) =
  alias(dlg, app.dialogs.applyError)

  app.dialogs.activeDialog = dlgApplyError

  var pathList = ""

  for p in failedPaths:
    let (path, name, ext) = p.splitFile
    if pathList != "":
       pathList &= "\n"
    pathList &= $name

  dlg.paths    = failedPaths
  dlg.pathList = pathList


proc applyErrorDialog() =
  alias(dlg, app.dialogs.applyError)

  let
    DlgWidth  = koi.winWidth() - 70
    DlgHeight = 372.0

  koi.beginDialog(DlgWidth, DlgHeight, fmt"Error applying changes")

  let x = DlgLeftPad
  var y = DlgTopPad
  let w = DlgWidth-DlgLeftPad*2

  koi.label(x, y, w, h=30, "Could not apply changes to the below configs:")
  y += 40

  koi.textArea(x, y, w, h=DlgHeight-148, dlg.pathList,
               disabled=true, style=app.styles.fileList)

  const ButtonWidth = 75
  if koi.button(x=(DlgWidth - ButtonWidth) / 2, y=DlgHeight-40,
                w=75, h=24, "OK"):
    closeDialog()

  koi.endDialog()

# }}}
# {{{ Apply drag-and-drop dialog

proc openApplyDragAndDropDialog(paths: seq[Path]) =
  alias(dlg, app.dialogs.applyDragAndDrop)

  app.dialogs.activeDialog = dlgApplyDragAndDrop

  var pathList = ""
  for p in paths:
    let (path, name, ext) = p.splitFile
    if pathList != "":
       pathList &= "\n"
    pathList &= $name

  dlg.paths    = paths
  dlg.pathList = pathList


proc applyDragAndDropDialog() =
  alias(dlg, app.dialogs.applyDragAndDrop)

  const
    DlgWidth  = ConfirmDlgWidth
    DlgHeight = 374.0

  let h = DlgItemHeight

  koi.beginDialog(DlgWidth, DlgHeight, fmt"{IconTrash}  Apply Settings?")

  var x = DlgLeftPad
  var y = DlgTopPad
  let w = DlgWidth-DlgLeftPad*2

  koi.label(x, y, w, h=30, "Apply settings to the below configs?")
  y += 40

  koi.textArea(x, y, w, h=DlgHeight-148, dlg.pathList,
               disabled=true, style=app.styles.fileList)

  proc okAction() =
    let failedPaths = applySettings(dlg.paths)
    if failedPaths.len > 0:
      openApplyErrorDialog(failedPaths)

    closeDialog()

  proc cancelAction() =
    closeDialog()


  (x, y) = dialogButtonsStartPos(DlgWidth, DlgHeight, 2)

  if koi.button(x, y, DlgButtonWidth, h, fmt"{IconCheck} Apply"):
    okAction()

  x += DlgButtonWidth + DlgButtonPad
  if koi.button(x, y, DlgButtonWidth, h, fmt"{IconClose} Cancel"):
    cancelAction()


  if hasKeyEvent():
    let ke = koi.currEvent()
    var eventHandled = true

    if   ke.isShortcutDown(scCancel): cancelAction()
    elif ke.isShortcutDown(scAccept): okAction()
    else: eventHandled = false

    if eventHandled: setEventHandled()

  koi.endDialog()

# }}}
# {{{ Reset settings dialog

proc openResetSettingsDialog() =
  app.dialogs.activeDialog = dlgResetSettings

proc resetSettingsDialog() =
  const
    DlgWidth  = ConfirmDlgWidth
    DlgHeight = ConfirmDlgHeight

  let h = DlgItemHeight

  koi.beginDialog(DlgWidth, DlgHeight, fmt"{IconTrash}  Reset Settings?")

  var x = DlgLeftPad
  var y = DlgTopPad

  koi.label(
    x, y, DlgWidth, h, "Are you sure you want to reset the settings?"
  )

  proc okAction() =
    app.settings = DefaultSettings
    closeDialog()

  proc cancelAction() =
    closeDialog()


  (x, y) = dialogButtonsStartPos(DlgWidth, DlgHeight, 2)

  if koi.button(x, y, DlgButtonWidth, h, fmt"{IconCheck} Reset"):
    okAction()

  x += DlgButtonWidth + DlgButtonPad
  if koi.button(x, y, DlgButtonWidth, h, fmt"{IconClose} Cancel"):
    cancelAction()


  if hasKeyEvent():
    let ke = koi.currEvent()
    var eventHandled = true

    if   ke.isShortcutDown(scCancel): cancelAction()
    elif ke.isShortcutDown(scAccept): okAction()
    else: eventHandled = false

    if eventHandled: setEventHandled()

  koi.endDialog()

# }}}

# {{{ getConfigPaths()
proc getConfigPaths(applyTarget: ApplyTarget): seq[Path] =
  # TODO
  let basePath = "../../Configurations"

  let path = case applyTarget
             of atAll:      basePath
             of atAllGames: basePath / "Games"
             of atAllDemos: basePath / "Demos"

  getConfigPaths(path.Path)

# }}}

# {{{ setHelpText()
template setHelpText(s: string) =
  let y = koi.autoLayoutNextY()
  let oy = koi.drawOffset().oy

  let mouseInsideWindow = koi.mouseInside(x=0, y=0,
                                          w=koi.winWidth(), h=koi.winHeight())

  if mouseInsideWindow and not koi.isDialogOpen() and
    (koi.my() >= oy + y and
     koi.my() <= oy + y + 22):

    const text = s.unindent.replace("\n", " ")
    app.helpText = text

# }}}
# {{{ renderDisplayTab()
proc renderDisplayTab() =
  group:
    koi.toggleButton(app.settings.display.displayMode.set, "Display mode")
    setHelpText("""
      Set the default display mode. You can always toggle between 'Windowed'
      and 'Full-windowed' with End+12. Use 'Fullscreen' for the best results
      with lagless vsync enabled.
    """)
    koi.dropDown(app.settings.display.displayMode.value,
                 disabled = not app.settings.display.displayMode.set)

    # Window size
    koi.toggleButton(app.settings.display.windowWidth.set, "Window size")
    setHelpText("Set the window size in windowed mode.")
    var y = koi.autoLayoutNextY()

    koi.nextItemWidth(55)
    koi.textField(
      app.settings.display.windowWidth.value,
      tooltip = "",
      constraint = TextFieldConstraint(
        kind:   tckInteger,
        minInt: 640,
        maxInt: 9999
      ).some,
      disabled = not app.settings.display.windowWidth.set
    )

    koi.label(x=251, y, w=20, h=22, "x")

    koi.textField(
      x=265, y, w=55, h=22,
      app.settings.display.windowHeight.value,
      constraint = TextFieldConstraint(
        kind:   tckInteger,
        minInt: 480,
        maxInt: 9999
      ).some,
      disabled = not app.settings.display.windowWidth.set
    )

    # Window position
    koi.toggleButton(app.settings.display.windowPosX.set, "Window position")
    setHelpText("Set the position of the window in windowed mode.")
    y = koi.autoLayoutNextY()

    koi.nextItemWidth(55)
    koi.textField(
      app.settings.display.windowPosX.value,
      tooltip = "",
      constraint = TextFieldConstraint(
        kind:   tckInteger,
        minInt: 640,
        maxInt: 9999
      ).some,
      disabled = not app.settings.display.windowPosX.set
    )

    koi.label(x=251, y, w=20, h=22, "x")

    koi.textField(
      x=265, y, w=55, h=22,
      app.settings.display.windowPosY.value,
      constraint = TextFieldConstraint(
        kind:   tckInteger,
        minInt: 480,
        maxInt: 9999
      ).some,
      disabled = not app.settings.display.windowPosY.set
    )

    koi.toggleButton(app.settings.display.resizableWindow.set,
                     "Resizable window")
    setHelpText("""
      Allow resizing the window in windowed mode.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.display.resizableWindow.value,
                 disabled = not app.settings.display.resizableWindow.set)

    koi.toggleButton(app.settings.display.showOsd.set, "Show OSD")
    setHelpText("""
        Show on-screen display (OSD) in the bottom-right corner that
        indicates the floppy and hard drive activity of the emulated machine,
        CPU and audio buffer utilisation, current FPS, pause/warp mode,
        etc.
    """)

    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.display.showOsd.value,
                 disabled=not app.settings.display.showOsd.set)

  group:
    koi.toggleButton(app.settings.display.palScaling.set, "PAL scaling")
    setHelpText("""
      Set the scaling factor for PAL games and demos. Fractional scaling
      factors (3.2x in particular) can result in some vertical interference
      patterns on 1080p screens. This is especially noticeable on fade-in &
      fade-out effects.
    """)
    koi.nextItemWidth(60)
    koi.dropDown(app.settings.display.palScaling.value,
                 disabled = not app.settings.display.palScaling.set)

    koi.toggleButton(app.settings.display.ntscScaling.set, "NTSC scaling")
    setHelpText("""
      Set the scaling factor for NTSC and NTSC50 games. Unlike the PAL
      shader, the NTSC shader is not prone to vertical interference patterns
      with fractional scaling factors.
    """)
    koi.nextItemWidth(60)
    koi.dropDown(app.settings.display.ntscScaling.value,
                 disabled = not app.settings.display.ntscScaling.set)

  group:
    koi.toggleButton(app.settings.display.crtEmulation.set, "CRT emulation")
    setHelpText("""
      Emulate an authentic Commodore CRT monitor. Pixels are rendered as
      sharp little rectangles if disabled. You might need to disable CRT
      emulation if you have a really weak GPU and you're getting slowdowns
      or audio drop-outs.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.display.crtEmulation.value,
                 disabled = not app.settings.display.crtEmulation.set)

    koi.toggleButton(app.settings.display.shaderQuality.set,
                     "CRT emulation quality")
    setHelpText("""
      'Best' is recommended to minimise vertical interference patterns.
      Only select 'Fast' if you have a weak GPU and you're getting slowdowns
      and audio drop-outs (it's three times faster than 'Best').
    """)
    koi.dropDown(app.settings.display.shaderQuality.value,
                 disabled = not app.settings.display.shaderQuality.set)

    koi.toggleButton(app.settings.display.sharperPal.set,
                     "Sharper PAL emulation")
    setHelpText("""
      Enable maximum horizontal sharpness for PAL CRT emulation. This
      increases the legibility of 80-column text (e.g., in text adventures),
      and makes the image appear sharper at higher scaling factors. The
      drawback is it reduces the benefical 'natural antialiasing' effects of
      the CRT emulation (the pixels will appear more like distinct
      rectangles).""")
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.display.sharperPal.value,
                 disabled = not app.settings.display.sharperPal.set)

    koi.toggleButton(app.settings.display.sharperNtsc.set,
                     "Sharper NSTC emulation")
    setHelpText("""
      Enable maximum horizontal sharpness for PAL CRT emulation. This
      increases the legibility of 80-column text (e.g., in text adventures),
      and makes the image appear sharper at higher scaling factors. The
      drawback is it reduces the benefical 'natural antialiasing' effects of
      the CRT emulation (the pixels will appear more like distinct
      rectangles).""")
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.display.sharperNtsc.value,
                 disabled = not app.settings.display.sharperNtsc.set)

  group:
    koi.toggleButton(app.settings.display.vsyncMode.set, "Vsync mode")
    setHelpText("""
      'Off' is the best option for VRR monitors. On non-VRR monitors, it can
      add tearing, but reduces input lag. 'Standard' eliminates tearing in
      both windowed and fullscreen modes on non-VRR monitors, but increases
      input lag. 'Lagless' drastically reduces input lag but it doesn't work
      in windowed mode, it needs true fullscreen for the best results, and
      requires either a VRR monitor or matching 50/60 desktop refresh rates
      for PAL/NTSC.
    """)
    koi.dropDown(app.settings.display.vsyncMode.value,
                 disabled = not app.settings.display.vsyncMode.set)

    koi.toggleButton(app.settings.display.vsyncSlices.set,
                     "Lagless vsync slices")
    setHelpText("""
      Number of frame slices in lagless vsync mode. Higher values reduce
      latency, values between 2 and 8 and the most useful (setup dependent,
      you'll need to experiment). Generally, you'll need slightly larger
      audio buffers in lagless vsync mode.
    """)
    koi.nextItemWidth(60)
    koi.textField(
      app.settings.display.vsyncSlices.value,
      constraint = TextFieldConstraint(
        kind:   tckInteger,
        minInt: 1,
        maxInt: 29
      ).some,
      disabled = not app.settings.display.vsyncSlices.set
    )

    koi.toggleButton(app.settings.display.interlacing.set,
                     "Interlacing emulation")
    setHelpText("""
      Enable interlace flicker emulation in hi-res screen modes (400 pixel
      high NTSC and 512 pixel high PAL modes). Interlacing emulation works
      best with vsync enabled and a 50 Hz desktop refresh rate for PAL and
      60 Hz for NTSC, or a VRR monitor.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.display.interlacing.value,
                 disabled = not app.settings.display.interlacing.set)

# }}}
# {{{ renderAudioTab()
proc renderAudioTab() =
  group:
    koi.toggleButton(app.settings.audio.audioInterface.set, "Audio interface")
    setHelpText("""
      Set the Windows audio interface used by the emulator. In theory, WASAPI
      should be the better option, allowing you to use smaller buffer sizes,
      but in practice DirectSound works better on many common audio hardware.
    """)
    koi.dropDown(app.settings.audio.audioInterface.value,
                 disabled = not app.settings.audio.audioInterface.set)

    koi.toggleButton(app.settings.audio.sampleRate.set, "Sample rate")
    setHelpText("""
      Set the sample rate in Hz. Most audio interfaces use 48000 Hz
      natively, so that's the best general setting.
    """)
    koi.nextItemWidth(80)
    koi.dropDown(app.settings.audio.sampleRate.value,
                 disabled = not app.settings.audio.sampleRate.set)

    koi.toggleButton(app.settings.audio.soundBufferSize.set,
                     "Sound buffer size")
    setHelpText("""
      Set the size of the sound buffer. If you get distorted audio or
      occasional glitches and drop-outs, try increasing the buffer size. With
      lagless vsync enabled, larger buffer sizes might be detrimental; you'll
      need to find the optimum buffer size that results in glitch-free audio
      and no vsync tearing.
    """)
    koi.nextItemWidth(60)
    koi.dropDown(app.settings.audio.soundBufferSize.value,
                 disabled = not app.settings.audio.soundBufferSize.set)

  group:
    koi.toggleButton(app.settings.audio.volume.set, "Volume")
    setHelpText("""
      Set the global volume of the emulator. This includes the sound of the
      emulated Amiga, the floppy sound emulation, and CD audio.
    """)
    let y = koi.autoLayoutNextY()

    koi.nextItemWidth(60)
    koi.textField(
      app.settings.audio.volume.value,
      tooltip = "",
      constraint = TextFieldConstraint(
        kind: tckInteger, minInt: 1, maxInt: 100
      ).some,
      disabled = not app.settings.audio.volume.set
    )

    koi.toggleButton(app.settings.audio.stereoSeparation.set,
                     "Stereo separation")
    setHelpText("""
      Set the amount of stereo separation between the left and right audio
      channels. The Amiga has four audio channels: two are connected to the
      left speaker, and the other two to the right speaker. This is 100%
      separation which is rather jarring on headphones. 50% stereo separation
      causes half of the left channels to be mixed into the right channels and
      vice versa, and 0% separation results in mono audio.
    """)
    koi.nextItemWidth(60)
    koi.dropDown(app.settings.audio.stereoSeparation.value,
                 disabled = not app.settings.audio.stereoSeparation.set)

  group:
    koi.toggleButton(app.settings.audio.floppySounds.set, "Floppy sounds")
    setHelpText("""
      Enable authentic emulation of the sounds of the floppy disk drives. This
      provides additional feedback on the disk drives' activity, and acts as a
      progress indicator (i.e., loading times can appear subjectively shorter
      if you're hearing the floppy activity).
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.audio.floppySounds.value,
                 disabled = not app.settings.audio.floppySounds.set)

# }}}
# {{{ renderGeneralTab()
proc renderGeneralTab() =
  group:
    koi.toggleButton(app.settings.general.confirmQuit.set, "Confirm quit")
    setHelpText("""
      Ask for confirmation when quitting the emulator.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.general.confirmQuit.value,
                 disabled = not app.settings.general.confirmQuit.set)

    koi.toggleButton(app.settings.general.pauseWhenUnfocused.set,
                     "Pause when unfocused")
    setHelpText("""
      Pause the emulation when the emulator window is unfocused.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.general.pauseWhenUnfocused.value,
                 disabled = not app.settings.general.pauseWhenUnfocused.set)

  group:
    koi.toggleButton(app.settings.general.windowDecorations.set,
                     "Window decorations")
    setHelpText("""
      TODO
    """)
    koi.nextItemWidth(90)
    koi.dropDown(app.settings.general.windowDecorations.value,
                 disabled = not app.settings.general.windowDecorations.set)


    koi.toggleButton(app.settings.general.showToolbar.set, "Show toolbar")
    setHelpText("""
      Show toolbar in windowed mode (even if the OSD is enabled).
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.general.showToolbar.value,
                 disabled = not app.settings.general.showToolbar.set)

    koi.toggleButton(app.settings.general.captureMouseOnFocus.set,
                     "Capture mouse on focus")
    setHelpText("""
      Capture the mouse when the emulator windows becomes focused.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.general.captureMouseOnFocus.value,
                 disabled = not app.settings.general.captureMouseOnFocus.set)

  group:
    koi.toggleButton(app.settings.general.rawScreenshots.set, "Raw screenshots")
    setHelpText("""
      If enabled, the saved screenshots will contain the raw image, not what
      you see on the screen post-scaling and CRT shaders. If disabled, exactly
      what you seen on the screen will be saved.
    """)
    koi.nextItemHeight(CheckBoxSize)
    koi.checkBox(app.settings.general.rawScreenshots.value,
                 disabled = not app.settings.general.rawScreenshots.set)

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

  let winWidth  = koi.winWidth()
  let winHeight = koi.winHeight()

  const
    PadX = 25.0
    ButtonHeight = 24.0

  var
    x = PadX
    y = 25.0

  # Clear background
  vg.beginPath()
  vg.rect(0, 0, winWidth, winHeight)
  vg.fillColor(gray(0.28))
  vg.fill()

  # Tabs
  let tabWidth = winWidth-PadX*2
  x = (winWidth - tabWidth) / 2
  koi.radioButtons(x, y, w=tabWidth, h=ButtonHeight, app.currTab)

  x = (winWidth - DialogLayoutParams.rowWidth) / 2 - 10
  y += 60
  renderTabs(x, y)

  # Help text
  x= PadX
  y += 460
  koi.textArea(x, y, w=winWidth-2*PadX, h=150, app.helpText, disabled=true,
               style=app.styles.helpText)

  # Action buttons
  y = winHeight - 22 - 25

  if koi.button(x, y, w=75, h=ButtonHeight, "Reset"):
    openResetSettingsDialog()

#  if koi.button(x+83, y, w=75, h=ButtonHeight, "Load"):
#    # TODO
#    discard

  if koi.button(winWidth-90-x-98, y, w=90, h=ButtonHeight, "Apply to"):
    let configPaths = getConfigPaths(app.applyTarget)
    let failedPaths = applySettings(configPaths)

    if failedPaths.len > 0:
      openApplyErrorDialog(failedPaths)

  koi.dropDown(winWidth-90-x, y, w=90, h=ButtonHeight, app.applyTarget)

  case app.dialogs.activeDialog
  of dlgNone:             discard
  of dlgApplyDragAndDrop: applyDragAndDropDialog()
  of dlgApplyError:       applyErrorDialog()
  of dlgResetSettings:    resetSettingsDialog()

  koi.endFrame()

# }}}

# {{{ GLFW callbacks
proc renderFrame(win: Window, res: tuple[w, h: int32] = (0,0)) =
  if win.iconified: return
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
  cfg.size          = (w: 480, h: 760)
  cfg.title         = fmt"RML Amiga Configuration Tool (v{AppVersion})"
  cfg.resizable     = false
  cfg.visible       = false
  cfg.nMultiSamples = 4
  cfg.bits          = (r: some(8'i32), g: some(8'i32), b: some(8'i32),
                       a: some(8'i32),
                       stencil: some(8'i32), depth: some(16'i32))

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
      let msg = "Cannot load font '{path}'"
      logError(e, msg)
      raise newException(IOError, msg)

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

  # Help text
  app.styles.helpText = getDefaultTextAreaStyle()
  with app.styles.helpText:
    bgFillColorDisabled = gray(0.22)
    textColorDisabled   = gray(0.8)

  # File list in dialogs
  app.styles.fileList = getDefaultTextAreaStyle()
  with app.styles.fileList:
    bgFillColorDisabled = gray(0.27)
    textColorDisabled   = gray(0.8)

    with scrollBarStyleNormal:
      thumbFillColor      = white().withAlpha(0.40)
      thumbFillColorHover = white().withAlpha(0.50)
      thumbFillColorDown  = white().withAlpha(0.35)

# }}}

# {{{ dropCb()
proc dropCb(window: Window, paths: PathDropInfo) =
  if paths.len > 0:
    let pathSeq = collect:
      for s in paths.items: Path($s)

    openApplyDragAndDropDialog(pathSeq)

# }}}
# {{{ init()
proc init(): Window =
  app.settings  = DefaultSettings
  app.shortcuts = DefaultAppShortcuts

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
  win.dropCb = dropCb

  wrapper.showWindow(win.getHandle())

  result = win

# }}}
# {{{ deinit()
proc deinit() =
  koi.deinit()
  nvgDeleteContext(vg)
  glfw.terminate()

# }}}
# {{{ crashHandler()
proc crashHandler(e: ref Exception) =
  var msg = "A fatal error has occured, exiting program.\n\n" &
            "Error message: " & e.msg & "\n\n" &
            "Stack trace:\n" & getStackTrace(e)

  when not defined(DEBUG):
    discard osdialog_message(mblError, mbbOk, msg.cstring)

  logError(e, "A fatal error has occured, exiting program.")
  quit(QuitFailure)

# }}}

# {{{ main()
proc main() =
  initLogger()

  try:
    let win = init()

    while not win.shouldClose:
      if koi.shouldRenderNextFrame():
        glfw.pollEvents()
      else:
        glfw.waitEvents()
      renderFrame(win)

    deinit()

  except CatchableError as e:
    when defined(DEBUG): raise e
    else: crashHandler(e)

# }}}

main()

# vim: et:ts=2:sw=2:fdm=marker
