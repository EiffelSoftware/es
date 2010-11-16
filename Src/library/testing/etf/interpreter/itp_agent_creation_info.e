note
	description: "Class that represents how an agent object is created"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITP_AGENT_CREATION_INFO

create
	make

feature{NONE} -- Initialization

	make (a_agent_variable_id: INTEGER; a_feature_name: STRING; a_closed_operands: like closed_operands)
			-- Initialize Current.
		do
			agent_variable_id := a_agent_variable_id
			feature_name := a_feature_name
			closed_operands := a_closed_operands
		end

feature -- Access

	agent_variable_id: INTEGER
			-- Variable ID of the agent

	feature_name: STRING
			-- Name of the feature used in agent creation

	closed_operands: SPECIAL [INTEGER]
			-- List of closed operands for the agent
			-- The format is a list of integers, those integers are in pairs,
			-- in each pair, the first integer is the 0-based index of the closed
			-- operand, the second integer is the object ID of that operand:
			-- [operand_index1, object1, operand_index2, object2, ... , operand_index_n, object_n]

;note
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
