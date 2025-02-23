{.hints: off.}

import std/os
import std/strformat
import std/strutils

const Version = staticRead("CURRENT_VERSION").strip
const GitHash = strutils.strip(staticExec("git rev-parse --short=5 HEAD"))

# Directory containing local copies of the module dependencies
const NimModules = "/Users/john.novak/dev/jn"

# All tasks must be executed from the project root directory!

task version, "get version number":
  echo Version

task gitHash, "get Git hash":
  echo GitHash

task versionAndGitHash, "get version and Git hash":
  echo fmt"{Version}-{GitHash}"

############# ConfToolGUI #############

proc setConfToolGuiCommonParams() =
  --deepcopy:on
  --d:nvgGL3
  --d:glfwStaticLib

  switch("path", NimModules / "nim-glfw")
  switch("path", NimModules / "nim-nanovg")
  switch("path", NimModules / "koi")

  switch "out", "ConfTool"
  setCommand "c", "src/confToolGui"

task confToolGuiDebug, "compile ConfToolGUI (debug build)":
  --d:debug
  setConfToolGuiCommonParams()

task confToolGuiRelease, "compile ConfToolGUI (release build)":
  --d:release
  --app:gui
  --stacktrace:on
  --linetrace:on
  setConfToolGuiCommonParams()

############### PkgTool ###############

proc setPkgToolCommonParams() =
  switch "out", "PkgTool"
  setCommand "c", "src/PkgTool"

task pkgToolDebug, "compile PkgTool (debug build)":
  --d:debug
  setPkgToolCommonParams()

task pkgToolRelease, "compile PkgTool (release build)":
  --d:release
  --stacktrace:on
  --linetrace:on
  setPkgToolCommonParams()

