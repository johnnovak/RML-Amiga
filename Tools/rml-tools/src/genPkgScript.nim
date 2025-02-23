import std/dirs
import std/files
import std/paths
import std/streams
import std/strformat
import std/strutils
import std/sugar
import std/tables

let ConfigPath = Path("Configurations")
const ConfigExt = ".uae"


proc getDirNames*(path: Path): seq[Path] =
  collect:
    for (pc, p) in walkDir(path, relative=true):
      if pc == pcDir: p

proc getConfigNames*(path: Path): seq[string] =
  collect:
    for (pc, p) in walkDir(path, relative=true):
      if pc == pcFile:
        let (_, name, ext) = p.splitFile
        if ext == ConfigExt: $name

# TODO common function
type
  UaeConfig = ref object
    cfg: OrderedTable[string, string]

const CommentKeyPrefix = "#comment-"

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


# We need to append the extension this way, otherwise
# names with periods wouldn't work (e.g., Dungeon Master (v3.6)).
func addConfigExt(p: Path): Path =
  Path($p & ConfigExt)


# Category is either "Games", "Demos\OCS", or "Demos\AGA"
proc process(category: string) =
  let
    categoryPath = Path(category)
    names = getDirNames(categoryPath)

    configBasePath = ConfigPath / categoryPath
    configNames = getConfigNames(configBasePath)

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
      echo fmt"*** WARNING: missing config for '{category}/{name}'"
      echo ""

    let cfg = readUaeConfig(exactConfigPath)

    checkPaths(exactConfigPath, cfg, dataBasePath)
    for p in variantConfigPaths:
      checkPaths(p, cfg, dataBasePath)


process("Games")

#[
set CMD=Tools\7za.exe
set OUT=package-output

%CMD% a -tzip -r %OUT%\"Secret of Monkey Island, The" ^
	"Games\Secret of Monkey Island, The" ^
	"Configurations\Games\Secret of Monkey Island, The.uae" ^
	"Configurations\Games\Secret of Monkey Island, The [*].uae"

# vim: et:ts=2:sw=2:fdm=marker

]#
