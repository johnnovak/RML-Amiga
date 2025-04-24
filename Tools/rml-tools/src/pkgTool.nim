import std/cmdline
import std/dirs
import std/files
import std/paths
import std/strformat
import std/strutils
import std/sugar
import std/tables

import core

let ConfigPath = Path("Configurations")
const ConfigExt = ".uae"

# {{{ getDirNames()
proc getDirNames*(path: Path): seq[Path] =
  collect:
    for (pc, p) in walkDir(path, relative=true):
      if pc == pcDir: p

# }}}
# {{{ getConfigNames()
proc getConfigNames*(path: Path): seq[string] =
  collect:
    for (pc, p) in walkDir(path, relative=true):
      if pc == pcFile:
        let (_, name, ext) = p.splitFile
        if ext == ConfigExt: $name

# }}}
# {{{ checkPaths()
proc checkPaths(configPath: Path, c: UaeConfig, basePath: Path) =
  var warnings = ""

  for (key, value) in c.cfg.pairs():
    if key.startsWith("diskimage") or
       key == "floppy1" or
       key == "floppy2" or
       key == "floppy3" or
       key == "floppy4" or
       key.startsWith("uaehf") or
       key.startsWith("filesystem"):

      if (key.startsWith("uaehf") or key.startsWith("filesystem")) and
         (value.contains("System-1.3") or value.contains("System-3.1")):
        continue

      let s = $basePath
      if value.len > 0 and not value.contains(s):
        warnings &= fmt"  config key '{key}' contains invalid path:" & "\n"
        warnings &= fmt"    {value}" & "\n\n"

  if warnings != "":
    echo fmt"*** WARNING: Config '{configPath}'"
    echo warnings

# }}}

# {{{ addConfigExt()
func addConfigExt(p: Path): Path =
  # We need to append the extension this way, otherwise
  # names with periods wouldn't work (e.g., Dungeon Master (v3.6)).
  Path($p & ConfigExt)

# }}}
# {{{ validate()
proc validate(categoryPath: Path, names: seq[Path]) =
  # Category is either "Games", "Demos\OCS", or "Demos\AGA"
  let
    configBasePath = ConfigPath / categoryPath
    configNames    = getConfigNames(configBasePath)

  for name in names:
    let
      dataBasePath       = categoryPath / name
      configPathNameOnly = configBasePath / name
      exactConfigPath    = addConfigExt(configPathNameOnly)

    let variantConfigPaths = collect:
      for n in configNames:
        if ($n).startsWith($name & " ["):
          addConfigExt(configBasePath / Path(n))

    if not (fileExists(exactConfigPath) or variantConfigPaths.len > 0):
      echo fmt"*** WARNING: missing config for '{$dataBasePath}'"
      echo ""

    if fileExists(exactConfigPath):
      let cfg = readUaeConfig(exactConfigPath)
      checkPaths(exactConfigPath, cfg, dataBasePath)

    for p in variantConfigPaths:
      let cfg = readUaeConfig(p)
      checkPaths(p, cfg, dataBasePath)

# }}}
# {{{ createPackScript()
proc createPackScript(category: string, names: seq[Path]): string =
  result = """
SET CMD=Tools\7za.exe
SET OUT=package-output

"""

  for name in names:
    result &= fmt"""
%CMD% a -tzip -r "%OUT%\{name}.zip" ^
	"{category}\{name}" ^
	"Configurations\{category}\{name}.uae" ^
	"Configurations\{category}\{name} [*].uae"

%CMD% rn "%OUT%\{name}.zip" Configurations "Original Configs"
%CMD% a  "%OUT%\{name}.zip" ^
	"Configurations\{category}\{name}.uae" ^
	"Configurations\{category}\{name} [*].uae"

"""

# }}}
# {{{ createUnpackScript()
proc createUnpackScript(category: string, names: seq[Path]): string =
  result = fmt"""
@echo off
SET CMD=7za.exe
SET TEMP=Temp
SET ARCHIVE=RML-Amiga-{category}-v1.0.zip

IF "%1" == "" (
	SET OUT_PATH_ARG=
) ELSE (
	SET OUT_PATH_ARG=-o"%1"
)

"""

  for idx, name in names.pairs():
    let escapedName = ($name).replace("&", "^&")
    result &= fmt"""
ECHO   [{(idx+1):>4} / {names.len}] - Extracting '{escapedName}'
%CMD% e -o%TEMP% -y -bso0 %ARCHIVE% "{name}.zip" || goto :error
%CMD% x -y -bso0 %OUT_PATH_ARG% "%TEMP%\{name}.zip" || goto :error
DEL "%TEMP%\{name}.zip" || goto :error

"""

  result &= """
RMDIR %TEMP%

ECHO/
ECHO [92mInstallation of 'RML-Amiga-{category}-V1.0' completed.[0m
ECHO/
IF NOT DEFINED FULL_INSTALL PAUSE
EXIT /B 0

:error
IF NOT DEFINED FULL_INSTALL PAUSE
EXIT /B %ERRORLEVEL%
"""

# }}}
# {{{ processCategory()
proc processCategory(category: string, outPrefix: string) =
  let
    categoryPath = Path(category)
    names        = getDirNames(categoryPath)

  validate(categoryPath, names)
  var content = createPackScript(category, names)
  writeFile(fmt"{outPrefix}-pack.bat", content)

  content = createUnpackScript(category, names)
  writeFile(fmt"{outPrefix}-unpack.bat", content)

# }}}
# {{{ processDir()
proc processDir(dirName: string, outfile: string) =
  let (categoryPath, name) = Path(dirName).splitPath
  let names = @[name]

  validate(categoryPath, @[name])
  let content = createPackScript($categoryPath, names)
  writeFile(outfile, content)

# }}}


# {{{ main()
proc main() =
  if paramCount() < 3:
    echo """
Usage: pkgTool category CATEGORY_NAME OUTPREFIX
       pkgTool single   DIR_NAME      OUTPREFIX

CATEGORY_NAME must be "Games", "Demos\OCS", or "Demos\AGA".
CONFIG_NAME must be the full path to the config
"""
    quit(1)

  let mode = paramStr(1)
  case mode
  of "category":
    let
      category = paramStr(2)
      outPrefix = paramStr(3)

    processCategory(category, outPrefix)

  of "single":
    let
      dirName = paramStr(2)
      outPrefix = paramStr(3)

    processDir(dirName, outPrefix)

  else:
    echo fmt"Invalid mode: '{mode}'"
    quit(1)

# }}}

main()

