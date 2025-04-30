@ECHO OFF

SET VERSION=v1.0

SET RED=[91m
SET GREEN=[92m
SET YELLOW=[93m
SET BLUE=[94m
SET PURPLE=[95m
SET CYAN=[96m
SET RESET=[0m

CLS
ECHO/
ECHO ==============================================================================
ECHO                         RML Amiga %VERSION% full installer
ECHO ==============================================================================
ECHO/

SET CAN_INSTALL=1
SET INSTALL_ROMS=0
SET INSTALL_DEMOS=0

IF NOT EXIST 7za.exe (
	ECHO   %RED%*** ERROR: 7za.exe not found%RESET%
	SET CAN_INSTALL=0
) ELSE (
	ECHO   %GREEN%7za.exe found%RESET%
)

IF NOT EXIST RML-Amiga-Base-%VERSION%.zip (
	ECHO   %RED%*** ERROR: Mandatory 'RML-Amiga-Base-%VERSION%.zip' not found%RESET%
	SET CAN_INSTALL=0
) ELSE (
	ECHO   %GREEN%'RML-Amiga-Base-%VERSION%.zip' found%RESET%
)

IF NOT EXIST RML-Amiga-Systems-%VERSION%.zip (
	ECHO   %RED%*** ERROR: Mandatory 'RML-Amiga-Systems-%VERSION%.zip' not found%RESET%
	SET CAN_INSTALL=0
) ELSE (
	ECHO   %GREEN%'RML-Amiga-Systems-%VERSION%.zip' found%RESET%
)

IF NOT EXIST RML-Amiga-ROMs-%VERSION%.zip (
	ECHO/
	ECHO   %YELLOW%'RML-Amiga-ROMs-%VERSION%.zip' not found;
    ECHO     you will need to supply the ROM files yourself.%RESET%
	ECHO/
) ELSE (
	ECHO   %GREEN%'RML-Amiga-ROMs-%VERSION%.zip' found%RESET%
	SET INSTALL_ROMS=1
)

IF NOT EXIST RML-Amiga-Games-%VERSION%.zip (
	ECHO   %RED%*** ERROR: Mandatory 'RML-Amiga-Games-%VERSION%.zip' not found%RESET%
	SET CAN_INSTALL=0
) ELSE (
	ECHO   %GREEN%'RML-Amiga-Games-%VERSION%.zip' found%RESET%
)

IF NOT EXIST RML-Amiga-Demos-%VERSION%.zip (
	ECHO/
	ECHO   %YELLOW%'RML-Amiga-Demos-%VERSION%.zip' not found;
    ECHO     consider installing the demo pack as well.%RESET%
	ECHO/
) ELSE (
	ECHO   %GREEN%'RML-Amiga-Demos-%VERSION%.zip' found%RESET%
	SET INSTALL_DEMOS=1
)

ECHO/
ECHO ------------------------------------------------------------------------------

IF %CAN_INSTALL%==0 (
	ECHO   %RED%*** ERROR: Mandatory files missing%RESET%
	ECHO   Some mandatory files required for the installation have not been found.
	ECHO   Please download the missing files, put them into this folder, then run
    ECHO   this installer again.
	ECHO/
	ECHO/
	PAUSE
	EXIT
)

SET DEST_PATH=
ECHO Please enter the name of the folder where you want RML Amiga to be installed,
ECHO or just press Enter% to use the current folder.
ECHO/
ECHO Alternatively, drag ^& drop a folder onto this window from Windows Explorer
ECHO to set the folder name, then press Enter.
ECHO/
SET /P DEST_PATH=Installation folder: 

IF "%DEST_PATH%" == "" (
	SET DEST_PATH=.
)

CALL :normalisePath "%DEST_PATH%"
SET DEST_PATH_STR=%RETVAL%
SET OUT_PATH_ARG=-o"%DEST_PATH%"

ECHO/
ECHO ------------------------------------------------------------------------------
ECHO Ready to install RML Amiga %VERSION% into %CYAN%'%DEST_PATH_STR%'%RESET%
ECHO The installation will take about 15 minutes.
ECHO/

CHOICE /C YN /M "Press Y to proceed or N to cancel."

IF %ERRORLEVEL%==2 EXIT

SET FULL_INSTALL=1

ECHO/
ECHO %GREEN%Installing base package...%RESET%
7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-Base-%VERSION%.zip || goto :error

ECHO %GREEN%Installing systems package...%RESET%
7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-Systems-%VERSION%.zip || goto :error

IF %INSTALL_ROMS%==1 (
  ECHO %GREEN%Installing ROMs package...%RESET%
  7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-ROMs-%VERSION%.zip || goto :error
)

ECHO %GREEN%Installing games package...%RESET%
ECHO/
7za x -y -bso0 RML-Amiga-Games-%VERSION%.zip install-games-%VERSION%.bat || goto :error
CALL install-games-%VERSION%.bat "%DEST_PATH%" || goto :error
DEL install-games-%VERSION%.bat || goto :error

IF %INSTALL_DEMOS%==1 (
  ECHO %GREEN%Installing demos package...%RESET%
  ECHO/
  7za x -y -bso0 RML-Amiga-Demos-%VERSION%.zip install-demos-%VERSION%.bat || goto :error
  CALL install-demos-%VERSION%.bat "%DEST_PATH%" || goto :error
  DEL install-demos-%VERSION%.bat || goto :error
)


ECHO/
ECHO ------------------------------------------------------------------------------
ECHO %GREEN%Installation completed. Enjoy RML Amiga! :)%RESET%
ECHO/
PAUSE
EXIT

:error
ECHO/
ECHO ------------------------------------------------------------------------------
ECHO %RED%*** ERROR: Installation failed.%RESET%
ECHO/
PAUSE
EXIT

:normalisePath
  SET RETVAL=%~f1
  EXIT /B
