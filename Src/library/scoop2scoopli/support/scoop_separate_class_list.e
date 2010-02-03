note
	description: "Representation of SCOOP classes within a list."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE_CLASS_LIST

create
	make

feature -- Initialisation

	make
			-- Initialise
		do
			create class_list.make
		end

feature -- List access

	has_class (a_class: CLASS_C): BOOLEAN is
			-- Does `a_class' appear in the list?
		do
			Result := class_list.has (a_class)
		end

	has (a_class_name: STRING): BOOLEAN is
			-- Does a class with name `a_class_name' appear in the list?
		local
			i: INTEGER
			exist: BOOLEAN
		do
			exist := False
			from i := 1 until i > class_list.count loop
				if class_list.i_th (i).name_in_upper.is_equal (a_class_name) then
					exist := True
				end
				i := i + 1
			end

			Result := exist
		end

	extend (a_class: CLASS_C) is
			-- Add `a_class' to the list.
		do
			if not has (a_class.name_in_upper) then
				class_list.extend (a_class)
			end
		end

	is_empty: BOOLEAN is
			-- Is the list empty?
		do
			if class_list.count > 0 then
				Result := False
			else
				Result := True
			end
		end

	count: INTEGER is
			-- The number of elements in the list.
		do
			Result := class_list.count
		end

feature -- Element access

	first: CLASS_C is
			-- The first element of the list.
		do
			Result := class_list.first
		end

	item (i: INTEGER): CLASS_C is
			-- The `i'-th element of the list
		require
			valid_i: i > 0 and i <= count
		do
			Result := class_list.i_th (i)
		end

	remove_first is
			-- Delete the first element.
		do
			class_list.start
			class_list.remove
		end

feature -- Debug

	print_all is
			-- Debug: Print all items of the list.
		local
			i: INTEGER
		do
			from i := 1 until i > class_list.count loop
				io.put_string (" - " + class_list.i_th (i).name_in_upper)
				io.put_new_line
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	class_list: LINKED_LIST [CLASS_C]
			-- The class list.

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

end -- class SCOOP_SEPARATE_CLASS_LIST
