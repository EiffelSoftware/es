note
	description: "Summary description for {AUT_OBJECT_STATE_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_CONFIG

create
	make_with_string

feature{NONE} -- Initialization

	make_with_string (a_config: STRING) is
			-- Initialize Current with configuration defined in `config'.
		require
			a_config_attached: a_config /= Void
		local
			l_pairs: LIST [STRING]
			l_str: STRING
		do
			l_pairs := a_config.split (',')
			if not l_pairs.is_empty then
				from
					l_pairs.start
				until
					l_pairs.after
				loop
					l_str := l_pairs.item
					if l_str.is_case_insensitive_equal (once "target") then
						set_is_target_object_state_retrieval_enabled (True)

					elseif l_str.is_case_insensitive_equal (once "argument") then
						set_is_argument_object_state_retrieval_enabled (True)

					elseif l_str.is_case_insensitive_equal (once "result") then
						set_is_query_result_object_state_retrieval_enabled (True)
					end
					l_pairs.forth
				end
			end
		end

feature -- Access

	is_target_object_state_retrieval_enabled: BOOLEAN
			-- Is object state retrieval enabled?

	is_argument_object_state_retrieval_enabled: BOOLEAN
			-- Should state of argument object be retrieved?

	is_query_result_object_state_retrieval_enabled: BOOLEAN
			-- Should state of object returned as feature call be retrieved?

feature -- Setting

	set_is_target_object_state_retrieval_enabled (b: BOOLEAN) is
			-- Set `is_target_object_state_retrieval_enabled' with `b'.
		do
			is_target_object_state_retrieval_enabled := b
		ensure
			is_target_object_state_retrieval_enabled_set: is_target_object_state_retrieval_enabled = b
		end

	set_is_argument_object_state_retrieval_enabled (b: BOOLEAN) is
			-- Set `is_argument_object_state_retrieval_enabled' with `b'.
		do
			is_argument_object_state_retrieval_enabled := b
		ensure
			is_argument_object_state_retrieval_enabled_set: is_argument_object_state_retrieval_enabled = b
		end

	set_is_query_result_object_state_retrieval_enabled (b: BOOLEAN) is
			-- Set `is_query_result_object_state_retrieval_enabled' with `b'.
		do
			is_query_result_object_state_retrieval_enabled := b
		ensure
			is_query_result_object_state_retrieval_enabled_set: is_query_result_object_state_retrieval_enabled = b
		end

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
