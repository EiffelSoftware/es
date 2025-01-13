@echo off
REM This script Configures, Cleans, and Builds libbson and libmongoc using CMake

REM Clean the previous build and install directories
if exist _build (
    rmdir /s /q _build
)

if exist _install (
    rmdir /s /q _install
)

REM Configure with explicit 64-bit architecture and Windows Socket support
cmake -S . -B _build ^
   -G "Visual Studio 17 2022" ^
   -A x64 ^
   -D ENABLE_EXTRA_ALIGNMENT=OFF ^
   -D ENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ^
   -D CMAKE_BUILD_TYPE=RelWithDebInfo ^
   -D BUILD_VERSION="1.29.0" ^
   -D ENABLE_MONGOC=ON ^
   -D ENABLE_SSL=OFF ^
   -D ENABLE_SASL=OFF ^
   -D ENABLE_ICU=OFF ^
   -D ENABLE_SNAPPY=OFF
   
REM Build the project
cmake --build _build --config RelWithDebInfo --parallel

REM Installing the Built Results
cmake --install "_build" --prefix "_install" --config RelWithDebInfo