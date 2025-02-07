{.hints: off.}

import std/os
import std/strformat
import std/strutils

var exeName = "conftool".toExe

const Version = staticRead("CURRENT_VERSION").strip
const GitHash = strutils.strip(staticExec("git rev-parse --short=5 HEAD"))

# Directory containing local copies of the module dependencies
const NimModules = "/Users/john.novak/.jn"

proc setCommonCompileParams() =
  --deepcopy:on
  --d:nvgGL3
  --d:glfwStaticLib

  switch("path", NimModules / "nim-glfw")
  switch("path", NimModules / "nim-nanovg")
  switch("path", NimModules / "koi")

  switch "out", exeName
  setCommand "c", "src/guiapp"

# All tasks must be executed from the project root directory!

task version, "get version number":
  echo Version

task gitHash, "get Git hash":
  echo GitHash

task versionAndGitHash, "get version and Git hash":
  echo fmt"{Version}-{GitHash}"

task debug, "compile debug build":
  --d:debug
  setCommonCompileParams()

task runDebug, "compile & run debug build":
  debugTask()
  setCommand "r"

task releaseNoStacktrace, "compile release build (no stacktrace)":
  --d:release
  --app:gui
  setCommonCompileParams()

task release, "compile release build":
  --stacktrace:on
  --linetrace:on
  releaseNoStacktraceTask()

task runRelease, "compile & run release build":
  releaseTask()
  setCommand "r"

task clean, "clean everything":
  rmFile exeName
