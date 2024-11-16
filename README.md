# Roblox Performance Optimizer

A batch script that automatically configures Roblox's client settings for optimal performance while maintaining visual quality based on your system specifications.

## Features

### Automatic Hardware Detection
- Detects system RAM (8GB threshold)
- Detects GPU memory (4GB threshold)
- Automatically adjusts settings based on your hardware capabilities

### Performance Optimizations
- Unlocks FPS cap to 360
- Optimizes network packet size for better connection
- Configures DirectX settings based on hardware capability
- Adjusts texture quality based on available system resources
- Implements MSAA (anti-aliasing) based on GPU capability

### Graphics Settings
- `DFIntTaskSchedulerTargetFps`: 360 (Increases FPS cap)
- `DFIntConnectionMTUSize`: 1472 (Optimizes network packet size)
- `FIntDebugForceMSAASamples`: 8/4 (Anti-aliasing quality based on GPU)
- `DFIntTextureQualityOverride`: 3/2 (Texture quality based on RAM)
- `FFlagDisablePostFx`: true (Disables post-processing for better performance)
- `FFlagFastGPULightCulling3`: true (Optimizes light rendering)
- `FFlagMovePrerender`: true (Improves frame pacing)
- `FFlagPreloadTextureData`: true (Reduces texture pop-in)

### Quality of Life Features
- Creates backup of settings
- Automatically finds latest Roblox version
- Opens settings folder after completion
- Disables unnecessary telemetry
- Disables beta features that might impact performance

## Installation

1. Download the `.bat` file
2. Run it as administrator (recommended)
3. The script will automatically:
   - Create necessary directories
   - Detect your system specifications
   - Apply optimized settings
   - Create a backup of the configuration

## System Requirements

### Minimum:
- Windows 7 or higher
- 4GB RAM
- DirectX 10 capable GPU

### Recommended:
- Windows 10/11
- 8GB+ RAM
- DirectX 11 capable GPU with 4GB+ VRAM

## Advanced Settings Explanation

### Graphics Settings
- DirectX 11 is enabled on newer PCs for better performance
- DirectX 10 fallback is configured for older systems
- Texture quality is set higher (3) on 8GB+ RAM systems
- MSAA is set to 8x on high-end GPUs, 4x on others

### Performance Settings
- Disabled post-processing effects for better performance
- Optimized grass rendering distances
- Enabled fast GPU light culling
- Configured deterministic rendering for stability
- Disabled dynamic heads and beta facial animations
- Pre-loading enabled for textures and fonts

### Network Settings
- Optimized MTU size for better network performance
- Configured voice chat volume settings

### UI Settings
- Disabled blur effects for better performance
- Disabled beta features and modernization
- Configured menu behavior for stability

## Troubleshooting

If you experience any issues:
1. Check the backup file in `%LOCALAPPDATA%\Roblox\ClientSettings\`
2. Verify that you have the latest Roblox version installed
3. Run the script as administrator
4. Make sure your system meets the minimum requirements

## Notes

- Settings are automatically applied to the latest Roblox version
- A backup is created in case you need to restore previous settings
- The script needs to be re-run after Roblox updates
- Some settings may be overridden by future Roblox updates

## Safety

This script:
- Only modifies Roblox client settings
- Creates backups of modified files
- Doesn't modify any system files
- Uses official Roblox FFlags
- Can be easily reversed by deleting the ClientSettings folder

## Contributing

Feel free to suggest improvements or report issues. This script is maintained to keep up with Roblox's latest versions and optimal performance settings.

## Updates

The script is regularly updated to include:
- New performance optimizations
- Support for latest Roblox versions
- Better hardware detection
- Additional quality of life features
