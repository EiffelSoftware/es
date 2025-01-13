# MongoDB C Driver Build Guide

This guide explains how to build the MongoDB C Driver (libmongoc) and its dependency libbson.

## Prerequisites

- CMake 3.15 or later
- Visual Studio 2022 (for Windows)
- Git (optional)

## Building on Windows

### Option 1: Using Pre-built Driver

We provide a pre-built MongoDB C driver in the `C\driver` folder. To use it:

1. Add the `bin` folder to your PATH environment variable
2. Include the appropriate headers and link against the provided libraries

### Option 2: Building from Source

1. Download the MongoDB C Driver source code:
   ```bash
   git clone https://github.com/mongodb/mongo-c-driver.git
   cd mongo-c-driver
   ```

2. Copy the provided `build_cdriver.bat` script to the root of the source directory

3. Run the build script:
   ```bash
   build_cdriver.bat
   ```

The script will:
- Clean previous build artifacts
- Configure the build with CMake using the following options:
  - 64-bit architecture
  - Visual Studio 2022 generator
  - RelWithDebInfo build type
  - Version 1.29.0          
  - Disabled features: SSL, SASL, ICU, SNAPPY, and extra alignment
- Build the project in parallel
- Install the results to `_install` directory

## Post-Build Steps

After building:

1. Copy the generated libraries and headers from `_install` to your project's `C\driver` directory
2. Ensure the following directory structure:
   ```
   C\driver\
   ├── bin\          # DLLs and executables
   ├── include\      # Header files
   │   └── libbson-1.0\
   │   └── libmongoc-1.0\
   └── lib\          # Static and import libraries
   ```


## Additional Resources

- [Official MongoDB C Driver Documentation](https://www.mongodb.com/docs/languages/c/)
- [Installation Guide](https://www.mongodb.com/docs/languages/c/c-driver/current/get-started/download-and-install/)
- [MongoDB C Driver Source](https://github.com/mongodb/mongo-c-driver)

## Platform-Specific Notes

### Windows
- Tutorial: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/

### Linux
- Tutorial: http://mongoc.org/libmongoc/current/installing.html#building-from-a-release-tarball
- Additional build dependencies may be required depending on your distribution