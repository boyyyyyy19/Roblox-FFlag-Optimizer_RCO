@echo off
setlocal enabledelayedexpansion

:: Script Configuration
set "CONFIG_DIR=%LOCALAPPDATA%\Roblox\ClientSettings"
set "VERSIONS_DIR=%LOCALAPPDATA%\Roblox\Versions"

:: ==========================================
:: Function: Create Required Directories
:: ==========================================
:createDirectories
echo Creating required directories...
mkdir "%CONFIG_DIR%" 2>nul
call :getLatestVersion
mkdir "%VERSIONS_DIR%\!latest!\ClientSettings" 2>nul
goto :EOF

:: ==========================================
:: Function: Get Latest Roblox Version
:: ==========================================
:getLatestVersion
for /f "delims=" %%i in ('dir /b /ad /od "%VERSIONS_DIR%\version-*"') do set "latest=%%i"
goto :EOF

:: ==========================================
:: Function: Detect System Specifications
:: ==========================================
:detectSystemSpecs
echo Detecting system specifications...
set "isNewerPC=false"
set "isHighEndGPU=false"

:: RAM Check (8GB threshold)
for /f "tokens=2 delims==" %%A in ('wmic ComputerSystem get TotalPhysicalMemory /value') do (
    set "ramBytes=%%A"
    if !ramBytes! GEQ 8589934592 set "isNewerPC=true"
)

:: GPU Check (4GB threshold)
for /f "tokens=2 delims==" %%B in ('wmic PATH Win32_VideoController get AdapterRAM /value') do (
    set "gpuBytes=%%B"
    if !gpuBytes! GEQ 4294967296 set "isHighEndGPU=true"
)
goto :EOF

