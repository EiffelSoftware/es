note
	description: "[
					Roundtrip visitor to evaluate separateness of a class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE_CLASS_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as
		end
		
	SHARED_SCOOP_WORKBENCH

create
	make_with_separate_class_list

feature -- Initialisation

	make_with_separate_class_list(a_class_list: SCOOP_SEPARATE_CLASS_LIST)
			-- Initialise and reset flags
		require
			a_class_list_not_void: a_class_list /= Void
		do
			needed_classes := a_class_list
		end

feature -- Access

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			Precursor (l_as)

				-- case 2)
			if l_as.is_separate then
				add_class_to_list (l_as.class_name.name.as_upper)
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			Precursor (l_as)

				-- case 2)
			if l_as.is_separate then
				add_class_to_list (l_as.class_name.name.as_upper)
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			Precursor (l_as)

				-- case 2)
			if l_as.is_separate then
				add_class_to_list (l_as.class_name.name.as_upper)
			end
		end

feature {NONE} -- Implementation

	add_class_to_list (a_class_name: STRING) is
			-- adds a class to the neede_classes list if not already done.
		local
			a_class: CLASS_C
		do
			if not needed_classes.has (a_class_name) then
				a_class := get_class_by_name (a_class_name)
				if a_class /= Void then
					needed_classes.extend (a_class)
					io.put_string ("### C2 - Class " + a_class_name + " ###%N")
				end
			end
		end

	get_class_by_name (a_class_name: STRING): CLASS_C is
			-- gets class by class_name
		local
			i: INTEGER
			found_class: CLASS_C
		do
			found_class := void
			from i := 1 until i > system.classes.count loop
				if system.classes.item (i) /= Void and then
				   system.classes.item (i).name_in_upper.is_equal (a_class_name) then

					Result := system.classes.item (i)
				end
				i := i + 1
			end

			Result := found_class
		end

	needed_classes: SCOOP_SEPARATE_CLASS_LIST
		-- classes which needs client and proxy classes.

invariant
	invariant_clause: True -- Your invariant here

note
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

end -- class SCOOP_SEPARATE_CLASS_VISITOR
