@echo off
setlocal enabledelayedexpansion

:: ================================================================
:: ROBLOX UNIVERSAL PERFORMANCE OPTIMIZER
:: Targets: All system configurations from legacy to high-end
:: Version: 2.1.0 (2025-02-19)
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
set "RAM_GB=0"
set "GPU_VRAM_MB=0"
set "CPU_CORES=0"
set "CPU_FREQ_MHZ=0"
set "OS_VERSION=0"
set "SUPPORTS_DX11=false"
set "IS_64BIT=false"
set "HAS_SSD=false"

:: RAM Detection
for /f "tokens=2 delims==" %%a in ('wmic ComputerSystem get TotalPhysicalMemory /value 2^>nul') do (
    set /a "RAM_GB=%%a / 1073741824"
    echo [INFO] Detected !RAM_GB! GB RAM >> "%LOG_FILE%"
)

:: CPU Detection
for /f "tokens=2 delims==" %%c in ('wmic cpu get NumberOfCores /value 2^>nul') do (
    set "CPU_CORES=%%c"
)
for /f "tokens=2 delims==" %%d in ('wmic cpu get MaxClockSpeed /value 2^>nul') do (
    set "CPU_FREQ_MHZ=%%d"
)
echo [INFO] CPU: !CPU_CORES! cores at !CPU_FREQ_MHZ! MHz >> "%LOG_FILE%"

:: GPU Detection
set "GPU_NAME=Unknown"
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

:: OS Detection
for /f "tokens=2 delims==" %%o in ('wmic os get Version /value 2^>nul') do set "OS_VERSION=%%o"
for /f "tokens=2 delims==" %%b in ('wmic os get OSArchitecture /value 2^>nul') do (
    echo %%b | findstr /i "64" > nul && set "IS_64BIT=true"
)
echo [INFO] OS: Windows !OS_VERSION! (!IS_64BIT!) >> "%LOG_FILE%"

:: DirectX Detection (Basic)
reg query "HKLM\SOFTWARE\Microsoft\DirectX" /v Version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%d in ('reg query "HKLM\SOFTWARE\Microsoft\DirectX" /v Version 2^>nul') do (
        echo %%d | findstr "11" >nul 2>&1 && set "SUPPORTS_DX11=true"
    )
)

:: Disk Type Detection (Basic SSD detection)
for /f "tokens=2 delims==" %%s in ('wmic diskdrive get Model /value 2^>nul') do (
    echo %%s | findstr /i "SSD NVMe" >nul 2>&1 && set "HAS_SSD=true"
)

:: ----------------------------------------------------------------
:: SECTION 4: System Category Classification
:: ----------------------------------------------------------------

