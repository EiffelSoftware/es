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
			l_settings: HASH_TABLE [PROCEDURE [ANY, TUPLE [STRING]], STRING]
			l_index: INTEGER
			l_name: STRING
			l_value: STRING
			l_str: STRING
		do
			initialize_property_settint_table
			l_pairs := a_config.split (',')
			create l_settings.make (l_pairs.count)
			if not l_pairs.is_empty then
				from
					l_pairs.start
				until
					l_pairs.after
				loop
					l_str := l_pairs.item
					l_index := l_str.index_of ('=', 1)
					if l_index > 0 then
						l_name := l_str.substring (1, l_index - 1)
						l_value := l_str.substring (l_index + 1, l_str.count)
						l_name.left_adjust
						l_name.right_adjust
						l_name.to_lower
						l_value.left_adjust
						l_value.right_adjust
						l_value.to_lower

						if property_setting_table.has (l_name) then
							property_setting_table.item (l_name).call ([l_value])
						end
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

feature{NONE} -- Config setting

	set_target_object_state_retrieval_property (a_value: STRING) is
			-- Set `is_target_object_state_retrieval_enabled' according to `a_value'.
		do
			if a_value.is_boolean then
				set_is_target_object_state_retrieval_enabled (a_value.to_boolean)
			end
		end

	set_argument_object_state_retrieval_property (a_value: STRING) is
			-- Set `is_argument_object_state_retrieval_enabled' according to `a_value'.
		do
			if a_value.is_boolean then
				set_is_argument_object_state_retrieval_enabled (a_value.to_boolean)
			end
		end

	set_query_result_object_state_retrieval_property (a_value: STRING) is
			-- Set `is_query_result_object_state_retrieval_enabled' according to `a_value'.
		do
			if a_value.is_boolean then
				set_is_query_result_object_state_retrieval_enabled (a_value.to_boolean)
			end
		end

	property_setting_table: HASH_TABLE [PROCEDURE [ANY, TUPLE [STRING]], STRING];
			-- Table for agents to set properties
			-- `[agent to set property, property name]

	initialize_property_settint_table is
			-- Initialize `property_setting_table'.
		do
			create property_setting_table.make (2)
			property_setting_table.put (agent set_target_object_state_retrieval_property, "target")
			property_setting_table.put (agent set_argument_object_state_retrieval_property, "argument")
			property_setting_table.put (agent set_query_result_object_state_retrieval_property, "result")
		ensure
			property_setting_table_attached: property_setting_table /= Void
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
