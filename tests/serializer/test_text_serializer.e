indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_TEXT_SERIALIZER

inherit
	TS_TEST_CASE
	redefine
		set_up,
		tear_down
	end

--Hint: as the Object Identifiers are written to the logfiles, too, don't allocate more
-- objects on set_up, as it would break all solution log files (the generated ones are compared against)


feature -- Test Variables:
		serializer: TEXT_SERIALIZER

		example: EXAMPLE_CLASS

		string_arg: STRING

		real_arg: REAL

		int_arg: INTEGER

feature -- Helpers
	set_up
			-- Set up the environment
		do
			create example.make
			string_arg := "foo_string"
			real_arg := 12.25
			int_arg := 12
		end

	tear_down
			-- tear down the environment.
		do
			-- this is already done in the test cases, so it's possible to compare the files
	--		if serializer /= Void then
	--			serializer.close_file()
	--		end
		end

feature -- Testing the tests:

	test_testing --just for experiments
		do
		end

	test_creation
		do
			--creation already done in the set_up.
			create serializer.make_on_textfile("test_creation.log")
			assert("serializer created", serializer /= Void)
		end

	test_calls
		local
			filename: STRING
		do
			filename := "test_calls.log"
			create serializer.make_on_textfile (filename)
			serializer.write_incall ("test_incall", example, [example, string_arg, real_arg, int_arg])
			serializer.write_outcall ("test_outcall", example, [example, string_arg, real_arg, int_arg])
			serializer.close_file

			assert_files_equal ("written file correct", filename, "test_calls.res")
		end

	test_special_arguments
			--test if serialization for special arguments works.
		local
			filename: STRING
		do
			filename := "test_special_arguments.log"
			create serializer.make_on_textfile (filename)
			serializer.write_incall("void_argument", example, [Void])
			serializer.write_outcall("no_argument", example, [])
			serializer.close_file

			assert_files_equal ("written file correct", filename, "test_special_arguments.res")
		end


	test_retcalls
		local
			filename: STRING
		do
			filename := "test_retcalls.log"
			create serializer.make_on_textfile (filename)
			serializer.write_incallret (example)
			serializer.write_outcallret (example)
			serializer.write_incallret(Void)
			serializer.close_file

			assert_files_equal ("written file correct", filename, "test_retcalls.res")
		end
feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
