note
	description: "Summary description for {ES_ADB_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_CONFIG

inherit
	EPA_UTILITY

feature -- Project

	project: E_PROJECT
			-- Eiffel project.

feature -- Project status report

	is_project_loaded: BOOLEAN
		do
			Result := project /= Void
		end

feature -- Primitive config values

	class_groups: DS_ARRAYED_LIST [STRING]
			-- Groups of classes to be debugged.
		do
			if class_groups_internal = Void then
				create class_groups_internal.make_equal (10)
			end
			Result := class_groups_internal
		end

	working_directory: ES_ADB_WORKING_DIRECTORY
			-- Directory where intermediate results are to be stored.
		do
			if working_directory_internal = Void then
				if project /= Void then
					create working_directory_internal.make (default_working_directory)
				end
			end
			Result := working_directory_internal
		end

	testing_session_type: INTEGER

	max_session_length_for_testing: INTEGER

	should_use_fixed_seed_in_testing: BOOLEAN

	fixed_seed: INTEGER

	max_session_length_for_fixing: INTEGER

	max_nbr_fix_candidates: INTEGER

	should_fix_implementation: BOOLEAN

	should_fix_contracts: BOOLEAN

	max_nbr_passing_tests: INTEGER

	max_nbr_failing_tests: INTEGER

	should_show_implementation_fixable: BOOLEAN

	should_show_contract_fixable: BOOLEAN

	should_show_not_fixable: BOOLEAN

	should_show_not_yet_attempted: BOOLEAN

	should_show_candidate_fix_available: BOOLEAN

	should_show_candidate_fix_unavailable: BOOLEAN

	should_show_candidate_fix_accepted: BOOLEAN

	should_show_manually_fixed: BOOLEAN

feature -- Config value validity

	is_valid_max_session_length (a_val: INTEGER): BOOLEAN
		do
			Result := a_val > 0
		end

	is_valid_max_nbr_fix_candidates (a_val: INTEGER): BOOLEAN
		do
			Result := a_val > 0
		end

	is_valid_max_nbr_tests (a_val: INTEGER): BOOLEAN
		do
			Result := a_val >= 0
		end

	is_valid_testing_session_type (a_val: INTEGER): BOOLEAN
		do
			Result := Testing_session_type_one_class <= a_val and then a_val <= Testing_session_type_all_classes
		end

feature -- Classes and groups to debug

	classes_to_test_in_sessions: DS_ARRAYED_LIST [DS_HASH_SET [CLASS_C]]
			-- Classes grouped in sessions.
		local
			l_class_cursor: DS_HASH_SET_CURSOR [CLASS_C]
			l_set: DS_HASH_SET [CLASS_C]
			l_group_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
		do
			create Result.make_equal (32)

			inspect testing_session_type
			when testing_session_type_one_class then
				from
					l_class_cursor := all_classes.new_cursor
					l_class_cursor.start
				until
					l_class_cursor.after
				loop
					create l_set.make_equal (1)
					l_set.force (l_class_cursor.item)
					Result.force_last (l_set)

					l_class_cursor.forth
				end

			when testing_session_type_one_group then
				from
					l_group_cursor := class_groups.new_cursor
					l_group_cursor.start
				until
					l_group_cursor.after
				loop
					Result.force_last (groups_to_classes.item (l_group_cursor.item))
					l_group_cursor.forth
				end

			when testing_session_type_all_classes then
				Result.force_last (all_classes)
			end
		end

	all_classes: DS_HASH_SET [CLASS_C]
			-- All classes to debug.
		local
			l_groups_to_classes_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [CLASS_C], STRING]
		do
			if all_classes_internal = Void then
				create all_classes_internal.make_equal (64)
				from
					l_groups_to_classes_cursor := groups_to_classes.new_cursor
					l_groups_to_classes_cursor.start
				until
					l_groups_to_classes_cursor.after
				loop
					all_classes_internal.merge (l_groups_to_classes_cursor.item)
					l_groups_to_classes_cursor.forth
				end
			end

			Result := all_classes_internal
		end

	all_class_names: DS_HASH_SET [STRING]
			-- Set of names of classes to debug.
		local
			l_cursor: DS_HASH_SET_CURSOR [CLASS_C]
		do
			if all_class_names_internal = Void then
				create all_class_names_internal.make_equal (all_classes.count * 2 + 1)
				from
					l_cursor := all_classes.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					all_class_names_internal.force (l_cursor.item.name_in_upper)
					l_cursor.forth
				end
			end
			Result := all_class_names_internal
		end

	groups_to_classes: DS_HASH_TABLE [DS_HASH_SET [CLASS_C], STRING]
			-- Map from group names to the set of classes in that group.
			-- Key: group
			-- Val: set of classes in that group.
		do
			if groups_to_classes_internal = Void then
				create groups_to_classes_internal.make_equal (64)
			end
			Result := groups_to_classes_internal
		end

