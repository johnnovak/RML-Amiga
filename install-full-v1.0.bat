@ECHO OFF

SET VERSION=v1.0

CLS
ECHO/
ECHO ==============================================================================
ECHO                         RML-Amiga %VERSION% full installer
ECHO ==============================================================================
ECHO/

SET CAN_INSTALL=1
SET INSTALL_ROMS=0
SET INSTALL_DEMOS=0

IF NOT EXIST 7za.exe (
	ECHO   [91m*** ERROR: 7za.exe not found[0m
	SET CAN_INSTALL=0
) ELSE (
	ECHO   [92m7za.exe found[0m
)

IF NOT EXIST RML-Amiga-Base-%VERSION%.zip (
	ECHO   [91m*** ERROR: Mandatory 'RML-Amiga-Base-%VERSION%.zip' not found[0m
	SET CAN_INSTALL=0
) ELSE (
	ECHO   [92m'RML-Amiga-Base-%VERSION%.zip' found[0m
)

IF NOT EXIST RML-Amiga-Systems-%VERSION%.zip (
	ECHO   [91m*** ERROR: Mandatory 'RML-Amiga-Systems-%VERSION%.zip' not found[0m
	SET CAN_INSTALL=0
) ELSE (
	ECHO   [92m'RML-Amiga-Systems-%VERSION%.zip' found[0m
)

IF NOT EXIST RML-Amiga-ROMs-%VERSION%.zip (
	ECHO/
	ECHO   [93m'RML-Amiga-ROMs-%VERSION%.zip' not found;[0m
    ECHO   [93m  you will need to supply the ROM files yourself.[0m
	ECHO/
) ELSE (
	ECHO   [92m'RML-Amiga-ROMs-%VERSION%.zip' found[0m
	SET INSTALL_ROMS=1
)

IF NOT EXIST RML-Amiga-Games-%VERSION%.zip (
	ECHO   [91m*** ERROR: Mandatory 'RML-Amiga-Games-%VERSION%.zip' not found[0m
	SET CAN_INSTALL=0
) ELSE (
	ECHO   [92m'RML-Amiga-Games-%VERSION%.zip' found[0m
)

IF NOT EXIST RML-Amiga-Demos-%VERSION%.zip (
	ECHO/
	ECHO   [93m'RML-Amiga-Demos-%VERSION%.zip' not found;[0m
    ECHO   [93m  consider installing the demo pack as well.[0m
	ECHO/
) ELSE (
	ECHO   [92m'RML-Amiga-Demos-%VERSION%.zip' found[0m
	SET INSTALL_DEMOS=1
)

ECHO/
ECHO ------------------------------------------------------------------------------

IF %CAN_INSTALL%==0 (
	ECHO   Some mandatory files required for the installation have not been found.
	ECHO   Please download the missing files, put them into this folder, then run
    ECHO   this installer again.
	ECHO/
	ECHO/
	PAUSE
	EXIT
)

SET DEST_PATH=
ECHO Please enter the name of the folder where you want RML-Amiga to be installed,
ECHO or just press ENTER to use the current folder.
ECHO/
ECHO Alternatively, drag ^& drop a folder onto this window from Windows Explorer,
ECHO then press ENTER.
ECHO/
SET /P DEST_PATH=Installation path: 

IF "%DEST_PATH%" == "" (
	SET DEST_PATH=.
)

CALL :normalisePath "%DEST_PATH%"
SET DEST_PATH_STR=%RETVAL%
SET OUT_PATH_ARG=-o"%DEST_PATH%"

ECHO/
ECHO ------------------------------------------------------------------------------
ECHO Ready to install RML Amiga %VERSION% into "%DEST_PATH_STR%"
ECHO The installation will take about 10-15 minutes. 
ECHO/

CHOICE /C YN /M "Press Y to proceed or N to cancel."

IF %ERRORLEVEL%==2 EXIT

SET FULL_INSTALL=1

ECHO/
ECHO [92mInstalling base package[0m
7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-Base-%VERSION%.zip || goto :error

ECHO [92mInstalling systems package[0m
7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-Systems-%VERSION%.zip || goto :error

IF %INSTALL_ROMS%==1 (
  ECHO [92mInstalling ROMs package[0m
  7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-ROMs-%VERSION%.zip || goto :error
)

ECHO [92mInstalling games package[0m
ECHO/
7za x -y -bso0 RML-Amiga-Games-%VERSION%.zip install-games-%VERSION%.bat || goto :error
CALL install-games-%VERSION%.bat "%DEST_PATH%" || goto :error
DEL install-games-%VERSION%.bat || goto :error

IF %INSTALL_DEMOS%==1 (
  ECHO [92mInstalling demos package[0m
  ECHO/
  7za x -y -bso0 RML-Amiga-Demos-%VERSION%.zip install-demos-%VERSION%.bat || goto :error
  CALL install-demos-%VERSION%.bat "%DEST_PATH%" || goto :error
  DEL install-demos-%VERSION%.bat || goto :error
)


ECHO/
ECHO ------------------------------------------------------------------------------
ECHO [92mInstallation completed. Enjoy RML Amiga! :)[0m
ECHO/
PAUSE
EXIT

:error
ECHO/
ECHO ------------------------------------------------------------------------------
ECHO [91m*** ERROR: Installation failed.[0m
ECHO/
PAUSE
EXIT

:normalisePath
  SET RETVAL=%~f1
  EXIT /B

