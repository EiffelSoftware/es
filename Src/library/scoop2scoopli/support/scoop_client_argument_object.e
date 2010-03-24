note
	description: "Representation of an argument list."
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
			-- Initialize argument object
		do
			create separate_arguments.make
			create non_separate_arguments.make
			create separate_argument_counter.make

--			has_counted_separate_arguments := False
		end

feature -- Access
--	has_separate_arguments: BOOLEAN
--			-- Are there separate arguments?
--		do
--			Result := separate_arguments.count > 0
--		end

	is_argument (a_feature_name: STRING): BOOLEAN
			-- Is `a_feature_name' an argument?
		require
			a_feature_name_is_not_void: a_feature_name /= Void
		do
			Result := is_non_separate_argument (a_feature_name) or is_separate_argument (a_feature_name)
		end

	is_non_separate_argument (a_name: STRING): BOOLEAN
			-- Is `a_name' a non separate argument?
		require
			a_name_is_valid: a_name /= Void
		local
			i, j: INTEGER
			l_found: BOOLEAN
		do
			l_found := False
			from
				i := 1
			until
				i > non_separate_arguments.count
			loop
				from
					j := 1
				until
					j > non_separate_arguments.i_th (i).id_list.count
				loop
					if non_separate_arguments.i_th (i).item_name (j).is_equal (a_name) then
						l_found := True
					end
					j := j + 1
				end
				i := i + 1
			end

			Result := l_found
		end

	is_separate_argument (a_name: STRING): BOOLEAN
			-- Is `a_name' a separate argument?
		require
			a_name_is_valid: a_name /= Void
		local
			i, j: INTEGER
			l_found: BOOLEAN
		do
			l_found := False
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
						l_found := True
					end
					j := j + 1
				end
				i := i + 1
			end

			Result := l_found
		end

	argument_by_name (a_name: STRING): TYPE_DEC_AS
			-- Type declaration of `a_name'.
		require
			a_name_is_valid: a_name /= Void
		local
			i, j: INTEGER
		do
			if is_separate_argument (a_name) then
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
				from
					i := 1
				until
					i > non_separate_arguments.count
				loop
					from
						j := 1
					until
						j > non_separate_arguments.i_th (i).id_list.count
					loop
						if non_separate_arguments.i_th (i).item_name (j).is_equal (a_name) then
							Result := non_separate_arguments.i_th (i)
						end

						j := j + 1
					end
					i := i + 1
				end
			else
				-- The argument is not in the list.
				Result := Void
			end
		end

	type_by_name (a_name: STRING): TYPE_AS
			-- Type of `a_name'.
		require
			a_name_not_void: a_name /= Void
		local
			l_type_dec_as: TYPE_DEC_AS
		do
			l_type_dec_as := argument_by_name (a_name)
			if l_type_dec_as /= Void then
				Result := l_type_dec_as.type
			end
		end

	count_separate_argument (a_name: STRING)
			-- Increase the counter of the separate argument by one.
		local
			i, a_value: INTEGER
			found: BOOLEAN
			a_tuple: TUPLE[STRING, INTEGER]
		do
			if is_separate_argument (a_name) then
				found := False
				from
					i := 1
				until
					i > separate_argument_counter.count
				loop
					if separate_argument_counter.i_th (i).item (1).is_equal (a_name) then
						a_value := separate_argument_counter.i_th (i).integer_item (2) + 1
						separate_argument_counter.i_th (i).item (2) := a_value
						found := True
					end
					i := i + 1
				end
				if not found then
					-- extend the list with the new item
					a_tuple := [a_name, 1]
					separate_argument_counter.extend (a_tuple)
				end
					-- flag to indicate the existance of separate arguments in a postcondition
--				has_counted_separate_arguments := True
			end
		end

--	get_i_th_postcondition_argument_name (i: INTEGER): STRING
--			-- Name of the i_th counted postcondition argument.
--		local
--			a_tuple: TUPLE[a_name: STRING; a_count: INTEGER]
--		do
--			a_tuple := separate_argument_counter.i_th (i)
--			Result := a_tuple.a_name
--		end

--	get_i_th_postcondition_argument_count (i: INTEGER): INTEGER
--			-- Count of the i_th counted postcondition argument.
--		local
--			a_tuple: TUPLE[a_name: STRING; a_count: INTEGER]
--		do
--			a_tuple := separate_argument_counter.i_th (i)
--			Result := a_tuple.a_count
--		end

	argument_count (a_argument_name: STRING_8): INTEGER
			-- Counter of `a_argument_name'.
		local
			i: INTEGER
			l_found: BOOLEAN
		do
			l_found := False
			from
				i := 1
			until
				i > separate_argument_counter.count
			loop
				if separate_argument_counter.i_th (i).name.is_equal (a_argument_name) then
					Result := separate_argument_counter.i_th (i).number_of_occurences
					l_found := True
				end
				i := i + 1
			end
			if not l_found then
				Result := 0
			end
		end

	does_any_separate_argument_appear_in_postcondition: BOOLEAN
			-- Does the argument list contain separate arguments?
		do
			Result := not separate_argument_counter.is_empty
		end

--	has (a_name: STRING): BOOLEAN
--			-- Does the argument list contain `a_name'?
--		require
--			a_name_is_not_void: a_name /= Void
--		do
--			Result := is_non_separate_argument (a_name) or is_separate_argument (a_name)
--		end

	separate_arguments: LINKED_LIST[TYPE_DEC_AS]
			-- List of all separate arguments.

	non_separate_arguments: LINKED_LIST[TYPE_DEC_AS]
			-- List of all non separate arguments.

feature {NONE} -- Implementation
	separate_argument_counter: LINKED_LIST[TUPLE[name: STRING; number_of_occurences: INTEGER]]
			-- The number of times a formal argument occurs in the postcondition.

--	has_counted_separate_arguments: BOOLEAN
--			-- Are there any counted postconditions?

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

end -- class SCOOP_CLIENT_ARGUMENT_OBJECT