feature{NONE} -- Groups and classes implementation

	classes_in_group (a_group: STRING): DS_HASH_SET [CLASS_C]
			--
		require
			a_group /= Void and then not a_group.is_empty
			not a_group.has (' ') and then not a_group.has ('%T')
		local
			l_group: STRING
			l_list: LIST [STRING]
			l_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
		do
			create Result.make_equal (10)
			l_list := a_group.split (group_member_separator)
			l_list.do_all (agent (a_member: STRING; a_classes: DS_HASH_SET [CLASS_C]) do a_classes.merge (classes_in_group_member (a_member)) end (?, Result))
		end

	classes_in_group_member (a_member: STRING): DS_HASH_SET [CLASS_C]
			--
		require
			a_member /= Void and then not a_member.is_empty
			not a_member.has (' ') and then not a_member.has ('%T')
		local
			l_separator_index: INTEGER
			l_member_type, l_member_val: STRING
			l_conf_classes: ARRAYED_LIST [CONF_CLASS]

			l_list: LIST [STRING]
			l_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
		do
			create Result.make_equal (10)
			if a_member.has (group_member_type_value_separator) then
				l_separator_index := a_member.index_of (group_member_type_value_separator, 1)
				l_member_type := a_member.substring (1, l_separator_index - 1)
				if l_member_type.is_case_insensitive_equal_general ("cluster") then
					l_member_val := a_member.substring (l_separator_index + 1, a_member.count)
					if attached {CLUSTER_I} workbench.universe.group_of_name (l_member_val) as lt_cluster then
						l_conf_classes := lt_cluster.classes.linear_representation
						across l_conf_classes as l_conf_class_cursor loop
							if attached {EIFFEL_CLASS_I} l_conf_class_cursor.item as lt_eiffel_class then
								Result.force (lt_eiffel_class.compiled_class)
							end
						end
					end
				end
			else
				if attached first_class_starts_with_name (a_member) as lt_class then
					Result.force (lt_class)
				end
			end
		end

feature -- Modify class groups

	add_class_group (a_group: STRING)
			-- Add `a_group' to debug.
		require
			project /= Void
		do
			add_groups_to_debug_from_string (a_group)
		end

	remove_class_group (a_group: STRING)
			-- Remove `a_group' from groups to debug.
		require
			project /= Void
			a_group /= Void
		do
			if class_groups.has (a_group) then
				class_groups.delete (a_group)
				groups_to_classes.remove (a_group)
				all_classes_internal := Void
				all_class_names_internal := Void
			end
		end

	remove_all_class_groups
			-- Remove all groups to debug.
		do
			class_groups.wipe_out
			groups_to_classes.wipe_out
			all_classes_internal := Void
			all_class_names_internal := Void
		end

