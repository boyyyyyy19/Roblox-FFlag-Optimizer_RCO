# Roblox FFlags Optimizer

This batch script optimizes Roblox's performance by modifying various FFlags (Feature Flags) and settings in the client configuration. It automatically locates your Roblox installation and applies optimized settings for better performance and visual quality.

## What Does It Do?

The script performs the following actions:

1. Creates necessary ClientSettings directories in both:
   - The user's AppData folder (`%LOCALAPPDATA%\Roblox\ClientSettings`)
   - The latest Roblox version folder

2. Automatically detects and uses the most recent Roblox installation

3. Applies optimized settings including:
   - Sets frame rate cap to 144 FPS
   - Optimizes network MTU size for better connection
   - Enables D3D11 graphics
   - Improves texture quality and graphics rendering
   - Disables unnecessary visual effects for better performance
   - Reduces blur and shadow effects
   - Optimizes memory usage and loading times
   - Disables telemetry for improved performance
   - Configures voice chat volume
   - Modifies UI and menu behavior

4. Opens the ClientSettings folder automatically after applying changes

## Key Optimizations

- **Performance**: 
  - Improved frame rate management
  - Optimized graphics quality
  - Enhanced network settings
  - Reduced visual effects that impact performance

- **Visual Quality**:
  - Configured texture quality
  - Optimized anti-aliasing (MSAA)
  - Custom glass texture settings
  - Disabled unnecessary post-processing effects

- **Quality of Life**:
  - Adjusted voice chat volume
  - Modified menu behaviors
  - Improved accessibility settings
  - Reduced blur effects

## How to Use

1. Download the batch script
2. Run it as administrator
3. Wait for the confirmation message
4. The ClientSettings folder will open automatically
5. Restart Roblox to apply the changes

## Note

These settings are optimized for performance while maintaining good visual quality. The script creates a `ClientAppSettings.json` file that can be easily reverted by deleting it from the ClientSettings folder.
