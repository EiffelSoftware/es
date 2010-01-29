note
	description: "Represents a changed feature to be processed by ETR_CONTEXT_TRANSFORMER"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CT_CHANGED_FEATURE
create {ETR_BASIC_OPS}
	make

feature  -- Access

	old_type,new_type:CLASS_C
			-- Old and new associated class of the changed type

	feature_name:STRING
			-- Name of the target feature

feature {NONE} -- Creation

	make(a_name: like feature_name; an_old_type: like old_type; a_new_type: like new_type)
			-- make with `a_name', `an_old_type' and `a_new_type'
		do
			feature_name := a_name

			old_type := an_old_type
			new_type := a_new_type
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
