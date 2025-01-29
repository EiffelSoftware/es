#!/bin/bash
# This script Configures, Cleans, and Builds libbson and libmongoc using CMake
# Make the script exit on any error
set -e
# Clean the previous build and install directories
rm -rf _build
rm -rf _install
# Configure with explicit 64-bit architecture
cmake -S . -B _build \
    -D ENABLE_EXTRA_ALIGNMENT=OFF \
    -D ENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF \
    -D CMAKE_BUILD_TYPE=RelWithDebInfo \
    -D BUILD_VERSION="1.29.0" \
    -D ENABLE_MONGOC=ON \
    -D ENABLE_SSL=OPENSSL \
    -D ENABLE_SASL=OFF \
    -D ENABLE_ICU=OFF \
    -D ENABLE_SNAPPY=OFF
# Build the project using all available cores
cmake --build _build --config RelWithDebInfo --parallel $(nproc)
# Ask user whether to install locally or system-wide
read -p "Install system-wide to /usr/local? (y/N) " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    # System-wide installation
    sudo cmake --install "_build" --config RelWithDebInfo
    sudo ldconfig
    echo "Installed system-wide in /usr/local"
else
    # Local installation
    cmake --install "_build" --prefix "_install" --config RelWithDebInfo
    echo "Installed locally in _install directory"
fi