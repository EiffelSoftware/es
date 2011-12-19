note
	description: "Summary description for {AUT_BEHAVIORAL_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BEHAVIORAL_MODEL

inherit
	EPA_UTILITY

create
	make, make_from_file

feature -- Initialization

	make (a_class: CLASS_C)
			-- Initialization.
		require
			class_attached: a_class /= Void
		do
			class_ := a_class
			create model.make_equal (100)
		end

	make_from_file (a_file_name: FILE_NAME)
			-- Read the model from file `a_file_name'.
		require
			file_name_valid: a_file_name.is_valid
		local
			l_text_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_class_name, l_feature_name: STRING
			l_feature: FEATURE_I
			l_set: DS_HASH_SET [EPA_BEHAVIORAL_MODEL_TRANSITION]
			l_transition: EPA_BEHAVIORAL_MODEL_TRANSITION
		do
			create model.make_equal (10)

			create l_text_file.make_open_read (a_file_name)
			l_line := read_next_line (l_text_file)
			check l_line.starts_with ("<Class Name=") and then l_line.ends_with (">") then
				l_class_name := l_line.substring (l_line.index_of ('=', 1) + 1, l_line.index_of ('>', 1) - 1)
				class_ := first_class_starts_with_name (l_class_name)
				from
					l_line := read_next_line (l_text_file)
				until
					l_line ~ "</Class>"
				loop
					check l_line.starts_with ("<Command Name=") and then l_line.ends_with (">") then
						l_feature_name := l_line.substring (l_line.index_of ('=', 1) + 1, l_line.index_of ('>', 1) - 1)
						l_feature := class_.feature_named_32 (l_feature_name)
						create l_set.make_equal (128)
						from
							l_line := read_next_line (l_text_file)
						until
							l_line ~ "</Command>"
						loop
							l_line := l_line.substring (l_line.index_of ('>', 1) + 1, l_line.last_index_of ('<', l_line.count) - 1)
							create l_transition.make_from_string (l_line)
							l_set.force (l_transition)

							l_line := read_next_line (l_text_file)
						end
						model.force (l_set, l_feature)

						l_line := read_next_line (l_text_file)
					end
				end
			end
		end

feature -- Access

	class_: CLASS_C
			-- Class being modeled.

	model: DS_HASH_TABLE [DS_HASH_SET [EPA_BEHAVIORAL_MODEL_TRANSITION], FEATURE_I]
			-- Behavioral model of `class_'.

feature -- Update

	merge (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_pre_state, a_post_state: EPA_STATE)
			-- Merge a new transition into the model.
		require
			argumentless_public_command_feature: a_feature /= Void and then a_feature.is_argumentless_public_command
			states_attached: a_pre_state /= Void and then a_post_state /= Void
			same_class: a_pre_state.class_.class_id = a_post_state.class_.class_id
					and then a_pre_state.class_.class_id = class_.class_id
					and then a_pre_state.class_.class_id = a_feature.context_class.class_id
		local
			l_transition: EPA_BEHAVIORAL_MODEL_TRANSITION
			l_feature: FEATURE_I
			l_set: DS_HASH_SET [EPA_BEHAVIORAL_MODEL_TRANSITION]
		do
			is_last_merge_successful := False
			l_feature := a_feature.feature_
			create l_transition.make (a_feature, a_pre_state, a_post_state)
			if not l_transition.is_changeless then
					-- Merge the transition into model.
				if model.has (l_feature) then
					l_set := model.item (l_feature)
				else
					create l_set.make_equal (256)
					model.force (l_set, l_feature)
				end
				l_set.force (l_transition)
			end

			is_last_merge_successful := True
		end

feature -- Query

	command_usefulnesses (a_change_requirement: DS_HASH_TABLE [BOOLEAN, STRING]): DS_ARRAYED_LIST [TUPLE [cmd_name: STRING; usefulness: REAL]]
			-- Usefulness of the commands in terms of the (average) number of `a_change_requirement' they could achieve if invoked.
			-- `a_change_requirement': query name --> new value.
			-- `Result': commands and the (average) numbers of queries they can change.
		local
			l_set: DS_HASH_SET [EPA_BEHAVIORAL_MODEL_TRANSITION]
			l_feature: FEATURE_I
			l_transition: EPA_BEHAVIORAL_MODEL_TRANSITION
			l_usefulness: INTEGER
			l_pair: TUPLE[least: INTEGER; most: INTEGER]
		do
			create Result.make (model.count)

			from model.start
			until model.after
			loop
				l_feature := model.key_for_iteration
				l_set := model.item_for_iteration

				l_usefulness := 0
				from l_set.start
				until l_set.after
				loop
					l_transition := l_set.item_for_iteration

					l_usefulness := l_usefulness + l_transition.usefulness (a_change_requirement)

					l_set.forth
				end
				if not l_set.is_empty then
					Result.force_last ([l_feature.feature_name, (l_usefulness/l_set.count).truncated_to_real])
				end

				model.forth
			end
		end

feature -- Save to file

	save_to (a_file_name: FILE_NAME)
			-- Save the model to file `a_file_name'.
		require
			file_name_valid: a_file_name.is_valid
		local
			l_text_file: PLAIN_TEXT_FILE
			l_set: DS_HASH_SET [EPA_BEHAVIORAL_MODEL_TRANSITION]
			l_feature: FEATURE_I
		do
			create l_text_file.make_create_read_write (a_file_name)
			l_text_file.put_string ("<Class Name=" + class_.name_in_upper + ">%N")

			from model.start
			until model.after
			loop
				l_feature := model.key_for_iteration
				l_set := model.item_for_iteration

				l_text_file.put_string ("%T<Command Name=" + l_feature.feature_name_32 + ">%N")
				l_set.do_all (
					agent (a_trans: EPA_BEHAVIORAL_MODEL_TRANSITION; a_file: PLAIN_TEXT_FILE)
						do a_file.put_string ("%T%T<Transition>" + a_trans.out + "</Transition>%N") end (?, l_text_file)
				)
				l_text_file.put_string ("%T</Command>%N")

				model.forth
			end

			l_text_file.put_string ("</Class>%N")
			l_text_file.flush
			l_text_file.close
		end

feature -- State report

	is_last_merge_successful: BOOLEAN
			-- Is last merge successful?

feature{NONE} -- Implementation

	read_next_line (a_file: PLAIN_TEXT_FILE): STRING
			-- Read next line of `a_file', with '%T's pruned.
		do
			if not a_file.after then
				a_file.read_line
				Result := a_file.last_string
				Result.prune_all ('%T')
			end
		end


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
