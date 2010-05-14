note
	description: "Summary description for {AUT_OBJECT_STATE_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_RESPONSE

inherit
	AUT_NORMAL_RESPONSE
		rename
			make as old_make
		redefine
			process
		end

	AUT_SHARED_CONSTANTS

	EPA_UTILITY

	ITP_SHARED_CONSTANTS

create
	make,
	make_empty,
	make_from_normal_response

feature{NONE} -- Initialization

	make (a_results: like query_results)
			-- Initialize.
		do
			query_results := a_results
		end

	make_empty
			-- Initialize an empty `query_results'.
		do
			create query_results.make (0)
			query_results.compare_objects
		end

--	make (a_query_names: LIST [STRING]; a_values: detachable LIST [detachable STRING]; a_status: detachable LIST [BOOLEAN]) is
--			-- Initialize.
--		require
--			a_query_names_attached: a_query_names /= Void
--			a_values_a_status_valid:
--				(a_values /= Void implies a_status /= Void) and
--				(a_values /= Void and then a_status /= Void implies a_values.count = a_status.count and a_values.count = a_query_names.count)
--		local
--			l_count: INTEGER
--		do
--			raw_text := ""
--			if a_values /= Void then
--				l_count := a_values.count
--			end
--			create query_results.make (l_count)
--			query_results.compare_objects
--			if l_count > 0 then
--				from
--					a_values.start
--					a_status.start
--					a_query_names.start
--				until
--					a_values.after
--				loop
--						-- We only report those queries whose value have been retrieved.
--					if a_status.item then
--						query_results.force (a_values.item, a_query_names.item)
--					else
--						query_results.force (nonsensical_value, a_query_names.item)
--					end
--					a_values.forth
--					a_status.forth
--					a_query_names.forth
--				end
--			end
--		end

	make_from_normal_response (a_response: AUT_NORMAL_RESPONSE) is
			-- Initialize Current with `a_response'.
		require
			a_response_attached: a_response /= Void and then a_response.is_normal
		local
			l_lines: LIST [STRING]
			l_query: STRING
			l_value: STRING
			l_line: STRING
			l_query_name_prefix: STRING
			l_prefix_count: INTEGER
			l_prefix: STRING
			l_query_results: like query_results
			l_va: STRING
			l_pair: LIST [STRING]
		do
			raw_text := ""
			l_lines := a_response.text.split ('%N')
			l_query_name_prefix := object_state_query_prefix
			l_prefix_count := l_query_name_prefix.count

			create query_results.make (10)
			query_results.compare_objects
			from
				l_query_results := query_results
				l_lines.start
			until
				l_lines.after
			loop
				l_line := l_lines.item
				if not l_line.is_empty then
					l_prefix := l_line.substring (1, l_prefix_count)
					l_va := l_line.substring (l_prefix_count + 1, l_line.count)

					if l_prefix.is_equal (l_query_name_prefix) then
							-- We find a query name, store that.
						l_pair := string_slices (l_va, query_value_separator)
						check l_pair.count = 2 end

						create l_query.make_from_string (l_pair.first)
						l_query := l_pair.first
						l_value := l_pair.last
						l_value.replace_substring_all ("%%N", "%N")
						l_query_results.force (l_value, l_query)
					else
						check False end
					end
				end
				l_lines.forth
			end
		end

feature -- Access

	query_results: HASH_TABLE [STRING, STRING]
			-- Table to store results of queries
			-- Key is query name, value is the evaluated value of that query.

feature -- Process

	process (a_visitor: AUT_RESPONSE_VISITOR)
			-- Process `Current' using `a_visitor'.
		do
			a_visitor.process_object_state_response (Current)
		end

invariant
	query_results_attached: query_results /= Void

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
