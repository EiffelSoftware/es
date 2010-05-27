note
	description: "An instruction in dataflow-analysis used by method extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_DATAFLOW_INSTRUCTION
create
	make

feature {NONE} -- Creation

	make (a_id: like id; a_path: like path; a_previous_definitions: like definitions)
			-- Make with `a_id' and `a_path'
		do
			id := a_id
			last_contained_id := id
			first_contained_id := id
			path := a_path

			create {LINKED_LIST[STRING]}used_variables.make
			definitions := a_previous_definitions.twin
		end

feature -- Access

	path: AST_PATH
			-- Path of the instruction

	id: INTEGER
			-- Id of the instruction

	last_contained_id: INTEGER
			-- Id of the last subinstruction (e.g. in if-body)

	first_contained_id: INTEGER
			-- Id of the first subinstruction (e.g. in from-part of a loop)

	used_variables: LIST[STRING]
			-- Variables that we're used in this instruction

	definitions: HASH_TABLE[PAIR[INTEGER,INTEGER],STRING]
			-- Variable-definitions from the POV of this instruction

feature -- Operations

	set_last_contained_id (a_last_contained_id: like last_contained_id)
			-- Set `last_contained_id' to `a_last_contained_id'
		do
			last_contained_id := a_last_contained_id
		end

	set_first_contained_id (a_first_contained_id: like first_contained_id)
			-- Set `first_contained_id' to `a_first_contained_id'.
		do
			first_contained_id := a_first_contained_id
		end

	add_use (a_name: STRING)
			-- Add variable with `a_name' as used
		do
			used_variables.extend(a_name)
		end

	add_definition (a_var: STRING)
			-- Set `a_var' as defined in this instruction
		do
			definitions.force(create {PAIR[INTEGER,INTEGER]}.make(id,id), a_var)
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