:: ==========================================
:: Function: Generate Settings JSON
:: ==========================================
:generateSettings
echo Generating optimized settings...
(
echo {
:: Performance Settings
echo   "DFIntTaskSchedulerTargetFps": 360,
echo   "FFlagGameBasicSettingsFramerateCap4": true,
echo   "DFFlagDebugPerfMode": true,

:: Network Optimization
echo   "DFIntConnectionMTUSize": 900,
echo   "FIntRakNetResendBufferArrayLength": 128,
echo   "FFlagOptimizeNetwork": true,
echo   "FFlagOptimizeNetworkRouting": true,
echo   "FFlagOptimizeNetworkTransport": true,
echo   "FFlagOptimizeServerTickRate": true,
echo   "DFIntServerPhysicsUpdateRate": 60,
echo   "DFIntServerTickRate": 60,
echo   "DFIntRakNetResendRttMultiple": 1,
echo   "DFIntRaknetBandwidthPingSendEveryXSeconds": 1,
echo   "DFIntOptimizePingThreshold": 50,
echo   "DFIntPlayerNetworkUpdateQueueSize": 20,
echo   "DFIntPlayerNetworkUpdateRate": 60,
echo   "DFIntNetworkPrediction": 120,
echo   "DFIntNetworkLatencyTolerance": 1,
echo   "DFIntMinimalNetworkPrediction": 0.1,

:: Graphics Settings - Hardware Dependent
if "%isNewerPC%"=="true" (
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": true,
    echo   "DFIntTextureQualityOverride": 3,
) else (
    echo   "FFlagDebugGraphicsDisableDirect3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11": false,
    echo   "FFlagDebugGraphicsPreferD3D11FL10": true,
    echo   "FFlagGraphicsEnableD3D10Compute": true,
    echo   "DFIntTextureQualityOverride": 0,
)

:: MSAA Settings - GPU Dependent
if "%isHighEndGPU%"=="true" (
    echo   "FIntDebugForceMSAASamples": 8,
) else (
    echo   "FIntDebugForceMSAASamples": 4,
)

:: Visual Optimization
echo   "DFFlagDebugRenderForceTechnologyVoxel": true,
echo   "FFlagHandleAltEnterFullscreenManually": false,
echo   "DFFlagTextureQualityOverrideEnabled": true,
echo   "FFlagFixGraphicsQuality": true,
echo   "FFlagCommitToGraphicsQualityFix": true,
echo   "FIntFRMMinGrassDistance": 0,
echo   "FIntFRMMaxGrassDistance": 0,
echo   "FFlagDebugRenderingSetDeterministic": true,
echo   "FFlagDisablePostFx": true,
echo   "FFlagCloudsReflectOnWater": true,
echo   "FIntRenderShadowIntensity": 0,
echo   "FFlagFastGPULightCulling3": true,

:: Texture Settings
echo   "FStringPartTexturePackTable2022": "{\"glass\":{\"ids\":[\"rbxassetid://9873284556\",\"rbxassetid://9438453972\"],\"color\":[254,254,254,7]}}",
echo   "FStringPartTexturePackTablePre2022": "{\"glass\":{\"ids\":[\"rbxassetid://7547304948\",\"rbxassetid://7546645118\"],\"color\":[254,254,254,7]}}",
echo   "FStringTerrainMaterialTable2022": "",
echo   "FStringTerrainMaterialTablePre2022": "",

:: Performance Optimization
echo   "FFlagPreloadAllFonts": true,
echo   "FFlagEnableBetaFacialAnimation2": false,
echo   "DFFlagLoadCharacterLayeredClothingProperty2": false,
echo   "FIntHSRClusterSymmetryDistancePercent": 10000,
echo   "DFFlagEnableDynamicHeadByDefault": false,

:: UI Settings
echo   "DFIntVoiceChatVolumeThousandths": 6000,
echo   "FFlagEnableInGameMenuModernization": false,
echo   "FIntRobloxGuiBlurIntensity": 0,
echo   "FFlagInGameMenuV1FullScreenTitleBar": false,
echo   "FFlagInGameMenuV1ExitModal": true,
echo   "FFlagInGameMenuV1LeaveToHome": false,
echo   "FFlagVoiceBetaBadge": false,

:: Telemetry Settings
echo   "FFlagDebugDisableTelemetryEphemeralCounter": true,
echo   "FFlagDebugDisableTelemetryEphemeralStat": true,
echo   "FFlagDebugDisableTelemetryEventIngest": true,
echo   "FFlagDebugDisableTelemetryPoint": true,
echo   "FFlagDebugDisableTelemetryV2Counter": true,
echo   "FFlagDebugDisableTelemetryV2Event": true,
echo   "FFlagDebugDisableTelemetryV2Stat": true,

:: Additional Optimizations
echo   "DFIntDebugFRMQualityLevelOverride": 4,
echo   "FFlagMovePrerender": true,
echo   "FFlagEnableQuickGameLaunch": true,
echo   "FFlagPreloadTextureData": true,
echo   "FFlagEnableV3MenuABTest": false,
echo   "FFlagEnableInGameMenuV3": false,
echo   "FFlagCoreGuiTypeSelfViewPresent": false,

:: Level of Detail Settings
echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 500,
echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 750,
echo   "DFIntCSGLevelOfDetailSwitchingDistance": 250,
echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 1000,
echo   "DFFlagDebugPauseVoxelizer": false,
echo   "FIntTerrainArraySliceSize": 0
echo }
) > "%VERSIONS_DIR%\!latest!\ClientSettings\ClientAppSettings.json"
goto :EOF

:: ==========================================
:: Main Execution
:: ==========================================
:main
echo Roblox Performance Optimizer
echo ===========================
echo.

call :createDirectories
if errorlevel 1 (
    echo Error: Failed to create directories
    goto :exit
)

call :detectSystemSpecs
if errorlevel 1 (
    echo Error: Failed to detect system specifications
    goto :exit
)

call :generateSettings
if errorlevel 1 (
    echo Error: Failed to generate settings
    goto :exit
)

echo.
echo Configuration completed successfully!
echo Settings file location: %VERSIONS_DIR%\!latest!\ClientSettings\ClientAppSettings.json
echo.
start "" "%VERSIONS_DIR%\!latest!\ClientSettings"

:exit
echo Press any key to exit...
pause >nul
exit /b