feature -- Set others

	set_working_directory (a_dir: ES_ADB_WORKING_DIRECTORY)
		require
			a_dir /= Void
		do
			working_directory_internal := a_dir.twin
		end

	set_testing_session_type (a_type: INTEGER)
		require
			is_valid_testing_session_type (a_type)
		do
			testing_session_type := a_type
		end

	set_max_session_length_for_testing (a_val: INTEGER)
		require
			is_valid_max_session_length (a_val)
		do
			max_session_length_for_testing := a_val
		end

	set_use_fixed_seed_in_testing (a_flag: BOOLEAN)
		do
			should_use_fixed_seed_in_testing := a_flag
		end

	set_fixed_seed (a_seed: INTEGER)
		do
			fixed_seed := a_seed
		end

	set_max_session_length_for_fixing (a_val: INTEGER)
		require
			is_valid_max_session_length (a_val)
		do
			max_session_length_for_fixing := a_val
		end

	set_max_nbr_fix_candidates (a_val: INTEGER)
		require
			is_valid_max_nbr_fix_candidates (a_val)
		do
			max_nbr_fix_candidates := a_val
		end

	set_fix_implementation (a_flag: BOOLEAN)
		do
			should_fix_implementation := a_flag
		end

	set_fix_contracts (a_flag: BOOLEAN)
		do
			should_fix_contracts := a_flag
		end

	set_max_nbr_passing_tests (a_val: INTEGER)
		require
			is_valid_max_nbr_tests (a_val)
		do
			max_nbr_passing_tests := a_val
		end

	set_max_nbr_failing_tests (a_val: INTEGER)
		require
			is_valid_max_nbr_tests (a_val)
		do
			max_nbr_failing_tests := a_val
		end

	set_show_implementation_fixable (a_flag: BOOLEAN)
		do
			should_show_implementation_fixable := a_flag
		end

	set_show_contract_fixable (a_flag: BOOLEAN)
		do
			should_show_contract_fixable := a_flag
		end

	set_show_not_fixable (a_flag: BOOLEAN)
		do
			should_show_not_fixable := a_flag
		end

	set_show_not_yet_attempted (a_flag: BOOLEAN)
		do
			should_show_not_yet_attempted := a_flag
		end

	set_show_candidate_fix_available (a_flag: BOOLEAN)
		do
			should_show_candidate_fix_available := a_flag
		end

	set_show_candidate_fix_unavailable (a_flag: BOOLEAN)
		do
			should_show_candidate_fix_unavailable := a_flag
		end

	set_show_candidate_fix_accepted (a_flag: BOOLEAN)
		do
			should_show_candidate_fix_accepted := a_flag
		end

	set_show_manually_fixed (a_flag: BOOLEAN)
		do
			should_show_manually_fixed := a_flag
		end

feature -- Default values

	initialize_default
			-- Initialize the config using default values.
		do
			class_groups_internal := Void
			working_directory_internal := Void
			testing_session_type := default_testing_session_type
			max_session_length_for_testing := default_max_session_length_for_testing
			should_use_fixed_seed_in_testing := default_should_use_fixed_seed_in_testing
			fixed_seed := default_fixed_seed
			max_session_length_for_fixing := default_max_session_length_for_fixing
			max_nbr_fix_candidates := default_max_nbr_fix_candidates
			should_fix_implementation := default_should_fix_implementation
			should_fix_contracts := default_should_fix_contracts
			max_nbr_passing_tests := default_max_nbr_passing_tests
			max_nbr_failing_tests := default_max_nbr_failing_tests

			should_show_implementation_fixable := default_should_show_implementation_fixable
			should_show_contract_fixable := default_should_show_contract_fixable
			should_show_not_fixable := default_should_show_not_fixable

			should_show_not_yet_attempted := default_should_show_not_yet_attempted
			should_show_candidate_fix_available := default_should_show_candidate_fix_available
			should_show_candidate_fix_unavailable := default_should_show_candidate_fix_unavailable
			should_show_candidate_fix_accepted := default_should_show_candidate_fix_unavailable
			should_show_manually_fixed := default_should_show_manually_fixed
		end

	default_working_directory: PATH
		require
			project /= Void
		do
			Result := project.project_directory.data_path.extended ("AutoDebug")
		end

	autodebug_config_path: PATH
		require
			project /= Void
		do
			Result := project.project_directory.location.extended ("AutoDebug.cfg")
		end

