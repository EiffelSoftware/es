note
	description: "Summary description for {AUT_DETERMINISTIC_UNTRIED_SOURCE_OBJECT_STATE_INPUT_CREATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_DETERMINISTIC_UNTRIED_SOURCE_OBJECT_STATE_INPUT_CREATOR

	inherit

	AUT_DETERMINISTIC_INPUT_CREATOR
		rename
			make as make_random_input_creator
		redefine
			step
		end

creation
	make

feature {NONE} -- Initialization

	make (a_system: like system; an_interpreter: like interpreter; a_feature_table: like feature_table; a_feature_to_call: like feature_to_call; a_type: TYPE_A)
			-- Create new feature caller.
		require
			a_system_not_void: a_system /= Void
			a_interpreter_not_void: an_interpreter /= Void
			a_feature_table_attached: a_feature_table /= Void
			a_feature_to_call_attached: a_feature_to_call /= Void
			a_type_attached: a_type /= Void
		do
			make_random_input_creator (a_system, an_interpreter, a_feature_table)
			feature_to_call := a_feature_to_call
			types.force_first (a_type)
		ensure
			feature_to_call_set: feature_to_call = a_feature_to_call
			types_correct: types.count = 1 and types.first = a_type
		end

feature -- Access

	feature_to_call: FEATURE_I
			-- Feature to call

feature -- Execution

	step
		local
			receiver: ITP_VARIABLE
			l_untried_source_object_states: DS_ARRAYED_LIST[AUT_OBJECT_STATE]
		do
			l_untried_source_object_states := interpreter.object_state_table.untried_object_states (feature_to_call, types.first)
			if not l_untried_source_object_states.is_empty and then l_untried_source_object_states.first /= Void then
				receivers.force_first (interpreter.object_state_table.random_variable (l_untried_source_object_states.first, types.first))
				has_next_step := False
			else
				io.put_string ("My Own Random Step (Precursor)")
				Precursor
			end
		end

invariant

	feature_to_call_attached: feature_to_call /= Void

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
