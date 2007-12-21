indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_ROUTINES

inherit

	CDD_CONSTANTS

feature {NONE} -- Implementation

	is_live_test_class (a_class: EIFFEL_CLASS_C; a_target: CONF_TARGET): BOOLEAN is
			-- Is the test class `a_class' referenced in target `a_target'?
			-- Note: We assume that a test class is only ever referenced by class
			-- CDD_INTERPRETER.
		require
			a_class_not_void: a_class /= Void
			a_class_is_test_class: a_class.is_test_class
			a_target_not_void: a_target /= Void
		local
			cluster: CLUSTER_I
			path: STRING
			file: KL_TEXT_INPUT_FILE
			regexp: RX_PCRE_REGULAR_EXPRESSION
		do
			if a_target.is_cdd_target then
				cluster := a_class.cluster
				path := cluster.location.build_path ("", "cdd_interpreter.e")
				create file.make (path)
				file.open_read
				if file.is_open_read then
					create regexp.make
					regexp.compile ("Result := create {" + a_class.name_in_upper + "}")
					from
						file.read_line
					until
						file.end_of_file or Result
					loop
						if regexp.matches (file.last_string) then
							Result := True
						else
							file.read_line
						end
					end
					file.close
				end
			else
				-- Test class must not be live in systems other than
				-- the interpreter. (TODO: What happens when we are fg
				-- debugging a test case?)
			end
		end

-- TODO: remove
--	cdd_interpreter_class (a_system: SYSTEM_I): EIFFEL_CLASS_C is
--			-- EIFFEL_CLASS_C object for class CDD_INTERPRETER if already available in `a_system'
--		require
--			a_system_not_void: a_system /= Void
--		local
--			i: INTEGER
--			classes:
--		do
--			from
--				i := a_system.lower
--			until
--				i > a_system.upper
--			loop
--				i := i + 1
--			end
--		end

	is_creation_feature (a_feature: E_FEATURE): BOOLEAN is
			--
		require
			a_feature_not_void: a_feature /= Void
		local
			l_class: CLASS_C
		do
			l_class := a_feature.associated_class
			Result := l_class.creation_feature = a_feature.associated_feature_i
			if not Result then
				Result := l_class.creators /= Void and then l_class.creators.has (a_feature.name)
			end
		end

	is_valid_status (an_application_status: APPLICATION_STATUS): BOOLEAN is
			-- Is 'an_application_status' valid for creating a test case?
		do
			Result := an_application_status.is_stopped and
					an_application_status.exception_occurred and
					(an_application_status.exception_code = {EXCEP_CONST}.void_call_target or
					an_application_status.exception_code = {EXCEP_CONST}.postcondition or
					an_application_status.exception_code = {EXCEP_CONST}.class_invariant or
					an_application_status.exception_code = {EXCEP_CONST}.precondition or
					an_application_status.exception_code = {EXCEP_CONST}.check_instruction)
		end

	tester_target_name (a_target: CONF_TARGET): STRING is
			-- Name of tester target for `a_target'
		do
			Result := a_target.name + tester_target_suffix
		ensure
			not_void: Result /= Void
		end

	is_extracted_test_class (a_class: EIFFEL_CLASS_C): BOOLEAN is
			-- Does `a_class' represent an extracted test class?
		require
			a_class_not_void: a_class /= Void
		do
			Result := is_descendant_of_class (a_class, extracted_test_class_name)
		end

	is_manual_test_class (a_class: EIFFEL_CLASS_C): BOOLEAN is
			-- Does `a_class' represent a manual test class?
		require
			a_class_not_void: a_class /= Void
		do
			Result := is_descendant_of_class (a_class, manual_test_class_name)
		end

	is_descendant_of_class (a_class: CLASS_C; a_class_name: STRING): BOOLEAN is
			-- Is `a_class' a descendant of a class named `a_class_name'?
		require
			a_class_not_void: a_class /= Void
			a_class_name_not_void: a_class_name /= Void
			a_class_parents_not_void: a_class.parents /= Void
		local
			l_class_list: FIXED_LIST [CLASS_C]
		do
			l_class_list := a_class.parents_classes
			from
				l_class_list.start
			until
				l_class_list.after or Result
			loop
				if l_class_list.item.name.is_case_insensitive_equal (a_class_name) then
					Result := True
				elseif is_descendant_of_class (l_class_list.item, a_class_name) then
					Result := True
				else
					l_class_list.forth
				end
			end
		end

	test_routines_old (a_class: CLASS_C): DS_LINKED_LIST [STRING] is
			--
		obsolete
			"routines stored in test classes"
		require
			a_class_not_void: a_class /= Void
		local
			l_ft: FEATURE_TABLE
			l_name: STRING
		do
			l_ft := a_class.feature_table
			from
				l_ft.start
				create Result.make
			until
				l_ft.after
			loop
				l_name := l_ft.item_for_iteration.feature_name
				if l_name.count >= test_routine_prefix.count and then
					l_name.substring (1, test_routine_prefix.count).is_case_insensitive_equal (test_routine_prefix) then
					Result.put_last (l_name)
				end
				l_ft.forth
			end
		end

end
