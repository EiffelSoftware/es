In order to build properly the runtime for EFI, the EDK and the EFI toolkit must be built and the environment variable EFI_TOOLKIT must point to the root of the toolkit.

The edk can be found at:
https://edk.tianocore.org/
It should be put in Src/C in a folder called Edk

The toolkit can be found at:
https://efi-toolkit.tianocore.org/
It should be put in Src/C in a folder Called EFI_Toolkit_20

To build the run-time, just go in src/C with a visual studio 2005 console and type:

	build_efi
	configure efi m

Unfortunately, the EDk is not built properly if its path contains any spaces.  It's dumb but the only thing we may do about it is checkout the code in a directory with no spaces in its path.