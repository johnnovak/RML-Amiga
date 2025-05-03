@ECHO OFF

SET VERSION=v1.0

SET RED=[91m
SET GREEN=[92m
SET YELLOW=[93m
SET BLUE=[94m
SET PURPLE=[95m
SET CYAN=[96m
SET RESET=[0m

:start

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
ECHO or just press ENTER to use the current folder.
ECHO/
ECHO Alternatively, drag ^& drop a folder onto this window from Windows Explorer
ECHO to set the folder name, then press ENTER.
ECHO/
SET /P DEST_PATH=Installation folder: 

ECHO/
ECHO/
ECHO Please specify the vertical resolution of your monitor. If you have a multi-
ECHO monitor setup, enter the resolution of the monitor you are going to play Amiga
ECHO games on.
ECHO/
ECHO   [1] 1080p or less
ECHO   [2] 1440p
ECHO   [3] 2180p (4K^)
ECHO   [4] 2880p (5K^) or higher
ECHO/

CHOICE /C 1234 /M "Vertical monitor resolution"
SET SCREEN_RES=%ERRORLEVEL%

IF %SCREEN_RES%==1 GOTO setScreenRes1080p
IF %SCREEN_RES%==2 GOTO setScreenRes1440p
IF %SCREEN_RES%==3 GOTO setScreenRes2180p
IF %SCREEN_RES%==4 GOTO setScreenRes2880p

:setScreenRes1080p
SET SCREEN_RES_NAME=1080p
GOTO :setScreenResEnd

:setScreenRes1440p
SET SCREEN_RES_NAME=1440p
GOTO :setScreenResEnd

:setScreenRes2180p
SET SCREEN_RES_NAME=2180p (4K)
GOTO :setScreenResEnd

:setScreenRes2880p
SET SCREEN_RES_NAME=2880p (5K)
GOTO :setScreenResEnd

:setScreenResEnd


IF "%DEST_PATH%" == "" (
	SET DEST_PATH=.
)

CALL :normalisePath "%DEST_PATH%"
SET DEST_PATH_STR=%RETVAL%
SET OUT_PATH_ARG=-o"%DEST_PATH%"

ECHO/
ECHO ------------------------------------------------------------------------------
ECHO Ready to install RML Amiga %VERSION%!
ECHO The installation will take about 15-20 minutes.
ECHO/
ECHO   Destination folder: %CYAN%%DEST_PATH_STR%%RESET%
ECHO   Display resolution: %CYAN%%SCREEN_RES_NAME%%RESET%
ECHO/
ECHO Are you happy with these settings?
ECHO/

CHOICE /C YNC /M "Press Y to proceed, N to choose different settings, or C to cancel."

IF %ERRORLEVEL%==2 GOTO :start
IF %ERRORLEVEL%==3 EXIT

SET FULL_INSTALL=1

ECHO/
ECHO %GREEN%Verifying base package...%RESET%
SET SHA256_BASE_v1_0=TODO

7za h -bsp2 -ba -slfh -scrcSHA256 RML-Amiga-Base-%VERSION%.zip > hash
SET /P HASH=<hash
DEL hash
IF NOT %HASH% == %SHA256_BASE_v1_0% (
  ECHO/
  ECHO %RED%*** ERROR: Package 'RML-Amiga-Base-%VERSION%.zip' is invalid.%RESET%
  ECHO %RED%           Please re-download it and run the installer again.%RESET%
  ECHO/
  PAUSE
  EXIT
)

ECHO %GREEN%Verifying systems package...%RESET%
SET SHA256_SYSTEMS_v1_0=d333c5c66e8ec2052ff6f011b65fde070cc363cbf2bb6bdf653fab1ba543b1a0

7za h -bsp2 -ba -slfh -scrcSHA256 RML-Amiga-Systems-%VERSION%.zip > hash
SET /P HASH=<hash
DEL hash
IF NOT %HASH% == %SHA256_SYSTEMS_v1_0% (
  ECHO/
  ECHO %RED%*** ERROR: Package 'RML-Amiga-Systems-%VERSION%.zip' is invalid.%RESET%
  ECHO %RED%           Please re-download it and run the installer again.%RESET%
  ECHO/
  PAUSE
  EXIT
)

IF NOT %INSTALL_ROMS%==1 GOTO :skipVerifyROMs

ECHO %GREEN%Verifying ROMs package...%RESET%
SET SHA256_ROMS_v1_0=2668b102aa0c61dad711b6e0e3e0a575550df962b2427010f4564140e81f6105

7za h -bsp2 -ba -slfh -scrcSHA256 RML-Amiga-ROMs-%VERSION%.zip > hash
SET /P HASH=<hash
DEL hash
IF NOT %HASH% == %SHA256_ROMS_v1_0% (
  ECHO/
  ECHO %RED%*** ERROR: Package 'RML-Amiga-ROMs-%VERSION%.zip' is invalid.%RESET%
  ECHO %RED%           Please re-download it and run the installer again.%RESET%
  ECHO/
  PAUSE
  EXIT
)

:skipVerifyROMs

ECHO %GREEN%Verifying games package... (this will take a few minutes^)%RESET%
SET SHA256_GAMES_V1_0=f07f7b57af0ad076805eee4a7bf4f85b522ffddc93930b6b9752e1cc6b40f027

7za h -bsp2 -ba -slfh -scrcSHA256 RML-Amiga-Games-%VERSION%.zip > hash
SET /P HASH=<hash
DEL hash
IF NOT %HASH% == %SHA256_GAMES_V1_0% (
  ECHO/
  ECHO %RED%*** ERROR: Package 'RML-Amiga-Games-%VERSION%.zip' is invalid.%RESET%
  ECHO %RED%           Please re-download it and run the installer again.%RESET%
  ECHO/
  PAUSE
  EXIT
)

IF NOT %INSTALL_DEMOS%==1 GOTO :skipVerifyDemos

ECHO %GREEN%Verifying demos package...%RESET%
ECHO/
SET SHA256_DEMOS_v1_0=bffac9eb1cd492585fb6934dffe179e89bec79539bdab667cb9229a648c263a4

7za h -bsp2 -ba -slfh -scrcSHA256 RML-Amiga-Demos-%VERSION%.zip > hash
SET /P HASH=<hash
DEL hash
IF NOT %HASH% == %SHA256_DEMOS_v1_0% (
  ECHO/
  ECHO %RED%*** ERROR: Package 'RML-Amiga-Demos-%VERSION%.zip' is invalid.%RESET%
  ECHO %RED%           Please re-download it and run the installer again.%RESET%
  ECHO/
  PAUSE
  EXIT
)

:skipVerifyDemos

ECHO %GREEN%Installing base package...%RESET%
7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-Base-%VERSION%.zip || GOTO :error

ECHO %GREEN%Installing systems package...%RESET%
7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-Systems-%VERSION%.zip || GOTO :error

IF %INSTALL_ROMS%==1 (
  ECHO %GREEN%Installing ROMs package...%RESET%
  7za x -y -bso0 %OUT_PATH_ARG% RML-Amiga-ROMs-%VERSION%.zip || GOTO :error
)

ECHO %GREEN%Installing games package...%RESET%
ECHO/
7za x -y -bso0 RML-Amiga-Games-%VERSION%.zip install-games-%VERSION%.bat || GOTO :error
CALL install-games-%VERSION%.bat "%DEST_PATH%" || GOTO :error
DEL install-games-%VERSION%.bat || GOTO :error

IF %INSTALL_DEMOS%==1 (
  ECHO %GREEN%Installing demos package...%RESET%
  ECHO/
  7za x -y -bso0 RML-Amiga-Demos-%VERSION%.zip install-demos-%VERSION%.bat || GOTO :error
  CALL install-demos-%VERSION%.bat "%DEST_PATH%" || GOTO :error
  DEL install-demos-%VERSION%.bat || GOTO :error
)


IF %SCREEN_RES%==2 (
	Tools\ConfTool set gfx_filter_vert_zoom_multf  1.333333
	Tools\ConfTool set gfx_filter_horiz_zoom_multf 1.333333
	
) ELSE IF %SCREEN_RES%==3 (
	Tools\ConfTool set gfx_filter_vert_zoom_multf  2.000000
	Tools\ConfTool set gfx_filter_horiz_zoom_multf 2.000000
	DEL WinUAE\RGB-CRT.ini
	COPY WinUAE\RGB-CRT-4k.ini WinUAE\RGB-CRT.ini >NUL

) ELSE IF %SCREEN_RES%==4 (
	Tools\ConfTool set gfx_filter_vert_zoom_multf  2.666666
	Tools\ConfTool set gfx_filter_horiz_zoom_multf 2.666666
	DEL WinUAE\RGB-CRT.ini
	COPY WinUAE\RGB-CRT-4k.ini WinUAE\RGB-CRT.ini >NUL
)

ECHO ------------------------------------------------------------------------------
ECHO %GREEN%Installation completed. Enjoy RML Amiga! :)%RESET%
ECHO/
ECHO %YELLOW%==============================================================================
ECHO Please proceed by reading the %CYAN%Getting Started%YELLOW% section of the user manual.
ECHO Press any key now and the local copy of the documentation will open in your
ECHO default browser.
ECHO/
ECHO You can also read the documentation online at the RML Amiga website:
ECHO %CYAN%https://rml-amiga.johnnovak.net/%YELLOW%
ECHO ==============================================================================%RESET%
ECHO/
PAUSE

START "" Documentation\manual\getting-started.html

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
