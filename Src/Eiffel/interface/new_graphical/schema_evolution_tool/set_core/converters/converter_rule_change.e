note
	description: "Rule used if the type of the attribute has changed."
	author: "Matthias Loeu, Teseo Schneider, Marco Piccioni"
	date: "09.04.09"

class
	CONVERTER_RULE_CHANGE

inherit
	CONVERTER_RULE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (n: STRING)
			-- Initialize `Current'.
		do
			Precursor (n)
		end

feature -- Access

	rule: STRING
			--the rule
		do
			Result := ""
				--if the second type is a string simply call the out function
			if new_type.has_substring ("STRING") then
				Result := "%T%T%TResult.force (tmp.variable_changed_type (%"" + name + "%", agent tmp.to_string (?)), %""+name+"%")%N"
				process := message.conversion_to_string (name, old_type)
			elseif old_type.has_substring ("STRING") then
					--if the old value is a string try to cast into a primitive type
				if new_type.has_substring ("INTEGER") then
					Result := "%T%T%TResult.force (tmp.variable_changed_type (%"" + name + "%", agent tmp.to_integer (?)), %""+name+"%")%N"
					process := message.conversion_to_integer (name, old_type)
				elseif new_type.has_substring ("DOUBLE") then
					Result := "%T%T%TResult.force (tmp.variable_changed_type (%"" + name + "%", agent tmp.to_double (?)), %""+name+"%")%N"
					process := message.conversion_to_double (name, old_type)
				elseif new_type.has_substring ("BOOLEAN") then
					Result := "%T%T%TResult.force (tmp.variable_changed_type (%"" + name + "%", agent tmp.to_boolean (?)), %""+name+"%")%N"
					process := message.conversion_to_boolean (name, old_type)
				end
			else
				Result := "%T%T%T--impossible to convert the two types"
				process := message.conversion_impossible(name, old_type, new_type)
			end
		end

feature {NONE} -- Implementation

	first_comment: STRING
			-- The first comment that appears for this rule
		do
			Result := "Convert from " + old_type + " to " + new_type
		end

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
