note
	description: "AutoTest request to check states of an object"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_REQUEST

inherit
	AUT_REQUEST
		rename
			make as make_old
		end

create
	make

feature {NONE} -- Initialization

	make (a_system: like system; a_variable: like variable; a_type: like type)
			-- Create new request.
		require
			a_system_not_void: a_system /= Void
			a_variable_not_void: a_variable /= Void
		do
			make_old (a_system)
			variable := a_variable
			type := a_type
			create {LINKED_LIST [STRING]} query_names.make
		ensure
			system_set: system = a_system
			variable_set: variable = a_variable
			type_set: type = a_type
		end

feature -- Access

	variable: ITP_VARIABLE
			-- Variable that the type is aksed of

	type: TYPE_A
			-- Type of `variable'

	query_names: LIST [STRING]
			-- List of names of queries whose values are to be
			-- retrieved.
			-- The names are in lower case.

feature -- Setting

	set_queries (a_queries: LIST [FEATURE_I]) is
			-- Register queries in `a_queries' whose values are
			-- to be retrieved in `query_results'.
		require
			a_queries_attached: a_queries /= Void
		do
			query_names.wipe_out
			from
				a_queries.start
			until
				a_queries.after
			loop
				query_names.extend (a_queries.item.feature_name.as_lower)
				a_queries.forth
			end
		end

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_object_state_request (Current)
		end

feature{NONE} -- Implmenetation

	initial_table_capacity: INTEGER
			-- Initial capacity for `query_results'

invariant
	variable_not_void: variable /= Void
	query_names_attached: query_names /= Void

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
