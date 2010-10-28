note
	description: "Use this rule if there is a new attribute."
	author: "Matthias Loeu, Marco Piccioni"
	date: "12.01.09"

class
	CONVERTER_RULE_NEW

inherit
	CONVERTER_RULE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization
	make(n: STRING)
			-- Initialize `Current'.
		do
			Precursor (n)
			create default_values.make (10)
			default_values.put ("", "STRING")
			default_values.put ("0", "INTEGER")
			default_values.put ("0.0", "REAL")
			default_values.put ("0.0", "DOUBLE")
		end

feature -- Access
	rule: STRING
			--
		local
			d: STRING
		do
			if default_values.has (new_type) then
				d := default_values.item (new_type)
			else
				d:="Void"
			end

			Result := tabs_d + "Result.force (tmp.variable_constant ("+d+"), %""+name+"%")"
			process:=message.constant_set(name,new_type,d)
		end


feature {NONE} -- Implementation
	first_comment: STRING
			--
		do
			Result := "New attribute of type " + new_type
		end

	default_values: HASH_TABLE[STRING, STRING]
			-- the default values

invariant
	-- Insert invariant here
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
