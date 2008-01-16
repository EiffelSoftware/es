Create your testcases in the same manner as the existing ones:

- Each subdirectory of the directory containing this file represents one testcase, containing one system under test

- !!!!!!! IMPORTANT: the project file must be named "config.ecf" (otherwise testcase is not found)
- !!!!!!! EVEN MORE IMPORTANT: the project must provide a target "sut", which is chosen as target for compilation of system under test (otherwise infinity loop occurs currently...)

- So far now oracle is provided, and there is no way of declaring expected results


Running the testcases:

- Execute the build.eant script. Target 'test_all' deletes all compilation files + result files, and executes all test cases from scratch

- Currently execution is supported on Linux/Unix operation systems. Excution on windows requires some Linux-like shell and support for the 'rm' command (both provided by Cygwin, has been tested)




