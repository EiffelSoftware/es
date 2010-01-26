note
	description: "Summary description for {SCOOP_CLIENT_ARGUMENT_OBJECT}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_ARGUMENT_OBJECT

create
	make

feature -- Initialisation

	make
			-- Initialisation of the argument object
		do
			create separate_arguments.make
			create non_separate_argument_list.make
			create separate_argument_counter.make

			has_counted_separate_arguments := false
		end

feature -- Access

	has_separate_arguments: BOOLEAN is
			-- returns current state
		do
			if separate_arguments.count > 0 then
				Result := true
			else
				Result := false
			end
		end

	is_non_separate_argument (a_feature_name: STRING): BOOLEAN is
			-- returns true if non separate argument list contains the feature name
		require
			a_feature_name_is_not_void: a_feature_name /= Void
		local
			i, j: INTEGER
			found: BOOLEAN
		do
			found := false
			from
				i := 1
			until
				i > non_separate_argument_list.count
			loop
				from
					j := 1
				until
					j > non_separate_argument_list.i_th (i).id_list.count
				loop
					if non_separate_argument_list.i_th (i).item_name (j).is_equal (a_feature_name) then
						found := true
					end
					j := j + 1
				end
				i := i + 1
			end

			Result := found
		end

	is_separate_argument (a_name: STRING): BOOLEAN is
			-- returns true if separate argument list contains the feature name
		require
			a_name_is_not_void: a_name /= Void
		local
			i, j: INTEGER
			found: BOOLEAN
		do
			found := false
			from
				i := 1
			until
				i > separate_arguments.count
			loop
				from
					j := 1
				until
					j > separate_arguments.i_th (i).id_list.count
				loop
					if separate_arguments.i_th (i).item_name (j).is_equal (a_name) then
						found := true
					end
					j := j + 1
				end
				i := i + 1
			end

			Result := found
		end

	get_argument_by_name (a_name: STRING): TYPE_DEC_AS is
			-- returns the type declaration of the argument
		require
			a_name_not_void: a_name /= Void
		local
			i,j: 	INTEGER
		do
			if is_separate_argument (a_name) then
				-- return separate argument declaration
				from
					i := 1
				until
					i > separate_arguments.count
				loop
					from
						j := 1
					until
						j > separate_arguments.i_th (i).id_list.count
					loop
						if separate_arguments.i_th (i).item_name (j).is_equal (a_name) then
							Result := separate_arguments.i_th (i)
						end

						j := j + 1
					end

					i := i + 1
				end

			elseif is_non_separate_argument (a_name) then
				-- return non separate argument declaration
				from
					i := 1
				until
					i > non_separate_argument_list.count
				loop
					from
						j := 1
					until
						j > non_separate_argument_list.i_th (i).id_list.count
					loop
						if non_separate_argument_list.i_th (i).item_name (j).is_equal (a_name) then
							Result := non_separate_argument_list.i_th (i)
						end

						j := j + 1
					end

					i := i + 1
				end
			else
				-- argument is not in the list!
				Result := Void
			end
		end

	count_separate_argument (a_name: STRING) is
			-- increases the counter of the separate argument by one.
		local
			i, a_value: INTEGER
			found: BOOLEAN
			a_tuple: TUPLE[STRING, INTEGER]
		do
			if is_separate_argument (a_name) then
				found := false
				from
					i := 1
				until
					i > separate_argument_counter.count
				loop
					if separate_argument_counter.i_th (i).item (1).is_equal (a_name) then
						a_value := separate_argument_counter.i_th (i).integer_item (2) + 1
						separate_argument_counter.i_th (i).item (2) := a_value
						found := true
					end
					i := i + 1
				end
				if not found then
					-- extend the list with the new item
					a_tuple := [a_name, 1]
					separate_argument_counter.extend (a_tuple)
				end
					-- flag to indicate the existance of separate arguments in a postcondition
				has_counted_separate_arguments := true
			end
		end

	get_i_th_postcondition_argument_name (i: INTEGER): STRING is
			-- returns the name of the i_th counted postcondition argument
		local
			a_tuple: TUPLE[a_name: STRING; a_count: INTEGER]
		do
			a_tuple := separate_argument_counter.i_th (i)
			Result := a_tuple.a_name
		end

	get_i_th_postcondition_argument_count (i: INTEGER): INTEGER is
			-- returns the count of the i_th coutned postcondition argument
		local
			a_tuple: TUPLE[a_name: STRING; a_count: INTEGER]
		do
			a_tuple := separate_argument_counter.i_th (i)
			Result := a_tuple.a_count
		end

	get_argument_count (an_argument_name: STRING_8): INTEGER is
			-- returns the counter of the argument
		local
			i: INTEGER
			found: BOOLEAN
		do
			found := false
			from
				i := 1
			until
				i > separate_argument_counter.count
			loop
				if separate_argument_counter.i_th (i).item (1).is_equal (an_argument_name) then
					Result := separate_argument_counter.i_th (i).integer_item (2)
					found := true
				end
				i := i + 1
			end
			if not found then
				Result := 0
			end
		end

	has_postcondition_occurrence: BOOLEAN is
			-- returns 'has_counted_separate arguments
		do
			Result := has_counted_separate_arguments
		end

	has (a_name: STRING): BOOLEAN is
			-- returns true if an argument list contains `a_name'.
		require
			a_name_is_not_void: a_name /= Void
		do
			Result := is_non_separate_argument (a_name) or is_separate_argument (a_name)
		end

	get_type_by_name (a_name: STRING): TYPE_AS is
			-- returns the type of `a_name'.
		require
			a_name_not_void: a_name /= Void
		local
			l_type_dec_as: TYPE_DEC_AS
		do
			l_type_dec_as := get_argument_by_name (a_name)
			if l_type_dec_as /= Void then
				Result := l_type_dec_as.type
			end
		end

feature -- Access to lists

	separate_arguments: LINKED_LIST[TYPE_DEC_AS]
		-- list of all separate arguments

	non_separate_argument_list: LINKED_LIST[TYPE_DEC_AS]
		-- list of all non separate arguments

feature {NONE} -- Implementation

	separate_argument_counter: LINKED_LIST[TUPLE[STRING, INTEGER]]
		-- saves for separate arguments an integer value.

	has_counted_separate_arguments: BOOLEAN
		-- indicates the existance of counted postconditions.

;note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"


end -- class SCOOP_CLIENT_ARGUMENT_OBJECT
