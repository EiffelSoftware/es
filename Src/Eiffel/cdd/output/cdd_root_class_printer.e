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
			internal_refresh_agent := agent print_root_class
			test_suite.refresh_actions.extend (internal_refresh_agent)
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases for root class

feature -- Basic operations

	print_root_class is
			-- Print a new root class containing all test cases in `test_suite'.
		local
			l_loc: CONF_DIRECTORY_LOCATION
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_failed: BOOLEAN
			l_target: CONF_TARGET
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			l_target := test_suite.target
			l_loc := conf_factory.new_location_from_path (".\cdd_tests\" + l_target.name, l_target)
			create l_output_file.make (l_loc.build_path ("", "cdd_interpreter.e"))
			l_output_file.open_write
			if l_output_file.is_open_write then
				initialize (l_output_file)
				put_indexing
				put_class_header
				put_test_setting_header
				put_line ("create Result.make (" + test_suite.test_cases.count.out + ")")

				from
					l_cursor := test_suite.test_cases.new_cursor
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

				put_footer
				l_output_file.close
			end
		end

feature {NONE} -- Implementation

	internal_refresh_agent: PROCEDURE [like Current, TUPLE]

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

	conf_factory: CONF_COMP_FACTORY is
			-- Factory for creating location
		once
			create Result
		ensure
			not_void: Result /= Void
		end


invariant
	test_suite_not_void: test_suite /= Void
	internal_refresh_agent_not_void: internal_refresh_agent /= Void
	subscribed: test_suite.refresh_actions.has (internal_refresh_agent)

end