:: Define system categories
if !RAM_GB! LEQ 2 (
    if !CPU_CORES! LEQ 2 (
        if !GPU_VRAM_MB! LEQ 256 (
            set "SYS_CATEGORY=ultra_legacy"
        ) else (
            set "SYS_CATEGORY=legacy"
        )
    ) else (
        set "SYS_CATEGORY=legacy"
    )
) else if !RAM_GB! LEQ 4 (
    if !GPU_VRAM_MB! LEQ 512 (
        set "SYS_CATEGORY=low_end"
    ) else (
        set "SYS_CATEGORY=mid_low"
    )
) else if !RAM_GB! LEQ 8 (
    if !GPU_VRAM_MB! LEQ 1024 (
        set "SYS_CATEGORY=mid_low"
    ) else (
        set "SYS_CATEGORY=mid_range"
    )
) else if !RAM_GB! LEQ 16 (
    if !GPU_VRAM_MB! LEQ 2048 (
        set "SYS_CATEGORY=mid_range"
    ) else (
        set "SYS_CATEGORY=high_mid"
    )
) else (
    if !GPU_VRAM_MB! LEQ 4096 (
        set "SYS_CATEGORY=high_mid"
    ) else (
        set "SYS_CATEGORY=high_end"
    )
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
if "!SYS_CATEGORY!"=="ultra_legacy" (
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 24,
    echo   "DFIntConnectionMTUSize": 1200,
    echo   "FFlagDebugGraphicsDisableDirect3D11": true,
    echo   "FFlagDebugGraphicsPreferD3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11FL10": false,
    echo   "DFIntTextureQualityOverride": 0,
    echo   "FIntDebugForceMSAASamples": 0,
    echo   "FFlagDisablePostFx": true,
    echo   "FFlagCloudsReflectOnWater": false,
    echo   "FIntRenderShadowIntensity": 0,
    echo   "FFlagFastGPULightCulling3": false,
    echo   "FFlagMovePrerender": false,
    echo   "FFlagPreloadTextureData": false,
    echo   "FFlagPreloadAllFonts": false,
    echo   "DFIntHttpCurlConnectionTimeout": 90000,
    echo   "DFIntMaxHttpRetryCount": 3,
    echo   "DFIntHttpSocketPoolSize": 8,
    echo   "FIntRobloxGuiBlurIntensity": 0,
    echo   "FFlagEnableBetaFacialAnimation2": false,
    echo   "DFFlagLoadCharacterLayeredClothingProperty2": false,
    echo   "DFFlagEnableDynamicHeadByDefault": false,
    echo   "DFIntDebugFRMQualityLevelOverride": 0,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 32,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 64,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 128,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 256,
    echo   "DFFlagDebugPauseVoxelizer": true,
    echo   "FIntTerrainArraySliceSize": 0,
    echo   "FIntFRMMinGrassDistance": 0,
    echo   "FIntFRMMaxGrassDistance": 0
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
) else if "!SYS_CATEGORY!"=="legacy" (
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 30,
    echo   "DFIntConnectionMTUSize": 1400,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11FL10": true,
    echo   "FFlagGraphicsEnableD3D10Compute": true,
    echo   "DFIntTextureQualityOverride": 0,
    echo   "FIntDebugForceMSAASamples": 0,
    echo   "FFlagDisablePostFx": true,
    echo   "FFlagCloudsReflectOnWater": false,
    echo   "FIntRenderShadowIntensity": 0,
    echo   "FFlagFastGPULightCulling3": false,
    echo   "FFlagMovePrerender": false,
    echo   "FFlagPreloadTextureData": false,
    echo   "DFIntHttpCurlConnectionTimeout": 60000,
    echo   "DFIntMaxHttpRetryCount": 2,
    echo   "DFIntHttpSocketPoolSize": 16,
    echo   "FIntRobloxGuiBlurIntensity": 0,
    echo   "FFlagEnableBetaFacialAnimation2": false,
    echo   "DFFlagLoadCharacterLayeredClothingProperty2": false,
    echo   "DFIntDebugFRMQualityLevelOverride": 1,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 64,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 128,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 256,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 512
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
) else if "!SYS_CATEGORY!"=="low_end" (
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 60,
    echo   "DFIntConnectionMTUSize": 1450,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": !SUPPORTS_DX11!,
    echo   "FFlagDebugGraphicsPreferD3D11FL10": true,
    echo   "DFIntTextureQualityOverride": 1,
    echo   "FIntDebugForceMSAASamples": 0,
    echo   "FFlagDisablePostFx": false,
    echo   "FFlagCloudsReflectOnWater": false,
    echo   "FIntRenderShadowIntensity": 0,
    echo   "FFlagFastGPULightCulling3": true,
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
) else if "!SYS_CATEGORY!"=="mid_low" (
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 60,
    echo   "DFIntConnectionMTUSize": 1472,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": true,
    echo   "DFIntTextureQualityOverride": 2,
    echo   "FIntDebugForceMSAASamples": 2,
    echo   "FFlagDisablePostFx": false,
    echo   "FFlagCloudsReflectOnWater": true,
    echo   "FIntRenderShadowIntensity": 0,
    echo   "FFlagFastGPULightCulling3": true,
    echo   "FFlagMovePrerender": true,
    echo   "FFlagPreloadTextureData": true,
    echo   "FFlagPreloadAllFonts": true,
    echo   "DFIntHttpCurlConnectionTimeout": 15000,
    echo   "DFIntMaxHttpRetryCount": 1,
    echo   "DFIntHttpSocketPoolSize": 48,
    echo   "DFIntDebugFRMQualityLevelOverride": 3,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 256,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 384,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 512,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 768
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
) else if "!SYS_CATEGORY!"=="mid_range" (
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 144,
    echo   "DFIntConnectionMTUSize": 1472,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": true,
    echo   "DFIntTextureQualityOverride": 3,
    echo   "FIntDebugForceMSAASamples": 4,
    echo   "FFlagDisablePostFx": false,
    echo   "FFlagCloudsReflectOnWater": true,
    echo   "FIntRenderShadowIntensity": 1,
    echo   "FFlagFastGPULightCulling3": true,
    echo   "FFlagMovePrerender": true,
    echo   "FFlagPreloadTextureData": true,
    echo   "FFlagPreloadAllFonts": true,
    echo   "DFIntHttpCurlConnectionTimeout": 15000,
    echo   "DFIntMaxHttpRetryCount": 1,
    echo   "DFIntHttpSocketPoolSize": 64,
    echo   "DFIntDebugFRMQualityLevelOverride": 5,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 512,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 640,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 768,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 896
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
) else if "!SYS_CATEGORY!"=="high_mid" (
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 240,
    echo   "DFIntConnectionMTUSize": 1472,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": true,
    echo   "DFIntTextureQualityOverride": 5,
    echo   "FIntDebugForceMSAASamples": 4,
    echo   "FFlagDisablePostFx": false,
    echo   "FFlagCloudsReflectOnWater": true,
    echo   "FIntRenderShadowIntensity": 1,
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
    (
    echo {
    echo   %COMMON_SETTINGS%
    echo   "DFIntTaskSchedulerTargetFps": 360,
    echo   "DFIntConnectionMTUSize": 1472,
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": true,
    echo   "DFIntTextureQualityOverride": 7,
    echo   "FIntDebugForceMSAASamples": 8,
    echo   "FFlagDisablePostFx": false,
    echo   "FFlagCloudsReflectOnWater": true,
    echo   "FIntRenderShadowIntensity": 2,
    echo   "FFlagFastGPULightCulling3": true,
    echo   "FFlagMovePrerender": true,
    echo   "FFlagPreloadTextureData": true,
    echo   "FFlagPreloadAllFonts": true,
    echo   "DFIntHttpCurlConnectionTimeout": 10000,
    echo   "DFIntMaxHttpRetryCount": 1,
    echo   "DFIntHttpSocketPoolSize": 192,
    echo   "DFIntDebugFRMQualityLevelOverride": 10,
    echo   "DFIntCSGLevelOfDetailSwitchingDistance": 1024,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 1536,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 2048,
    echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 2560
    echo }
    ) > "!CLIENT_DIR!\ClientAppSettings.json"
)

:: Create configuration report
(
echo # ROBLOX OPTIMIZATION REPORT
echo Generated: %date% %time%
echo.
echo ## SYSTEM INFORMATION
echo - RAM: !RAM_GB! GB
echo - CPU: !CPU_CORES! cores at !CPU_FREQ_MHZ! MHz
echo - GPU: !GPU_NAME! with !GPU_VRAM_MB! MB VRAM
echo - OS: Windows !OS_VERSION! (!IS_64BIT!)
echo - Storage: !HAS_SSD!
echo - DirectX11 Support: !SUPPORTS_DX11!
echo.
echo ## OPTIMIZATION CATEGORY
echo Your system has been classified as: !SYS_CATEGORY!
echo.
echo ## KEY OPTIMIZATIONS APPLIED
echo - Target FPS: !DFIntTaskSchedulerTargetFps!
echo - Network Packet Size: !DFIntConnectionMTUSize! bytes
echo - Graphics API: !FFlagDebugGraphicsPreferD3D11! (DirectX 11)
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
