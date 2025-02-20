@echo off
setlocal enabledelayedexpansion

:: ================================================================
:: ROBLOX UNIVERSAL PERFORMANCE OPTIMIZER
:: Targets: All system configurations from legacy to high-end
:: Version: 2.1.0 (2025-02-20)
:: ================================================================

title Roblox Performance Optimizer

:: Configuration Variables
set "LOG_FILE=%TEMP%\RobloxOptimizer.log"
set "CONFIG_ROOT=%LOCALAPPDATA%\Roblox\ClientSettings"
set "VERSION_PATTERN=%LOCALAPPDATA%\Roblox\Versions\version-*"

:: Initialize logging
echo [%date% %time%] Roblox Performance Optimizer started > "%LOG_FILE%"

:: ----------------------------------------------------------------
:: SECTION 1: Environment Preparation
:: ----------------------------------------------------------------
echo ┌────────────────────────────────────────────┐
echo │      ROBLOX UNIVERSAL PERFORMANCE OPTIMIZER      │
echo └────────────────────────────────────────────┘
echo.
echo [1/5] Preparing environment...

:: Create primary configuration directory
if not exist "%CONFIG_ROOT%" (
    mkdir "%CONFIG_ROOT%" 2>nul
    echo [INFO] Created primary configuration directory >> "%LOG_FILE%"
) else (
    echo [INFO] Primary configuration directory exists >> "%LOG_FILE%"
)

:: ----------------------------------------------------------------
:: SECTION 2: Roblox Installation Detection
:: ----------------------------------------------------------------
echo [2/5] Detecting Roblox installation...

:: Find latest Roblox version with error handling
set "LATEST_VERSION="
for /f "delims=" %%i in ('dir /b /ad /od "%VERSION_PATTERN%" 2^>nul') do set "LATEST_VERSION=%%i"

if not defined LATEST_VERSION (
    echo [ERROR] Roblox installation not detected. >> "%LOG_FILE%"
    echo [!] Error: Roblox installation not found.
    echo     Please install Roblox before running this optimizer.
    echo.
    goto error_exit
)

set "VERSION_DIR=%LOCALAPPDATA%\Roblox\Versions\!LATEST_VERSION!"
set "CLIENT_DIR=!VERSION_DIR!\ClientSettings"

:: Create version-specific configuration directory
if not exist "!CLIENT_DIR!" (
    mkdir "!CLIENT_DIR!" 2>nul
    echo [INFO] Created version-specific configuration directory >> "%LOG_FILE%"
)

echo     Detected Roblox version: !LATEST_VERSION!
echo [INFO] Detected version: !LATEST_VERSION! >> "%LOG_FILE%"

:: ----------------------------------------------------------------
:: SECTION 3: System Capability Analysis
:: ----------------------------------------------------------------
echo [3/5] Analyzing system capabilities...

:: Initialize detection variables
set "SYS_CATEGORY=unknown"
set "GPU_VRAM_MB=0"
set "GPU_NAME=Unknown"
set "SYS_AGE_YEARS=0"

:: GPU Detection
set "GPU_FOUND=false"
for /f "tokens=2 delims==" %%g in ('wmic PATH Win32_VideoController get AdapterRAM /value 2^>nul') do (
    if not "%%g"=="" (
        set /a "GPU_VRAM_MB=%%g / 1048576"
        set "GPU_FOUND=true"
    )
)
for /f "tokens=2 delims==" %%n in ('wmic PATH Win32_VideoController get Name /value 2^>nul') do (
    if not "%%n"=="" set "GPU_NAME=%%n"
)
echo [INFO] GPU: !GPU_NAME! with !GPU_VRAM_MB! MB VRAM >> "%LOG_FILE%"

:: System Age Calculation
for /f "tokens=2 delims==" %%y in ('wmic os get InstallDate /value 2^>nul') do (
    set "INSTALL_DATE=%%y"
)

:: Extract the year from the InstallDate
set "INSTALL_YEAR=%INSTALL_DATE:~0,4%"

:: Get the current year robustly
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format yyyy"') do set "CURRENT_YEAR=%%i"

:: Calculate system age
set /a "SYS_AGE_YEARS=%CURRENT_YEAR% - %INSTALL_YEAR%"

echo [INFO] System Age: %SYS_AGE_YEARS% years >> "%LOG_FILE%"

:: ----------------------------------------------------------------
:: SECTION 4: System Category Classification
:: ----------------------------------------------------------------

:: Define system categories based on GPU VRAM and system age
if !GPU_VRAM_MB! GEQ 4096 (
    set "SYS_CATEGORY=new"
) else if !SYS_AGE_YEARS! LEQ 2 (
    set "SYS_CATEGORY=new"
) else (
    set "SYS_CATEGORY=old"
)

echo     System classification: !SYS_CATEGORY!
echo [INFO] System classified as: !SYS_CATEGORY! >> "%LOG_FILE%"

:: ----------------------------------------------------------------
:: SECTION 5: Configuration Generation
:: ----------------------------------------------------------------
echo [4/5] Generating optimized configuration...

:: Common settings for all systems
set "COMMON_SETTINGS="
set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagFixGraphicsQuality": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagCommitToGraphicsQualityFix": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagGameBasicSettingsFramerateCap4": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryEphemeralCounter": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryEphemeralStat": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryEventIngest": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryPoint": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryV2Counter": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryV2Event": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagDebugDisableTelemetryV2Stat": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"DFFlagTextureQualityOverrideEnabled": true,^

set COMMON_SETTINGS=!COMMON_SETTINGS!"FFlagHandleAltEnterFullscreenManually": false,

