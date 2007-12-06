indexing
	description: "[
			Objects that print root class for executing test cases. All test
			cases in system shall be created through this class.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_ROOT_CLASS_PRINTER

inherit

	CDD_CLASS_PRINTER

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
			test_suite.full_refresh_actions.extend (agent print_root_class)
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases for root class

	last_print_succeeded: BOOLEAN
			-- Has last call to `print_root_class' printed a new root class?

	root_class_file_name: STRING is
			-- Path to root class file
			-- Note: file nor directory necessarilly exist
		local
			l_loc: CONF_DIRECTORY_LOCATION
			l_target: CONF_TARGET
		do
			if last_root_class_name = Void then
				l_target := test_suite.target
				l_loc := conf_factory.new_location_from_path (".\cdd_tests\" + l_target.name, l_target)
				last_root_class_name := l_loc.build_path ("", "cdd_interpreter.e")
			end
			Result := last_root_class_name
		end

feature -- Basic operations

	print_root_class is
			-- Print a new root class containing all test cases in `test_suite'.
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_count: INTEGER
		do
			last_print_succeeded := True
			create l_output_file.make (root_class_file_name)
			l_output_file.open_write
			if l_output_file.is_open_write then
				initialize (l_output_file)
				put_indexing
				put_class_header
				put_test_setting_header
				l_count := test_suite.test_classes.count
				put_line ("create Result.make (" + l_count.out + ")")

				put_test_class_table (test_suite.test_classes)

				put_footer
				l_output_file.close
			else
				last_print_succeeded := False
			end
		ensure
			succeeded_implies_file_exists: last_print_succeeded implies
				(create {KL_TEXT_OUTPUT_FILE}.make (root_class_file_name)).exists
		end

feature {NONE} -- Access implementation

	last_root_class_name: STRING
			-- Last computed root class name

feature {NONE} -- Implementation

	put_indexing is
			-- Append indexing clause.
		require
			initialized: is_output_stream_valid
		do
			put_line ("indexing%N")
			increase_indent
			put_line ("description: %"Objects that execute test cases%"")
			put_line ("author: %"CDD Tool%"")
			decrease_indent
			put_line ("")
		end

	put_class_header is
			-- Append cdd interpreter class header.
		require
			initialized: is_output_stream_valid
		do
			put_line ("class")
			increase_indent
			put_line ("CDD_INTERPRETER%N")
			decrease_indent
			put_line ("inherit")
			increase_indent
			put_line ("CDD_ABSTRACT_INTERPRETER%N")
			decrease_indent
			put_line ("create")
			increase_indent
			put_line ("execute")
			decrease_indent
		end

	put_test_setting_header is
			-- Append `test_setting' feature header.
		require
			initialized: is_output_stream_valid
		do
			put_line ("feature -- Access%N")

				-- Context
			increase_indent
			put_line ("test_setting: HASH_TABLE [TUPLE [instance: CDD_ABSTRACT_TEST_CASE; test_features: HASH_TABLE [PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_ABSTRACT_TEST_CASE]], STRING]], STRING] is")
			increase_indent
			put_comment ("All test cases in this target")
			put_line ("local")
			increase_indent
			put_line ("l_fht: HASH_TABLE [PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_ABSTRACT_TEST_CASE]], STRING]")
			decrease_indent
			put_line ("once")
			increase_indent
		end

	put_footer is
			-- Append `test_setting' feature and class footer.
		require
			initialized: is_output_stream_valid
		do
			decrease_indent
			put_line ("end%N")
			decrease_indent
			put_string ("%N%Nend -- class %N%N")
		end

	put_feature_table (a_test_class: CLASS_C) is
			-- Print class text for setting up feature hash table in `l_fht'
			-- with all test features in `a_test_class'.
		require
			a_test_class_not_void: a_test_class /= Void
		local
			l_ft: FEATURE_TABLE
			l_name, l_prefix: STRING
		do
			l_ft := a_test_class.feature_table
			l_prefix := "test_"
			from
				l_ft.start
			until
				l_ft.after
			loop
				l_name := l_ft.item_for_iteration.feature_name
				if l_name.count >= l_prefix.count and then
					l_name.substring (1, l_prefix.count).is_case_insensitive_equal (l_prefix) then
					put_line ("l_fht.put (agent {" + a_test_class.name_in_upper +
						"}." + l_name + ", %"" + l_name + "%")")
				end
				l_ft.forth
			end
			put_line ("")
		end

	put_test_class_table (a_list: DS_LINKED_LIST [CDD_TEST_CLASS]) is
			-- Print hash tables for all test classes and test routines in `a_list'.
		require
			initialized: is_output_stream_valid
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CLASS]
		do
			from
				create l_cursor.make (a_list)
				l_cursor.start
			until
				l_cursor.after
			loop
				put_line ("create l_fht.make (1)")
				put_feature_table (l_cursor.item.test_class)
				put_line ("Result.put ([create {" + l_cursor.item.test_class.name_in_upper +
					"}, l_fht], %"" + l_cursor.item.test_class.name_in_upper + "%")")
				put_line ("")
				l_cursor.forth
			end
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
