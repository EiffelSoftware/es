indexing
	description: "Class which stores the configuration of autotest."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_CONFIG_DATA

create -- | TODO: who is allowed to create this class?
	make

feature {EB_PREFERENCES} -- Initialization

	make (a_preferences: PREFERENCES) is
			-- Create
		require
			preferences_not_void: a_preferences /= Void
		do
			preferences := a_preferences
			initialize_preferences
		ensure
			preferences_not_void: preferences /= Void
		end


feature {EB_SHARED_PREFERENCES, AT_SETTINGS_DIALOG} -- Value

	project_name: STRING is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := project_name_preference.value
		end

	ace_file: STRING is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := ace_file_preference.value
		end

	ise_eiffel_path: STRING is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := ise_eiffel_path_preference.value
		end

	classes_to_test: ARRAY[STRING] is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := classes_to_test_preference.value
		end

	verbose: BOOLEAN is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := verbose_preference.value
		end

	just_test: BOOLEAN is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := just_test_preference.value
		end

	manual_testing: BOOLEAN is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := manual_testing_preference.value
		end

	auto_testing: BOOLEAN is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := auto_testing_preference.value
		end

	minimize: BOOLEAN is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := minimize_preference.value
		end

	define: BOOLEAN is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := define_preference.value
		end

	output_directory: STRING is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := output_directory_preference.value
		end

	-- not needed at the moment because it is always `/result/index.html'
	-- relative to `output_directory'
--	output_summary_link: STRING is
--			-- Show all callers (as opposed to local callers) in `callers' form
--		do
--			Result := output_summary_link_preference.value
--		end

	time_out: INTEGER is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := time_out_preference.value
		end

	auto_test_version: STRING is
			-- Show all callers (as opposed to local callers) in `callers' form
		do
			Result := auto_test_version_preference.value
		end


feature {AT_SETTINGS_DIALOG} -- setter functions, NOT in original

	set_project_name (name: STRING) is
			-- sets the name of the project
		do
			project_name_preference.set_value (name)
		ensure
			project_name_set: project_name_preference.value = name
		end

	set_ace_file (name: STRING) is
			-- sets the ace file of the project
		do
			ace_file_preference.set_value (name)
		ensure
			ace_file_set: ace_file_preference.value = name
		end

	set_ise_eiffel_path (name: STRING) is
			-- sets the ace file of the project
		do
			ise_eiffel_path_preference.set_value (name)
		ensure
			ise_eiffel_path_set: ise_eiffel_path_preference.value = name
		end

	set_classes_to_test (classes: ARRAY[STRING]) is
			-- sets classes to test to the passed value
		local
			valid_classes: ARRAY[STRING]
			i, j: INTEGER
		do
			-- copy non void entries
			create valid_classes.make (1, classes.capacity)
			from
				i := 1; j := 1
			until
				i > classes.capacity
			loop
				if (classes.item(i) /= Void) then
					valid_classes.put(classes.item(i), j)
					j := j+1
				end
				i := i+1
			end
			-- set classes of autotest
			if j>1 then
				classes_to_test_preference.set_value (valid_classes.subarray (1, j-1))
			else
				classes_to_test_preference.set_default_value ("")
				classes_to_test_preference.reset
			end
		ensure
			-- | TODO: implement postcondition(s) correctly
--			test_array_set: classes_to_test_preference.value = classes
		end

	set_verbose (a_bool: BOOLEAN) is
			-- turns verbose mode off or on
		do
			verbose_preference.set_value (a_bool)
		ensure
			verbose_set: verbose_preference.value = a_bool
		end

	set_just_test (a_bool: BOOLEAN) is
			-- turns just test on or off
		do
			just_test_preference.set_value (a_bool)
		ensure
			just_test_set: just_test_preference.value = a_bool
		end

	set_manual_testing (a_bool: BOOLEAN) is
			-- turns manual testing on or off
		do
			manual_testing_preference.set_value (a_bool)
		ensure
			manual_testing_set: manual_testing_preference.value = a_bool
		end

	set_auto_testing (a_bool: BOOLEAN) is
			-- turns auto testing on or off
		do
			auto_testing_preference.set_value (a_bool)
		ensure
			auto_testing_set: auto_testing_preference.value = a_bool
		end

	set_minimize (a_bool: BOOLEAN) is
			-- turns minimizing to on or off
		do
			minimize_preference.set_value (a_bool)
		ensure
			minimize_set: minimize_preference.value = a_bool
		end

	set_define (a_bool: BOOLEAN) is
			-- turns "xface stuff" on or off
		do
			define_preference.set_value (a_bool)
		ensure
			define_set: define_preference.value = a_bool
		end

	set_output_directory (name: STRING) is
			-- sets the output directory
		do
			output_directory_preference.set_value (name)
		ensure
			output_directory_set: output_directory_preference.value = name
		end

	-- not needed at the moment because it is always `/result/index.html'
	-- relative to `output_directory'
--	set_output_summary_link (name: STRING) is
--			-- sets the output link of the testing summary
--		do
--			output_summary_link_preference.set_value (name)
--		ensure
--			output_summary_link_set: output_summary_link_preference.value = name
--		end

	set_time_out (a_value: INTEGER) is
			-- sets the timeout
		do
			time_out_preference.set_value (a_value)
		ensure
			time_out_set: time_out_preference.value = a_value
		end

	set_auto_test_version (a_version: STRING) is
			-- sets version of autotest
		do
			auto_test_version_preference.set_value (a_version)
		ensure
			auto_test_version_set: auto_test_version_preference.value = a_version
		end


