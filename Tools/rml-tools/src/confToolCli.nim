import std/cmdline
import std/dirs
import std/os
import std/paths
import std/streams
import std/strformat
import std/strutils
import std/sugar
import std/terminal

# {{{ tryReadSetting()
proc tryReadSetting(line: string, setting: string, value: var string): bool =
  let p = line.split("=")
  if p.len == 2 and p[0] == setting:
    value = p[1]
    true
  else: false

# }}}
# {{{ setSetting()
proc setSetting(path: Path, setting: string, value: string): string =
  let contents = readFile($path)
  result = ""

  var
    stream = newStringStream(contents)
    line = ""

  var found = false

  while stream.readLine(line):
    var oldValue = ""
    if tryReadSetting(line, setting, oldValue):
      result &= fmt"{setting}={value}"
      found = true
    else:
      result &= line

    result &= "\r\n"

  if not found:
    result &= fmt"{setting}={value}"
    result &= "\r\n"

# }}}

# {{{ checkConfig()
proc checkConfig(path: Path): seq[string] =
  let contents = readFile($path)

  var
    stream = newStringStream(contents)
    line = ""
    value = ""

  var
    ntsc = false
    gfx_refresh_rate = 0
    gfx_filter = ""

  while stream.readLine(line):
    if tryReadSetting(line, "ntsc", value) and value == "true":
      ntsc = true

    elif tryReadSetting(line, "gfx_refresh_rate", value):
      gfx_refresh_rate = parseInt(value)

    elif tryReadSetting(line, "gfx_filter", value):
      gfx_filter = value

  result = @[]

  if ntsc:
    if gfx_refresh_rate != 60:
      result.add("NTSC config but 'gfx_refresh_rate' is not 60")

    if not gfx_filter.contains("NTSC"):
      result.add("NTSC config but 'gfx_filter' is not an NTSC shader")

  else: # PAL
    if gfx_refresh_rate != 50:
      result.add("PAL config but 'gfx_refresh_rate' is not 50")

#    if not gfx_filter.contains("PAL"):
#      result.add("PAL config but 'gfx_filter' is not a PAL shader")

# }}}
# {{{ getFilePaths()
proc getFilePaths(path: Path): seq[Path] =
  if fileExists($path):
    @[path]
  elif dirExists($path):
    collect:
      for p in walkDirRec(path): p
  else:
    echo fmt"ERROR: Path '{path}' does not exist"
    quit(1)

# }}}

# {{{ main()
proc main() =
  if paramCount() <= 1:
    echo "Usage: uae-conf-tool COMMAND PATH [ARGS]"
    quit(1)

  let
    command = paramStr(1)
    path    = paramStr(2).Path

  case command:
  of "check":
    for p in getFilePaths(path):
      let errors = checkConfig(p)
      if errors.len > 0:
        let (dir, file) = splitPath(p)
        styledEcho fgGreen, $dir, "/", fgYellow, $file
        for err in errors:
          echo fmt"  {err}"
        echo ""

  of "set":
    if paramCount() < 4:
      echo "Usage: uae-conf-tool set PATH PARAM VALUE"
      quit(1)

    let param = paramStr(3)
    let value = paramStr(4)

    for p in getFilePaths(path):
      let updatedConf = setSetting(p, param, value)
      var f = open($p, fmWrite)
      f.write(updatedConf)
      f.close()

# }}}

main()

# vim: et:ts=2:sw=2:fdm=marker
