@echo off
setlocal enabledelayedexpansion

:: Create the ClientSettings directory in the user's AppData
mkdir "%LOCALAPPDATA%\Roblox\ClientSettings" 2>nul

:: Find the latest Roblox version folder
for /f "delims=" %%i in ('dir /b /ad /od "%LOCALAPPDATA%\Roblox\Versions\version-*"') do set "latest=%%i"

:: Create the ClientSettings directory in the latest version folder
mkdir "%LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings" 2>nul

:: Write the flags to ClientAppSettings.json
(
echo {
echo   "FFlagGameBasicSettingsFramerateCap4": true,
echo   "DFIntTaskSchedulerTargetFps": 144,
echo   "DFIntConnectionMTUSize": 1472,
echo   "FFlagDebugGraphicsPreferD3D11": true,
echo   "DFFlagDebugRenderForceTechnologyVoxel": true,
echo   "FFlagHandleAltEnterFullscreenManually": false,
echo   "FStringPartTexturePackTable2022": "{\"glass\":{\"ids\":[\"rbxassetid://9873284556\",\"rbxassetid://9438453972\"],\"color\":[254,254,254,7]}}",
echo   "FStringPartTexturePackTablePre2022": "{\"glass\":{\"ids\":[\"rbxassetid://7547304948\",\"rbxassetid://7546645118\"],\"color\":[254,254,254,7]}}",
echo   "FStringTerrainMaterialTable2022": "",
echo   "FStringTerrainMaterialTablePre2022": "",
echo   "DFFlagTextureQualityOverrideEnabled": true,
echo   "DFIntTextureQualityOverride": 2,
echo   "FFlagFixGraphicsQuality": true,
echo   "FFlagCommitToGraphicsQualityFix": true,
echo   "FIntDebugForceMSAASamples": 4,
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
echo   "FIntHSRClusterSymmetryDistancePercent": "10000",
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
echo   "DFIntDebugFRMQualityLevelOverride": 3,
echo   "FIntRobloxGuiBlurIntensity": 0,
echo   "FFlagMovePrerender": true,
echo }
) > "%LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings\ClientAppSettings.json"

echo Successfully wrote FFlags to: %LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings\ClientAppSettings.json

:: Open the folder in File Explorer
start "" "%LOCALAPPDATA%\Roblox\Versions\!latest!\ClientSettings"

echo Opened ClientSettings folder in File Explorer

pause
