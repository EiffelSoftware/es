Create your testcases in the same manner as the existing ones:

- Each subdirectory of the directory containing this file represents one testcase, containing one system under test

- !!!!!!! IMPORTANT: the project file must be named "config.ecf" (otherwise testcase is not found)
- !!!!!!! ABSOLUTELY IMPORTANT: the project must provide a target "sut", which is chosen as target for compilation of system under test (otherwise infinity loop currently...)

- So far now oracle is provided, and there is no way of declaring expected results
