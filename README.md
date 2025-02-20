# Roblox Performance Optimizer

## Overview

The Roblox Performance Optimizer is a batch script designed to enhance the performance of Roblox on various system configurations, ranging from legacy to high-end systems. This script automates the process of detecting your system's capabilities and applying optimized settings to improve the gaming experience.

## Features

- **Automatic System Detection**: Detects your system's RAM, CPU, GPU, OS version, DirectX support, and storage type.
- **System Classification**: Classifies your system into categories such as ultra_legacy, legacy, low_end, mid_low, mid_range, high_mid, and high_end.
- **Optimized Configuration**: Applies tailored settings based on your system's classification to improve Roblox performance.
- **Detailed Reporting**: Generates a detailed optimization report outlining the applied settings and system information.
- **User-Friendly Interface**: Provides clear prompts and options for post-optimization actions.

## Requirements

- Windows Operating System
- Roblox installed on your system

## Usage

1. **Download the Script**: Save the script to a `.bat` file, for example, `RobloxOptimizer.bat`.
2. **Run the Script**: Double-click the `.bat` file to execute the script.
3. **Follow the Prompts**: The script will guide you through the optimization process and provide options at the end.

## Script Sections

1. **Environment Preparation**: Sets up necessary directories and initializes logging.
2. **Roblox Installation Detection**: Detects the latest Roblox version installed on your system.
3. **System Capability Analysis**: Analyzes your system's hardware and software capabilities.
4. **System Category Classification**: Classifies your system based on the detected capabilities.
5. **Configuration Generation**: Generates and applies optimized settings based on the system classification.
6. **Finalization**: Completes the optimization process and provides post-optimization options.

## Configuration Files

- **ClientAppSettings.json**: Contains the optimized settings applied to Roblox.
- **OptimizationReport.txt**: A detailed report of the applied settings and system information.

## Troubleshooting

If you encounter any issues after applying the optimizations:
1. Delete the `ClientAppSettings.json` file.
2. Launch Roblox normally to reset to default settings.
3. Edit the script to try a different optimization category.

## License

This script is provided as-is without any warranty. Feel free to modify and distribute it as needed.

## Contact

For any questions or issues, please open an issue on the repository or contact the maintainer.

---

**Note**: Always back up your configuration files before running optimization scripts.
