indexing
	description: "[
			Objects that print root class (CDD_INTERPRETER) for executing test cases. All test
			cases in system shall be created through this class.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_INTERPRETER_CLASS_PRINTER

inherit

	CDD_ROUTINES

	SHARED_EIFFEL_PROJECT

create
	make

feature {NONE} -- Initialization

	make (a_test_suite: like test_suite) is
			-- Set `test_suite' to `a_test_suite'.
		require
			a_test_suite_not_void: a_test_suite /= Void
		do
			test_suite := a_test_suite
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases for root class

	last_print_succeeded: BOOLEAN
			-- Has last call to `print_class' printed a new root class?

feature -- Basic operations

	print_class is
			-- Print a new root class containing all test cases in `test_suite'.
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
		do
			last_print_succeeded := True
			if test_suite.test_classes.count > 0 then
				create l_output_file.make (interpreter_path_name)
				l_output_file.open_write
				if l_output_file.is_open_write then
					create output_stream.make (l_output_file)
					put_indexing
					put_class_header
					put_test_class_instance
					output_stream.put_new_line
					put_test_procedure
					put_footer
					l_output_file.close
				else
					last_print_succeeded := False
				end
			else
				last_print_succeeded := False
			end
		ensure
			succeeded_implies_file_exists: last_print_succeeded implies
				(create {KL_TEXT_OUTPUT_FILE}.make (interpreter_path_name)).exists
		end

feature {NONE} -- Access implementation

	output_stream: ERL_G_INDENTING_TEXT_OUTPUT_FILTER
			-- Output stream

feature {NONE} -- Implementation

	interpreter_path_name: STRING is
			-- Path to class CDD_INTERPRETER
			-- Note: file nor directory necessarilly exist
		local
			l_loc: CONF_DIRECTORY_LOCATION
			l_target: CONF_TARGET
		do
			if cached_interpreter_path_name = Void then
				l_target := test_suite.target
				l_loc := conf_factory.new_location_from_path (".\cdd_tests\" + l_target.name, l_target)
				cached_interpreter_path_name := l_loc.build_path ("", "cdd_interpreter.e")
			end
			Result := cached_interpreter_path_name
		end

	cached_interpreter_path_name: STRING
			-- Cache for interpreter path name; writtin on first call to `interprter_path_name'.

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
			output_stream.put_line ("CDD_INTERPRETER%N")
			output_stream.dedent
			output_stream.put_line ("inherit")
			output_stream.indent
			output_stream.put_line ("CDD_ABSTRACT_INTERPRETER%N")
			output_stream.dedent
			output_stream.put_line ("create")
			output_stream.indent
			output_stream.put_line ("execute")
			output_stream.dedent
			output_stream.put_line ("feature")
		end

	put_test_class_instance is
			-- Print `test_class_instance' routine to `output_stream'.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		local
			test_classes: DS_LINEAR [CDD_TEST_CLASS]
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_CLASS]
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
		do
			test_classes := test_suite.test_classes
			create list.make (test_classes.count)
			from
				l_cursor := test_classes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item.test_class = Void or else
					not l_cursor.item.test_class.is_ignored_test_class then
					create pair.make ("create {" + l_cursor.item.test_class_name + "}",
										l_cursor.item.test_class_name)
					list.put_last (pair)
				end
				l_cursor.forth
			end
			create printer.make (output_stream)
			output_stream.indent
			printer.print_item_by_name_query ("test_class_instance", "CDD_TEST_CASE", list)
			output_stream.dedent
		end

	put_test_procedure is
			-- Print `test_procedure' routine to `output_stream'.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		local
			test_classes: DS_LINEAR [CDD_TEST_CLASS]
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_CLASS]
			l_routine_cursor: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
			printer: ERL_G_LOOKUP_PRINTER
			list: DS_ARRAYED_LIST [DS_PAIR [STRING, STRING]]
			pair: DS_PAIR [STRING, STRING]
			l_name: STRING
		do
			test_classes := test_suite.test_classes
			create list.make (test_classes.count)
			from
				l_cursor := test_classes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item.test_class = Void or else
				not l_cursor.item.test_class.is_ignored_test_class then
					l_routine_cursor := l_cursor.item.test_routines.new_cursor
					from
						l_routine_cursor.start
					until
						l_routine_cursor.after
					loop
						l_name := l_routine_cursor.item.name
						create pair.make ("agent {" + l_cursor.item.test_class_name + "}." + l_name,
											l_cursor.item.test_class_name + "." + l_name)
						list.force_last (pair)
						l_routine_cursor.forth
					end
				end
				l_cursor.forth
			end
			create printer.make (output_stream)
			output_stream.indent
			printer.print_item_by_name_query ("test_procedure", "PROCEDURE [ANY, TUPLE [CDD_TEST_CASE]]", list)
			output_stream.dedent
		end

	put_test_setting_header is
			-- Append `test_setting' feature header.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		do
			output_stream.put_line ("feature -- Access%N")

				-- Context
			output_stream.indent
			output_stream.put_line ("test_setting: HASH_TABLE [TUPLE [instance: CDD_TEST_CASE; test_features: HASH_TABLE [PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_TEST_CASE]], STRING]], STRING] is")
			output_stream.indent
			output_stream.put_line ("%"All test cases in this target%"")
			output_stream.put_line ("local")
			output_stream.indent
			output_stream.put_line ("l_fht: HASH_TABLE [PROCEDURE [CDD_TEST_CASE, TUPLE [CDD_TEST_CASE]], STRING]")
			output_stream.dedent
			output_stream.put_line ("once")
			output_stream.indent
		end

	put_footer is
			-- Append `test_setting' feature and class footer.
		require
			valid_output_stream: output_stream /= Void and then output_stream.is_open_write
		do
			output_stream.put_line ("%N%Nend")
		end

	conf_factory: CONF_COMP_FACTORY is
			-- Factory for creating location
		once
			create Result
		ensure
			not_void: Result /= Void
		end

invariant

	test_suite_not_void: test_suite /= Void

end
