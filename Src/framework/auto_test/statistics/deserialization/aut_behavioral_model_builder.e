note
	description: "Summary description for {AUT_BEHAVIORAL_MODEL_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_BEHAVIORAL_MODEL_BUILDER

inherit
	AUT_FILE_SYSTEM_ROUTINES
		rename make as old_make end

	AUT_TEST_CASE_DESERIALIZATION_OBSERVER

create
	make

feature -- Initiailization

	make (a_conf: TEST_GENERATOR)
			-- Initialization.
		require
			configuration_attached: a_conf /= Void
		do
			configuration := a_conf
		end

feature -- Data event handler

	on_deserialization_started
			-- <Precursor>
		do
			create last_models.make_equal (10)
			create last_faulty_features.make_equal (100)
		end

	on_test_case_deserialized (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- <Precursor>
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_feature_under_test: STRING
			l_model: EPA_BEHAVIORAL_MODEL
			l_retried: BOOLEAN
		do
			if not l_retried then
				if configuration.is_building_behavioral_models then
					l_class := a_data.class_
					l_feature := a_data.feature_
					if a_data.is_execution_successful then
						create l_feature_with_context.make (l_feature, l_class)
						if l_feature_with_context.is_argumentless_public_command then
							if last_models.has (l_class) then
								l_model := last_models.item (l_class)
							else
								create l_model.make (l_class)
								last_models.force (l_model, l_class)
							end
							l_model.merge (l_feature_with_context, a_data.pre_state, a_data.post_state)
							if not l_model.is_last_merge_successful then
								io.put_string ("Warning: Transition merge unsuccessful.%N")
							end
						end
					else
						l_feature_under_test := a_data.class_and_feature_under_test
						if not last_faulty_features.has(l_feature_under_test) then
							last_faulty_features.force (l_feature_under_test)
						end
					end
				end
			end
		rescue
			l_retried := True
			retry
		end

	on_deserialization_finished
			-- <Precursor>
		local
			l_file_name: FILE_NAME
			l_class: CLASS_C
			l_model: EPA_BEHAVIORAL_MODEL
		do
				-- Prepare the model directory.
			recursive_create_directory (model_directory_name)

			from last_models.start
			until last_models.after
			loop
				l_class := last_models.key_for_iteration
				l_model := last_models.item_for_iteration

				create l_file_name.make_from_string (model_directory_name)
				l_file_name.set_file_name (l_class.name_in_upper)
				l_file_name.add_extension ("txt")
				l_model.save_to (l_file_name)

				last_models.forth
			end

			save_faulty_feature_list
		end

feature -- Access

	configuration: TEST_GENERATOR
			-- Configuration.

	model_directory_name: FILE_NAME
			-- Directory to store the behavioral models.
		do
			Result := configuration.model_directory
		end

feature{NONE} -- Implementation

	save_faulty_feature_list
			-- Save `last_faulty_features' to disk.
		local
			l_file_name: FILE_NAME
			l_file: KL_TEXT_OUTPUT_FILE
			l_text_file: PLAIN_TEXT_FILE
			l_content: STRING
		do
			if configuration.is_building_faulty_feature_list then
				create l_content.make (1000)
				from last_faulty_features.start
				until last_faulty_features.after
				loop
					l_content := l_content + last_faulty_features.item_for_iteration + "%N"
					last_faulty_features.forth
				end

				l_file_name := configuration.faulty_feature_list_file_name
				create l_file.make (l_file_name)
				l_file.recursive_open_write
				if l_file.is_open_write then
					l_file.put_string (l_content)
					l_file.flush
					l_file.close
				end
			end
		end

feature{NONE} -- Access

	last_models: DS_HASH_TABLE [EPA_BEHAVIORAL_MODEL, CLASS_C]
			-- Behavioral models.

	last_faulty_features: EPA_HASH_SET[STRING]
			-- Set of faulty features.


;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
