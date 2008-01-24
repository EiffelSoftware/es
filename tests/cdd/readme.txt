
CDD SYSTEM LEVEL TESTS

Usage:
Invoke the 'help' target of the build.eant file to get information on how to use the script

Requirements:
bash, rm, cp, sed, diff, echo (linux version), tee, 
-> on windows tested using Cygwin

How to add a test case:

- Create a new subdirectory holding the system under test (sut)
- The name of the subdirectory is the name of the test case
- the subdirectory needs to contain a 'config.ecf' file
- sut's with a .ecf file with an other name than 'config.ecf' will be ignored by the script 
- the sut HAS TO PROVIDE A TARGET 'sut' ! (this is most important, since an infinity loop will occur when running the script!!!)

The "regression" oracle

There is an oracle provided based on 'diff'. The actual output of a test case run is compared with a reference output.
In order to obtain such a reference output:

- Add the new test case
- Run the test case (geant test -A test_name=<name_of_test_case>)
- in the corresponding subdirectory a file 'zzz.outcome' will be produced
- Check manually if the 'zzz.outcome' file is correct
- If the 'zzz.outcome' reflects the proper result for the testcase, rename it to 'zzz.expected'
- The content of 'zzz.expected' will now serve as reference for all future test runs