feature -- Load and save

	load (a_project: E_PROJECT)
			-- Load config from project directory, if possible.
			-- Initialize the variables to default value,
			-- if the value is missing, or the given one is invalid.
		require
			a_project /= Void
		local
			l_path: PATH
			l_file: PLAIN_TEXT_FILE
		do
			project := a_project

			l_path := autodebug_config_path
			create l_file.make_with_path (l_path)
			initialize_default
			if l_file.exists then
				load_from_file (l_file)
			end
		end

	unload
			-- Unload the config.
		do
			project := Void
			initialize_default
		end

	save
			-- Save config to project directory.
		require
			project /= Void
		local
			l_path: PATH
			l_file: PLAIN_TEXT_FILE
		do
			l_path := autodebug_config_path
			create l_file.make_with_path (l_path)
			save_to_file (l_file)
		end

feature{NONE} -- Load and save implementation

	load_from_file (a_file: PLAIN_TEXT_FILE)
			--
		require
			project /= Void
			a_file /= Void and then a_file.exists
		local
			l_line, l_head, l_value: STRING
			l_index: INTEGER
			l_parts: LIST [STRING]
			l_path: PATH
			l_dir: DIRECTORY
		do
			a_file.open_read
			if a_file.is_open_read then
				from
					a_file.read_line
				until
					a_file.end_of_file
				loop
					l_line := a_file.last_string
					l_index := l_line.index_of (':', 1)
					l_head := l_line.substring (1, l_index - 1)
					l_value:= l_line.substring (l_index + 1, l_line.count)

					if l_head ~ str_class_groups_to_debug then
						add_groups_to_debug_from_string (l_value)
					elseif l_head ~ str_working_directory then
						create l_path.make_from_string (l_value)
						create l_dir.make_with_path (l_path)
						if not l_dir.exists then
							l_dir.recursive_create_dir
						end
						if l_dir.exists then
							set_working_directory (create {ES_ADB_WORKING_DIRECTORY}.make (l_path))
						else
							set_working_directory (create {ES_ADB_WORKING_DIRECTORY}.make (default_working_directory))
						end
					elseif l_head ~ str_each_session_tests then
						if l_value.is_integer and then is_valid_testing_session_type (l_value.to_integer) then
							set_testing_session_type (l_value.to_integer)
						end
					elseif l_head ~ str_max_session_length_for_testing then
						if l_value.is_integer and then is_valid_max_session_length (l_value.to_integer) then
							set_max_session_length_for_testing (l_value.to_integer)
						end
					elseif l_head ~ str_should_usg_fixed_seed_in_testing then
						if l_value.is_boolean then
							set_use_fixed_seed_in_testing (l_value.to_boolean)
						end
					elseif l_head ~ str_fixed_seed then
						if l_value.is_integer then
							set_fixed_seed (l_value.to_integer)
						end
					elseif l_head ~ str_max_session_length_for_fixing then
						if l_value.is_integer and then is_valid_max_session_length (l_value.to_integer) then
							set_max_session_length_for_fixing (l_value.to_integer)
						end
					elseif l_head ~ str_max_nbr_fix_candidates then
						if l_value.is_integer and then is_valid_max_nbr_fix_candidates (l_value.to_integer) then
							set_max_nbr_fix_candidates (l_value.to_integer)
						end
					elseif l_head ~ str_should_fix_implementation then
						if l_value.is_boolean then
							set_fix_implementation (l_value.to_boolean)
						end
					elseif l_head ~ str_should_fix_contracts then
						if l_value.is_boolean then
							set_fix_contracts (l_value.to_boolean)
						end
					elseif l_head ~ str_max_nbr_passing_tests then
						if l_value.is_integer and then is_valid_max_nbr_tests (l_value.to_integer) then
							set_max_nbr_passing_tests (l_value.to_integer)
						end
					elseif l_head ~ str_max_nbr_failing_tests then
						if l_value.is_integer and then is_valid_max_nbr_tests (l_value.to_integer) then
							set_max_nbr_failing_tests (l_value.to_integer)
						end
					elseif l_head ~ str_should_show_implementation_fixable then
						if l_value.is_boolean then
							set_show_implementation_fixable (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_contract_fixable then
						if l_value.is_boolean then
							set_show_contract_fixable (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_not_fixable then
						if l_value.is_boolean then
							set_show_not_fixable (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_not_yet_attempted then
						if l_value.is_boolean then
							set_show_not_yet_attempted (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_candidate_fix_availabe then
						if l_value.is_boolean then
							set_show_candidate_fix_available (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_candidate_fix_unavailable then
						if l_value.is_boolean then
							set_show_candidate_fix_unavailable (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_candidate_fix_accepted then
						if l_value.is_boolean then
							set_show_candidate_fix_accepted (l_value.to_boolean)
						end
					elseif l_head ~ str_should_show_manually_fixed then
						if l_value.is_boolean then
							set_show_manually_fixed (l_value.to_boolean)
						end
					end

					a_file.read_line
				end
				a_file.close
			end
		end

	save_to_file (a_file: PLAIN_TEXT_FILE)
		require
			project /= Void
			a_file /= Void
		local
			l_content: STRING
		do
			a_file.open_write
			if a_file.is_open_write then
				create l_content.make (1024)
				l_content.append (str_class_groups_to_debug)
				l_content.append_character (key_value_separator)
				l_content.append (groups_to_debug_to_str)
				l_content.append_character ('%N')

				l_content.append (str_working_directory)
				l_content.append_character (key_value_separator)
				l_content.append (working_directory.root_dir.out)
				l_content.append_character ('%N')

				l_content.append (str_each_session_tests)
				l_content.append_character (key_value_separator)
				l_content.append (testing_session_type.out)
				l_content.append_character ('%N')

				l_content.append (str_max_session_length_for_testing)
				l_content.append_character (key_value_separator)
				l_content.append (max_session_length_for_testing.out)
				l_content.append_character ('%N')

				l_content.append (str_should_usg_fixed_seed_in_testing)
				l_content.append_character (key_value_separator)
				l_content.append (should_use_fixed_seed_in_testing.out)
				l_content.append_character ('%N')

				l_content.append (str_fixed_seed)
				l_content.append_character (key_value_separator)
				l_content.append (fixed_seed.out)
				l_content.append_character ('%N')

				l_content.append (str_max_session_length_for_fixing)
				l_content.append_character (key_value_separator)
				l_content.append (max_session_length_for_fixing.out)
				l_content.append_character ('%N')

				l_content.append (str_max_nbr_fix_candidates)
				l_content.append_character (key_value_separator)
				l_content.append (max_nbr_fix_candidates.out)
				l_content.append_character ('%N')

				l_content.append (str_should_fix_implementation)
				l_content.append_character (key_value_separator)
				l_content.append (should_fix_implementation.out)
				l_content.append_character ('%N')

				l_content.append (str_should_fix_contracts)
				l_content.append_character (key_value_separator)
				l_content.append (should_fix_contracts.out)
				l_content.append_character ('%N')

				l_content.append (str_max_nbr_passing_tests)
				l_content.append_character (key_value_separator)
				l_content.append (max_nbr_passing_tests.out)
				l_content.append_character ('%N')

				l_content.append (str_max_nbr_failing_tests)
				l_content.append_character (key_value_separator)
				l_content.append (max_nbr_failing_tests.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_implementation_fixable)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_implementation_fixable.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_contract_fixable)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_contract_fixable.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_not_fixable)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_not_fixable.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_not_yet_attempted)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_not_yet_attempted.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_candidate_fix_availabe)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_candidate_fix_available.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_candidate_fix_unavailable)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_candidate_fix_unavailable.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_candidate_fix_accepted)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_candidate_fix_accepted.out)
				l_content.append_character ('%N')

				l_content.append (str_should_show_manually_fixed)
				l_content.append_character (key_value_separator)
				l_content.append (should_show_manually_fixed.out)
				l_content.append_character ('%N')

				a_file.put_string (l_content)
				a_file.close
			end
		end

