note
	description: "Representation of a client assertion object."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_ASSERTION_OBJECT

create
	make

feature -- Initialisation

	make
			-- initializes the element
		do
			create separate_argument_counter.make

			debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
				-- only for debugging reasons interested in detailed call list
				create calls.make
			end
		end

feature -- Access

--	reset is
--			-- Reset some flags
--		do
--			is_containing_separate_calls := False
--			is_containing_non_separate_calls := False
--		end

	tagged_as: TAGGED_AS
			-- Reference to original tagged_as node

	set_tagged_as (a_tagged_as: TAGGED_AS)
			-- Set `a_tagged_as'.
		require
			a_tagged_as_not_void: a_tagged_as /= Void
		do
			tagged_as := a_tagged_as
		end

	set_is_containing_separate_calls (a_value: BOOLEAN)
			-- Set `is_containing_separate_calls'.
		do
			is_containing_separate_calls := a_value
		end

	set_is_containing_non_separate_calls (a_value: BOOLEAN)
			-- Set `is_containing_non_separate_calls'.
		do
			is_containing_non_separate_calls := a_value
		end

	set_is_containing_old_or_result (a_value: BOOLEAN)
			-- Set `is_containing_old_or_result'.
		do
			is_containing_old_or_result := a_value
		end

	set_is_containing_void (a_value: BOOLEAN)
			-- Set `is_containing_void'.
		do
			is_containing_void := a_value
		end

feature -- Debugging access

	non_separate_calls: STRING
			-- List of all non separate calls.
		do
			Result := print_calls_selective (False)
		end

	separate_calls: STRING
			-- List of all separate calls.
		do
			Result := print_calls_selective (True)
		end

	separate_argument_list_as_string (is_print_with_info: BOOLEAN): STRING
			-- List of all separate arguments.
		local
			a_list: STRING
			i: INTEGER
		do
			create a_list.make_empty
			if has_separate_arguments then
				a_list.append ("[")
				from
					i := 1
				until
					i > separate_argument_counter.count
				loop
					a_list.append (separate_argument_counter.i_th (i).name)
					if is_print_with_info then
						a_list.append (" (" + separate_argument_counter.i_th (i).occurrences_count.out + ")")
					end
					if i < separate_argument_counter.count then
						a_list.append (", ")
					end
					i := i + 1
				end
				a_list.append ("]")
				Result := a_list
			else
				Result := a_list
			end
		end


feature {NONE} -- Debugging implementation

	print_calls_selective (separate_state: BOOLEAN): STRING
			-- Print call list with separate state.
		local
			i: INTEGER
			l_str: STRING
			is_first: BOOLEAN
		do
			is_first := True
			create l_str.make_from_string ("[")
			from
				i := 1
			until
				i > calls.count
			loop
				if calls.i_th (i).is_separate = separate_state then
					if not is_first then
						l_str.append (",")
					end
					l_str.append (calls.i_th (i).call_name)
					is_first := False
				end
				i := i + 1
			end
			l_str.append ("]")

			if is_first then
				Result := "none"
			else
				Result := l_str
			end
		end

feature -- Implementation counter access
	count_separate_argument_occurrence (an_argument: STRING)
			-- Increase the separate argument occurrence counter by 1.
		local
			i: INTEGER
			found: BOOLEAN
			a_tuple: TUPLE[name: STRING; occurrences_count: INTEGER]
		do
			found := False
			from
				i := 1
			until
				i > separate_argument_counter.count
			loop
				if separate_argument_counter.i_th (i).name.is_equal (an_argument) then
					found := True
					separate_argument_counter.i_th (i).occurrences_count := separate_argument_counter.i_th (i).occurrences_count + 1
				end
				i := i + 1
			end
			if not found then
				create a_tuple
				a_tuple := [create {STRING}.make_from_string (an_argument), 1]
				separate_argument_counter.extend (a_tuple)
			end
		end

	separate_argument_occurrences_count (an_argument: STRING): INTEGER
			-- Number of occurrence of separate argument `an_argument' in the list.
		local
			i: INTEGER
			found: BOOLEAN
		do
			found := False
			from
				i := 1
			until
				i > separate_argument_counter.count
			loop
				if separate_argument_counter.i_th (i).name.is_equal (an_argument) then
					found := True
					Result := separate_argument_counter.i_th (i).occurrences_count
				end
				i := i + 1
			end
			if not found then
				Result := 0
			end
		end

	i_th_separate_argument_occurrences_count (a_position: INTEGER): TUPLE[name: STRING; occurrences_count: INTEGER]
			-- Separate argument on position `a_position'.
		require
			a_valid_position: a_position > 0 and a_position <= separate_arguments_count
		do
			if a_position <= separate_argument_counter.count then
				Result := separate_argument_counter.i_th (a_position)
			end
		end

	separate_arguments_count: INTEGER
			-- Number of arguments that occur in the assertion.
		do
			Result := separate_argument_counter.count
		end

	has_separate_arguments: BOOLEAN
			-- Does the assertion contains separate arguments?
		do
			Result := not separate_argument_counter.is_empty
		end

--	separate_argument_list: LINKED_LIST[TUPLE[argument_name: STRING; occurrence: INTEGER]] is
--			-- List of all separate arguments.
--		do
--			Result := separate_argument_counter
--		end

--	append_separate_argument_list (a_list: LINKED_LIST[TUPLE[argument_name: STRING; occurrence: INTEGER]]) is
--			-- Append separate argument list with the list given in the argument.
--		require
--			a_list_not_void: a_list /= Void
--		local
--			i: INTEGER
--		do
--			from
--				i := 1
--			until
--				i > a_list.count
--			loop
--				count_separate_argument_occurrence (a_list.i_th (i).argument_name, a_list.i_th (i).occurrence)
--				i := i + 1
--			end
--		end

feature -- Implementation with access

	calls: LINKED_LIST [TUPLE [call_name: STRING; is_separate: BOOLEAN]]
			-- Linked list of all calls within the assertion
			-- List ist just for debugging reasons -> 'SCOOP_CLIENT_ASSERTIONS_EXT'

	is_containing_separate_calls: BOOLEAN
			-- Are there separate calls within the assertion?

	is_containing_non_separate_calls: BOOLEAN
			-- Are there non separate calls within the assertions?

	is_containing_old_or_result: BOOLEAN
			-- Are there any `Result' or `old' keywords?

	is_containing_void: BOOLEAN
			-- Does the last expression contain the keyword `Void'?

feature {NONE} -- Implementation

	separate_argument_counter: LINKED_LIST[TUPLE[name: STRING; occurrences_count: INTEGER]]
			-- Separate argument list with related occurence counter.

;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_CLIENT_ASSERTION_OBJECT
