note
	description: "Summary description for {EPA_STATE_TRANSITION_MODEL_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STATE_TRANSITION_MODEL_STATE

inherit

	EPA_STATE
		rename
			make as make_epa,
			make_from_object_state as make_epa_from_object_state,
			make_from_expression_value as make_epa_from_expression_value,
			make_from_string as make_epa_from_string
		redefine
			key_to_hash
		end

create
	make,
	make_from_object_state,
	make_from_expression_value,
	make_from_string

feature -- Initialization

	make (n: INTEGER_32; a_class: like class_; a_feature: like feature_; a_table: like var_table)
			-- <Precursor>
		do
			make_epa (n, a_class, a_feature)
			set_var_table (a_table)
		end

	make_from_object_state (a_state: HASH_TABLE [STRING_8, STRING_8]; a_class: like class_; a_feature: like feature_; a_table: like var_table)
			-- <Precursor>
		do
			make_epa_from_object_state (a_state, a_class, a_feature)
			set_var_table (a_table)
		end

	make_from_expression_value (a_exp_val: HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_AST_EXPRESSION]; a_class: like class_; a_feature: like feature_; a_table: like var_table)
			-- <Precursor>
		do
			make_epa_from_expression_value (a_exp_val, a_class, a_feature)
			set_var_table (a_table)
		end

	make_from_string (a_class: like class_; a_feature: like feature_; a_data: STRING_8; a_table: like var_table)
			-- <Precursor>
		do
			make_epa_from_string (a_class, a_feature, a_data)
			set_var_table (a_table)
		end

feature -- Access

	var_table: HASH_TABLE [TYPE_A, ITP_VARIABLE] assign set_var_table
			-- Variables used in the state, with their types.

feature{NONE} -- Setting

	set_var_table (a_table: like var_table)
			-- Set var table.
		local
			l_table: like var_table
		do
			from
				create var_table.make (a_table.count)
				l_table := var_table
				a_table.start
			until a_table.after
			loop
				l_table.put (a_table.item_for_iteration, a_table.key_for_iteration)
				a_table.forth
			end
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		do
			if attached {DS_ARRAYED_LIST[INTEGER]} Precursor as lt_list then
				lt_list.resize (count + var_table.count + 1)

				from var_table.start
				until var_table.after
				loop
					lt_list.force_last (var_table.item_for_iteration.hash_code)
					var_table.forth
				end

				Result := lt_list
			else
				check False end
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
