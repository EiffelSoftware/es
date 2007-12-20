rem Build the EDK
set EDK_SOURCE=%cd%\edk
pushd %EDK_SOURCE%\Sample\Platform\Nt32\Build
nmake
popd

rem Build the EFI toolkit
pushd EFI_Toolkit_20
build nt32
nmake all
popd
set EFI_TOOLKIT=%cd%\EFI_Toolkit_20