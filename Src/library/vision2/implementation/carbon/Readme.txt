
To start hacking on the carbon implementation:
- point your $ISE_LUBRARY to the branch this implementation resides in
- go to the wrapper directory and run "geant c_build_library" (ewg needs to be in your path for this)

Now you simply need to modify your project's .ecf file and point
it to vision2-carbon.ecf instead of vision2.ecf.