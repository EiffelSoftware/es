
To start hacking on the carbon implementation:
1) point your $ISE_LIBRARY to the branch this implementation resides in
2) make sure you have $EWG pointing to your ewg directory and $EWG/bin in your $PATH. (export PATH=$PATH:$EWG/bin)
3) go to the wrapper directory and run "geant c_build_library"


Now you simply need to modify your project's .ecf file and point
it to vision2-carbon.ecf instead of vision2.ecf.