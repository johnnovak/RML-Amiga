{.hints: off.}

import os
import strformat
import strutils

var exeName = "conftool".toExe

const rootDir = getCurrentDir()
const version = staticRead("CURRENT_VERSION").strip
const gitHash = strutils.strip(staticExec("git rev-parse --short=5 HEAD"))
const currYear = CompileDate[0..3]


proc setCommonCompileParams() =
  --deepcopy:on
  --d:nvgGL3
  --d:glfwStaticLib

  --path:"../nim-glfw"
  --path:"../nim-nanovg"
  --path:"../koi"

  switch "out", exeName
  setCommand "c", "src/guiapp"

# All tasks must be executed from the project root directory!

task version, "get version number":
  echo version

task gitHash, "get Git hash":
  echo gitHash

task versionAndGitHash, "get version and Git hash":
  echo fmt"{version}-{gitHash}"

task debug, "debug build":
  --d:debug
  setCommonCompileParams()

task releaseNoStacktrace, "release build (no stacktrace)":
  --d:release
  --app:gui
  setCommonCompileParams()

task release, "release build":
  --stacktrace:on
  --linetrace:on
  releaseNoStacktraceTask()

task clean, "clean everything":
  rmFile exeName
