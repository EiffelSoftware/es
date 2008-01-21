indexing
	description: "Objects that print a class that creates and runs a test case"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_ROOT_CLASS_PRINTER

feature -- Access

	test_suite: CDD_TEST_SUITE
			-- Target for which root class is printed

	last_print_succeeded: BOOLEAN
			-- Has last call to `print_root_class' printed a new root class?

feature -- Basic operations

	print_root_class (a_loc: CONF_DIRECTORY_LOCATION; a_test_routine: CDD_TEST_ROUTINE) is
			-- Print new root class for `a_test_routine'.
		require
			a_loc_not_void: a_loc /= Void
			a_test_routine_not_void: a_test_routine /= Void
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
		do
			last_print_succeeded := True
			create l_output_file.make (a_loc.build_path ("", "cdd_root_class.e"))
			l_output_file.recursive_open_write
			if l_output_file.is_open_write then
				create output_stream.make (l_output_file)
				put_indexing
				put_class_header
				put_root_feature (a_test_routine)
				put_footer
				l_output_file.close
			else
				last_print_succeeded := False
			end
		ensure
			succeeded_implies_file_exists: last_print_succeeded implies
				(create {KL_TEXT_OUTPUT_FILE}.make (a_loc.build_path ("", "cdd_root_class.e"))).exists
		end

feature {NONE} -- Implementation (Access)

	output_stream: ERL_G_INDENTING_TEXT_OUTPUT_FILTER
			-- Output stream

	conf_factory: CONF_COMP_FACTORY is
			-- Factory for creating location
		once
			create Result
		ensure
			not_void: Result /= Void
		end

feature {NONE} -- Implementation

	put_indexing is
			-- Append indexing clause.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		do
			output_stream.put_line ("indexing%N")
			output_stream.indent
			output_stream.put_line ("description: %"Objects that execute test cases%"")
			output_stream.put_line ("author: %"CDD Tool%"")
			output_stream.dedent
			output_stream.put_line ("")
		end

	put_class_header is
			-- Append cdd interpreter class header.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		do
			output_stream.put_line ("class")
			output_stream.indent
			output_stream.put_line ("CDD_ROOT_CLASS%N")
			output_stream.dedent
			output_stream.put_line ("create")
			output_stream.indent
			output_stream.put_line ("make")
			output_stream.dedent
			output_stream.put_new_line
			output_stream.put_line ("feature {NONE} -- Initialization")
			output_stream.put_new_line
		end

	put_root_feature (a_test_routine: CDD_TEST_ROUTINE) is
			-- Append creation feature for executing `a_test_routine'.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
			a_test_routine_not_void: a_test_routine /= Void
		do
			output_stream.indent
			output_stream.put_line ("make is")
			output_stream.indent
			output_stream.put_line ("local")
			output_stream.indent
			output_stream.put_line ("l_abstract_test_case: CDD_TEST_CASE")
			output_stream.put_line ("l_test_case: " + a_test_routine.test_class.test_class_name)
			output_stream.dedent
			output_stream.put_line ("do")
			output_stream.indent
			output_stream.put_line ("create l_test_case")
			output_stream.put_line ("l_abstract_test_case := l_test_case")
			output_stream.put_line ("l_abstract_test_case.set_up")
			output_stream.put_line ("l_test_case." + a_test_routine.name)
			output_stream.put_line ("l_abstract_test_case.tear_down")
			output_stream.dedent

			output_stream.put_line ("end")
			output_stream.dedent
			output_stream.dedent
		end

	put_footer is
			-- Append `test_setting' feature and class footer.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		do
			output_stream.put_line ("%N%Nend")
		end

end