feature{NONE} -- String representation

	add_groups_to_debug_from_string (a_str: STRING)
			-- Added classes, whose name appears in `a_str', to `classes_to_debug'.
			-- Ignoring the invalid class names.
		require
			project /= Void
			a_str /= Void
		local
			l_str: STRING
			l_list: LIST [STRING]
			l_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
			l_class: CLASS_C
			l_name: STRING
		do
			l_str := a_str.twin
			l_str.prune_all (' ')
			l_str.prune_all ('%T')
			l_list := l_str.split (group_separator)

			from
				l_cursor := l_list.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_name := l_cursor.item
				if not l_name.is_empty and then not class_groups.has (l_name) then
					class_groups.force_last (l_name)
					groups_to_classes.force (classes_in_group (l_name), l_name)
					all_classes_internal := Void
					all_class_names_internal := Void
				end

				l_cursor.forth
			end
		end

	groups_to_debug_to_str: STRING
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
		do
			create Result.make (128)
			from
				l_cursor := class_groups.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not Result.is_empty then
					Result.append_character (group_separator)
				end
				Result.append (l_cursor.item)

				l_cursor.forth
			end
		end

feature -- Constant

	str_class_groups_to_debug: STRING = "class.groups.to.debug"
	str_working_directory: STRING = "working.directory"
	str_each_session_tests: STRING = "each.session.tests"
	str_each_session_tests_one_class: STRING = "one.class"
	str_each_session_tests_one_group: STRING = "one.group"
	str_each_session_tests_all_classes: STRING = "all.classes"
	str_max_session_length_for_testing: STRING = "max.session.length.for.testing"
	str_should_usg_fixed_seed_in_testing: STRING = "should.use.fixed.seed.in.testing"
	str_fixed_seed: STRING = "fixed.seed"
	str_max_session_length_for_fixing: STRING = "max.session.length.for.fixing"
	str_max_nbr_fix_candidates: STRING = "max.nbr.fix.candidates"
	str_should_fix_implementation: STRING = "should.fix.implementation"
	str_should_fix_contracts: STRING = "should.fix.contracts"
	str_max_nbr_passing_tests: STRING = "max.nbr.passing.tests"
	str_max_nbr_failing_tests: STRING = "max.nbr.failing.tests"
	str_should_show_implementation_fixable: STRING = "should.show.implementation.fixable"
	str_should_show_contract_fixable: STRING = "should.show.contract.fixable"
	str_should_show_not_fixable: STRING = "should.show.not.fixable"
	str_should_show_not_yet_attempted: STRING = "should.show.not.yet.attempted"
	str_should_show_candidate_fix_availabe: STRING = "should.show.candidate.fix.available"
	str_should_show_candidate_fix_unavailable: STRING = "should.show.candidate.fix.unavailable"
	str_should_show_candidate_fix_accepted: STRING = "should.show.candidate.fix.accepted"
	str_should_show_manually_fixed: STRING = "should.show.manually.fixed"

	Testing_session_type_one_class: INTEGER = 1
	Testing_session_type_one_group: INTEGER = 2
	Testing_session_type_all_classes: INTEGER = 3

	key_value_separator: CHARACTER = ':'
	group_separator: CHARACTER = ';'
	group_member_separator: CHARACTER = ','
	group_member_type_value_separator: CHARACTER = ':'

	default_testing_session_type: INTEGER = 2
	default_max_session_length_for_testing: INTEGER = 10
	default_should_use_fixed_seed_in_testing: BOOLEAN = False
	default_fixed_seed: INTEGER = 0
	default_max_session_length_for_fixing: INTEGER = 10
	default_max_nbr_fix_candidates: INTEGER = 10
	default_should_fix_implementation: BOOLEAN = True
	default_should_fix_contracts: BOOLEAN = True
	default_max_nbr_passing_tests: INTEGER = 30
	default_max_nbr_failing_tests: INTEGER = 20
	default_should_show_implementation_fixable: BOOLEAN = True
	default_should_show_contract_fixable: BOOLEAN = True
	default_should_show_not_fixable: BOOLEAN = True
	default_should_show_not_yet_attempted: BOOLEAN = True
	default_should_show_candidate_fix_available: BOOLEAN = True
	default_should_show_candidate_fix_unavailable: BOOLEAN = True
	default_should_show_candidate_fix_accepted: BOOLEAN = True
	default_should_show_manually_fixed: BOOLEAN = True

	Max_session_length_for_relaxed_testing: INTEGER = 5
	Max_session_overhead_length: INTEGER = 5


feature{NONE} -- Internal

	working_directory_internal: like working_directory
	class_groups_internal: like class_groups
	groups_to_classes_internal: like groups_to_classes
	all_classes_internal: like all_classes
	all_class_names_internal: like all_class_names


;
note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