feature {NONE} -- Preference

	project_name_preference: STRING_PREFERENCE
		-- name of project to be tested

	ace_file_preference: STRING_PREFERENCE
		-- which ace file is used

	ise_eiffel_path_preference: STRING_PREFERENCE
		-- version of EiffelStudio is used to compile (empty means current)

	classes_to_test_preference: ARRAY_PREFERENCE
		-- array of classes to be tested

	verbose_preference: BOOLEAN_PREFERENCE
		-- should information about testing progress be displayed?

	just_test_preference: BOOLEAN_PREFERENCE
		-- should a previously generated interpreter be reused?

	manual_testing_preference: BOOLEAN_PREFERENCE
		-- manual testing enabled?

	auto_testing_preference: BOOLEAN_PREFERENCE
		-- automated testing strategy enabled?

	minimize_preference: BOOLEAN_PREFERENCE
		-- is automatic minimization of bug reproduction examples enabled?

	define_preference: BOOLEAN_PREFERENCE
		-- autotest option concerning xace and gobo!(?)

	output_directory_preference: STRING_PREFERENCE
		-- where should the output of autotest be saved

	-- not needed at the moment because it is always `/result/index.html'
	-- relative to `output_directory'
--	output_summary_link_preference: STRING_PREFERENCE
--		-- link to summary

	time_out_preference: INTEGER_PREFERENCE
		-- how long does autotest run in minutes

	auto_test_version_preference: STRING_PREFERENCE
		-- which auto test version is available


feature {NONE} -- Preference Strings

	project_name_string: STRING is "at.config.project_name"
	ace_file_string: STRING is "at.config.ace_file"
	ise_eiffel_path_string: STRING is "at.config.ise_eiffel_path"
	classes_to_test_string: STRING is "at.config.classes_to_test"
	verbose_string: STRING is "at.config.verbose"
	just_test_string: STRING is "at.config.just_test"
	manual_testing_string: STRING is "at.config.manual_testing"
	auto_testing_string: STRING is "at.config.auto_testing"
	minimize_string: STRING is "at.config.minimize"
	define_string: STRING is "at.config.define"
	output_directory_string:  STRING is "at.config.output_directory"
--	output_summary_link_string: STRING is "at.config.output_summary_link"
	time_out_string: STRING is "at.config.time_out"
	auto_test_version_string:  STRING is "at.config.auto_test_version"


feature {NONE} -- Implementation

	initialize_preferences is
			-- Initialize preference values.
		local
			l_manager: EC_PREFERENCE_MANAGER
		do
			create l_manager.make (preferences, "test")

			project_name_preference := l_manager.new_string_preference_value (l_manager, project_name_string, "Project")
			ace_file_preference := l_manager.new_string_preference_value (l_manager, ace_file_string, ".ace")
			ise_eiffel_path_preference := l_manager.new_string_preference_value (l_manager, ise_eiffel_path_string, "")
			classes_to_test_preference := l_manager.new_array_preference_value (l_manager, classes_to_test_string, <<>>)
			verbose_preference := l_manager.new_boolean_preference_value (l_manager, verbose_string, True)
			just_test_preference := l_manager.new_boolean_preference_value (l_manager, just_test_string, False)
			manual_testing_preference := l_manager.new_boolean_preference_value (l_manager, manual_testing_string, False)
			auto_testing_preference := l_manager.new_boolean_preference_value (l_manager, auto_testing_string, True)
			minimize_preference := l_manager.new_boolean_preference_value (l_manager, minimize_string, False)
			define_preference := l_manager.new_boolean_preference_value (l_manager, define_string, False)
			output_directory_preference := l_manager.new_string_preference_value (l_manager, output_directory_string, "")
	-- not needed at the moment because it is always `/result/index.html'
	-- relative to `output_directory'
--			output_summary_link_preference := l_manager.new_string_preference_value (l_manager, output_summary_link_string, "")
			time_out_preference := l_manager.new_integer_preference_value (l_manager, time_out_string, 15)
			auto_test_version_preference := l_manager.new_string_preference_value (l_manager, auto_test_version_string, "[unknown]")
		end


	preferences: PREFERENCES
			-- Preferences


invariant
	project_name_preference_not_void: project_name_preference /= Void
	ace_file_preference_not_void: ace_file_preference /= Void
	ise_eiffel_path_preference_not_void: ise_eiffel_path_preference /= Void
	classes_to_test_preference_not_void: classes_to_test_preference /= Void
	verbose_preference_not_void: verbose_preference /= Void
	just_test_preference_not_void: just_test_preference /= Void
	manual_testing_preference_not_void: manual_testing_preference /= Void
	auto_testing_preference_not_void: auto_testing_preference /= Void
	minimize_preference_not_void: minimize_preference /= Void
	define_preference_not_void: define_preference /= Void
	output_directory_preference_not_void: output_directory_preference /= Void
	-- not needed at the moment because it is always `/result/index.html'
	-- relative to `output_directory'
--	output_summary_link_preference_not_void: output_summary_link_preference /= Void
	time_out_preference_not_void: time_out_preference /= Void
	auto_test_version_preference_not_void: auto_test_version_preference /= Void


indexing
	copyright:	"Copyright (c) 2006, The AECCS Team"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			The AECCS Team
			Website: https://eiffelsoftware.origo.ethz.ch/index.php/AutoTest_Integration
		]"

end -- class AT_CONFIG_DATA
