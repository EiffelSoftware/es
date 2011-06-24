note
	description: "Summary description for {EB_GROUPS_GRID_CLASS_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_GROUPS_GRID_CLASS_ITEM

inherit
	EB_GROUPS_GRID_ITEM
		redefine
			data,
			set_data,
			stone
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_I; a_name: STRING)
			-- Create a tree item representing class `a_class' with `a_name' in its context.
		require
			a_class_ok: a_class /= Void and then a_class.is_valid
			a_name_ok: a_name /= Void
		do
			default_create
			name := a_name
			set_data (a_class)
		ensure
			name_set: name = a_name
			data_set: data = a_class
		end

feature -- Status report

	data: CLASS_I
			-- Class represented by `Current'.

	name: STRING
			-- Renamed name in the context of this item in the classes tree.

	stone: CLASSI_STONE
			-- Class stone representing `Current', can be a classi_stone or a classc_stone.
		local
			l_classc: CLASS_C
		do
			l_classc := data.compiled_representation
			if l_classc /= Void then
				create {CLASSC_STONE} Result.make (l_classc)
			else
				create {CLASSI_STONE} Result.make (data)
			end
		end

feature -- Status setting

	set_data (a_class: CLASS_I)
			-- Change the associated class to `a_class'.
		do
			set_text (name)
			data := a_class
			set_tooltip (name)
			set_pixmap (pixmap_from_class_i (a_class))
		end

	load_overriden_children
			-- Add classes this class overrides or the class that overrides this class as children.
			-- (needs to be called after the class has been completely set up)
		do

		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
