@echo off
setlocal enabledelayedexpansion

:: Create the ClientSettings directories
mkdir "%LOCALAPPDATA%\Roblox\ClientSettings" 2>nul

:: Find the latest Roblox version folder
for /f "delims=" %%i in ('dir /b /ad /od "%LOCALAPPDATA%\Roblox\Versions\version-*"') do set "latest=%%i"

:: Create the ClientSettings directory in the latest version folder
mkdir "%LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings" 2>nul

:: Detect system specifications
set "isNewerPC=false"
set "isHighEndGPU=false"

:: Check RAM (8GB threshold)
for /f "tokens=2 delims==" %%A in ('wmic ComputerSystem get TotalPhysicalMemory /value') do (
    set "ramBytes=%%A"
    if !ramBytes! GEQ 8589934592 set "isNewerPC=true"
)

:: Check GPU memory (4GB threshold)
for /f "tokens=2 delims==" %%B in ('wmic PATH Win32_VideoController get AdapterRAM /value') do (
    set "gpuBytes=%%B"
    if !gpuBytes! GEQ 4294967296 set "isHighEndGPU=true"
)

:: Write the flags to ClientAppSettings.json with improved performance settings
(
echo {
echo   "FFlagGameBasicSettingsFramerateCap4": true,
echo   "DFIntTaskSchedulerTargetFps": 360,
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
if "%isHighEndGPU%"=="true" (
    echo   "FIntDebugForceMSAASamples": 8,
) else (
    echo   "FIntDebugForceMSAASamples": 4,
)
echo   "DFFlagDebugRenderForceTechnologyVoxel": true,
echo   "FFlagHandleAltEnterFullscreenManually": false,
echo   "FStringPartTexturePackTable2022": "{\"glass\":{\"ids\":[\"rbxassetid://9873284556\",\"rbxassetid://9438453972\"],\"color\":[254,254,254,7]}}",
echo   "FStringPartTexturePackTablePre2022": "{\"glass\":{\"ids\":[\"rbxassetid://7547304948\",\"rbxassetid://7546645118\"],\"color\":[254,254,254,7]}}",
echo   "FStringTerrainMaterialTable2022": "",
echo   "FStringTerrainMaterialTablePre2022": "",
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
echo   "FFlagEnableCommandAutocomplete": false,
echo   "FFlagPreloadAllFonts": true,
echo   "FFlagEnableBetaFacialAnimation2": false,
echo   "DFFlagLoadCharacterLayeredClothingProperty2": false,
echo   "FIntHSRClusterSymmetryDistancePercent": 10000,
echo   "DFFlagEnableDynamicHeadByDefault": false,
echo   "DFIntVoiceChatVolumeThousandths": 6000,
echo   "DFFlagDebugPerfMode": true,
echo   "FFlagEnableInGameMenuModernization": false,
echo   "FFlagEnableAccessibilitySettingsAPIV2": true,
echo   "FFlagEnableAccessibilitySettingsEffectsInCoreScripts2": true,
echo   "FFlagEnableAccessibilitySettingsEffectsInExperienceChat": true,
echo   "FFlagEnableAccessibilitySettingsInExperienceMenu2": true,
echo   "FIntRobloxGuiBlurIntensity": 0,
echo   "FFlagInGameMenuV1FullScreenTitleBar": false,
echo   "FFlagInGameMenuV1ExitModal": true,
echo   "FFlagInGameMenuV1LeaveToHome": false,
echo   "FFlagVoiceBetaBadge": false,
echo   "FFlagDebugDisableTelemetryEphemeralCounter": true,
echo   "FFlagDebugDisableTelemetryEphemeralStat": true,
echo   "FFlagDebugDisableTelemetryEventIngest": true,
echo   "FFlagDebugDisableTelemetryPoint": true,
echo   "FFlagDebugDisableTelemetryV2Counter": true,
echo   "FFlagDebugDisableTelemetryV2Event": true,
echo   "FFlagDebugDisableTelemetryV2Stat": true,
echo   "DFIntDebugFRMQualityLevelOverride": 4,
echo   "FFlagMovePrerender": true,
echo   "FFlagEnableQuickGameLaunch": true,
echo   "FFlagPreloadTextureData": true,
echo   "FFlagEnableV3MenuABTest": false,
echo   "FFlagEnableInGameMenuV3": false,
echo   "FFlagCoreGuiTypeSelfViewPresent": false,
echo   "DFIntCSGLevelOfDetailSwitchingDistanceL12": 500,
echo   "DFIntCSGLevelOfDetailSwitchingDistanceL23": 750,
echo   "DFIntCSGLevelOfDetailSwitchingDistance": 250,
echo   "DFIntCSGLevelOfDetailSwitchingDistanceL34": 1000,
echo   "DFFlagDebugPauseVoxelizer": false,
echo   "FIntTerrainArraySliceSize": 0
echo }
) > "%LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings\ClientAppSettings.json"

echo Successfully wrote FFlags to: %LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings\ClientAppSettings.json

:: Open the folder in File Explorer
start "" "%LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings"

echo Opened ClientSettings folder in File Explorer
echo.
echo Press any key to exit...
pause >nul
