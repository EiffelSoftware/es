SYSTEM TEST FOR CAPTURE - REPLAY
--------------------------------

This test checks, if the iteration0 example can be captured and replayed.

To do this, it uses the PERFORMANCE_TESTER_ATM_UI to run the example without
user interaction.
To prepare the application, run 'geant install' (prepares the erl reflection_library).
To compile the application under test, run 'geant compile_application'.
Afterwards, the test can be run using 'getest --ise'
