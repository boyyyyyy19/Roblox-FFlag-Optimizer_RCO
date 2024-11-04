# Roblox FFlags Optimizer

This batch script optimizes Roblox’s performance by modifying various FFlags (Feature Flags) and settings in the client configuration. It automatically locates your Roblox installation and applies optimized settings tailored for different hardware configurations, enhancing both performance and visual quality.

## What Does It Do?

The script performs the following actions:

1. **Creates Necessary Directories**:
   - Creates the `ClientSettings` directory in both:
     - The user's AppData folder (`%LOCALAPPDATA%\Roblox\ClientSettings`)
     - The latest Roblox version folder to ensure compatibility with updates

2. **Detects and Uses the Most Recent Roblox Version**:
   - Locates the latest version of Roblox in `%LOCALAPPDATA%\Roblox\Versions`

3. **Applies Optimized Settings Based on RAM Size**:
   - Checks the available RAM to determine if the PC is newer (≥8GB RAM) or older (<8GB RAM)
   - Adjusts settings based on the detected RAM size to optimize for high or low-performance machines

4. **Key Performance Optimizations**:
   - Sets the frame rate cap to 240 FPS for smoother gameplay
   - Configures network MTU size for optimized data transfer
   - Adjusts Direct3D settings based on the PC’s performance to optimize rendering
   - Improves texture quality and reduces unnecessary visual effects for better performance
   - Disables telemetry features to reduce CPU usage and network overhead

5. **Enhanced Visual and Audio Settings**:
   - Enables D3D11 for better graphics on newer PCs
   - Customizes texture and glass materials for higher visual quality
   - Configures anti-aliasing (MSAA) and other quality settings
   - Sets voice chat volume and UI enhancements for an improved user experience
   - Reduces blur, shadow intensity, and other visual effects to improve clarity

6. **Automatic Folder Opening**:
   - Automatically opens the `ClientSettings` folder in File Explorer after applying changes for easy access

## Key Optimizations

### Performance:
- **Frame Rate Management**: Sets target FPS to 240 for smoother gameplay, depending on system capability
- **Graphics Rendering**: Configures Direct3D settings based on the PC’s performance level to enhance rendering quality
- **Network**: Optimizes MTU size to potentially reduce latency
- **Reduced Effects**: Disables post-processing effects, blur, and shadows to enhance performance
- **Telemetry**: Disables unnecessary telemetry features to improve client-side performance

### Visual Quality:
- **Anti-Aliasing**: Configures MSAA to reduce jagged edges and improve visual quality
- **Textures**: Optimizes texture quality and customizes glass materials for enhanced visuals
- **Reduced Blur**: Configures blur and shadow intensity for a crisper display

### Quality of Life:
- **Voice Chat Volume**: Adjusts default voice chat volume for better in-game communication
- **UI Enhancements**: Modifies menu behaviors and accessibility settings for an improved user experience
- **Reduced Blur Effects**: Sets blur intensity to zero for clearer visuals, especially on older PCs

## How to Use

1. Copy the batch script from this repository.
2. Run the batch script. No administrator privileges are required.
3. Wait for the confirmation message.
4. After running, the script will automatically open the `ClientSettings` folder.
5. Restart Roblox to apply the changes.

## Notes

- These settings are optimized to balance performance with good visual quality, targeting both high-end and low-end PCs.
- **To revert changes**: Simply delete the `ClientAppSettings.json` file in the `ClientSettings` folder.
- **Pre-Rendering**: The script applies pre-rendering, where frames are rendered in advance to improve performance and reduce latency.

Enjoy a smoother and more visually enhanced Roblox experience!