:: System-specific configurations
if "!SYS_CATEGORY!"=="new" (
    set "DFIntTaskSchedulerTargetFps=144"
    set "DFIntConnectionMTUSize=1472"
    set "DFIntTextureQualityOverride=5"
    set "FIntDebugForceMSAASamples=8"
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": !DFIntTaskSchedulerTargetFps!,
    echo   "DFIntConnectionMTUSize": !DFIntConnectionMTUSize!,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": true,
    echo   "DFIntTextureQualityOverride": !DFIntTextureQualityOverride!,
    echo   "FIntDebugForceMSAASamples": !FIntDebugForceMSAASamples!,
    echo   "FFlagDisablePostFx": false,
    echo   "FFlagCloudsReflectOnWater": true,
    echo   "FIntRenderShadowIntensity": 2,
    echo   "FFlagFastGPULightCulling3": true,
    echo   "FFlagMovePrerender": true,
    echo   "FFlagPreloadTextureData": true,
    echo   "FFlagPreloadAllFonts": true,
    echo   "DFIntHttpCurlConnectionTimeout": 10000,
    echo   "DFIntMaxHttpRetryCount": 1,
    echo   "DFIntHttpSocketPoolSize": 128,
    echo   "DFIntDebugFRMQualityLevelOverride": 7,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 768,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 1024,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 1280,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 1536
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
) else (
    set "DFIntTaskSchedulerTargetFps=60"
    set "DFIntConnectionMTUSize=1400"
    set "DFIntTextureQualityOverride=1"
    set "FIntDebugForceMSAASamples=2"
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": !DFIntTaskSchedulerTargetFps!,
    echo   "DFIntConnectionMTUSize": !DFIntConnectionMTUSize!,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": false,
    echo   "DFIntTextureQualityOverride": !DFIntTextureQualityOverride!,
    echo   "FIntDebugForceMSAASamples": !FIntDebugForceMSAASamples!,
    echo   "FFlagDisablePostFx": true,
    echo   "FFlagCloudsReflectOnWater": false,
    echo   "FIntRenderShadowIntensity": 0,
    echo   "FFlagFastGPULightCulling3": false,
    echo   "FFlagMovePrerender": false,
    echo   "FFlagPreloadTextureData": true,
    echo   "FFlagPreloadAllFonts": true,
    echo   "DFIntHttpCurlConnectionTimeout": 30000,
    echo   "DFIntMaxHttpRetryCount": 2,
    echo   "DFIntHttpSocketPoolSize": 32,
    echo   "DFIntDebugFRMQualityLevelOverride": 2,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 128,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 256,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 384,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 512
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
)

:: Display the settings
echo     Optimized Settings:
echo     -------------------------------------
echo     - Target FPS: !DFIntTaskSchedulerTargetFps!
echo     - Network Packet Size: !DFIntConnectionMTUSize! bytes
echo     - Texture Quality Level: !DFIntTextureQualityOverride!
echo     - Anti-aliasing Level: !FIntDebugForceMSAASamples!
echo     -------------------------------------

:: Create configuration report
(
echo # ROBLOX OPTIMIZATION REPORT
echo Generated: %date% %time%
echo.
echo ## SYSTEM INFORMATION
echo - GPU: !GPU_NAME! with !GPU_VRAM_MB! MB VRAM
echo - System Age: !SYS_AGE_YEARS! years
echo.
echo ## OPTIMIZATION CATEGORY
echo Your system has been classified as: !SYS_CATEGORY!
echo.
echo ## KEY OPTIMIZATIONS APPLIED
echo - Target FPS: !DFIntTaskSchedulerTargetFps!
echo - Network Packet Size: !DFIntConnectionMTUSize! bytes
echo - Texture Quality Level: !DFIntTextureQualityOverride!
echo - Anti-aliasing Level: !FIntDebugForceMSAASamples!
echo.
echo ## CONFIGURATION LOCATION
echo The optimization settings have been applied to:
echo !CLIENT_DIR!\ClientAppSettings.json
echo.
echo ## TROUBLESHOOTING
echo If you experience any issues after applying these optimizations:
echo 1. Delete the ClientAppSettings.json file
echo 2. Launch Roblox normally to reset to default settings
echo 3. Try a different optimization category by editing this script
) > "!CLIENT_DIR!\OptimizationReport.txt"

:: ----------------------------------------------------------------
:: SECTION 6: Finalization
:: ----------------------------------------------------------------
echo [5/5] Finalizing optimization...
echo     Configuration successfully written to:
echo     !CLIENT_DIR!\ClientAppSettings.json
echo.

:: Report creation
echo [INFO] Configuration completed successfully >> "%LOG_FILE%"
echo [INFO] Optimization report generated >> "%LOG_FILE%"

echo [i] An optimization report has been saved to:
echo     !CLIENT_DIR!\OptimizationReport.txt
echo.

:: Launch options
echo Optimization complete! What would you like to do next?
echo 1. Open the configuration folder
echo 2. Start Roblox now
echo 3. View detailed optimization report
echo 4. Exit
choice /c 1234 /n /m "Choose an option (1-4): "

if errorlevel 4 goto exit_normal
if errorlevel 3 goto view_report
if errorlevel 2 goto start_roblox
if errorlevel 1 goto open_folder

:open_folder
start "" "!CLIENT_DIR!"
goto exit_normal

:start_roblox
start robloxplayer://
goto exit_normal

:view_report
type "!CLIENT_DIR!\OptimizationReport.txt"
echo.
echo Press any key to continue...
pause >nul
goto exit_normal

:exit_normal
echo.
echo Thank you for using the Roblox Performance Optimizer.
echo [INFO] Script completed successfully >> "%LOG_FILE%"
exit /b 0

:error_exit
echo [ERROR] Script terminated with errors >> "%LOG_FILE%"
echo.
echo Press any key to exit...
pause >nul
exit /b 1
