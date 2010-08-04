note
	description: "[
					Representation of SCOOP proxy parent node settings.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_PARENT_OBJECT

create
	make

feature -- Initialization

	make (a_parent_name: STRING)
			-- Create a new proxy parent object.
		do
			set_parent_name (a_parent_name)
		end

feature -- Access

	parent_name: STRING
			-- Name of current parent object.

	set_parent_name (a_parent_name: STRING) is
			-- Set `parent_name'.
		require
			a_parent_name /= Void
		do
			parent_name := a_parent_name
		end

	parent_class_c: CLASS_C
			-- Reference to class C of current parent.

	set_parent_class_c (a_class_c: CLASS_C) is
			-- Set `parent_class_c'.
		require
			a_class_c_not_void: a_class_c /= Void
		do
			parent_class_c := a_class_c
		end

	set_parent_cursor (a_cursor: LINKED_LIST_CURSOR[STRING]) is
			-- Set `parent_cursor'.
		require
			a_cursor_not_void: a_cursor /= Void
		do
			parent_cursor := a_cursor
		end

	set_rename_cursor (a_cursor: LINKED_LIST_CURSOR[STRING]) is
			-- Set `rename_cursor'.
		require
			a_cursor_not_void: a_cursor /= Void
		do
			has_changes := True
			has_rename_clause := True
			rename_cursor := a_cursor
		end

	set_redefine_cursor (a_cursor: LINKED_LIST_CURSOR[STRING]) is
			-- Set `redefine_cursor'.
		require
			a_cursor_not_void: a_cursor /= Void
		do
			has_changes := True
			has_redefine_clause := True
			redefine_cursor := a_cursor
		end

feature -- Context change

	add_rename_clause (an_old_name, a_new_name: STRING; a_string_context: ROUNDTRIP_STRING_LIST_CONTEXT) is
			-- Insert a new rename clause in the context.
		local
			l_string: STRING
		do
			create l_string.make_empty

			-- add a rename keyword if there isnt one
			if not has_rename_clause then
				a_string_context.insert_after_cursor ("%N%T%Trename", parent_cursor)
				set_rename_cursor (a_string_context.cursor_to_current_position)
				has_rename_clause := True
			else
				l_string.append (",")
				has_rename_clause := True
			end

			-- the rename statement
			l_string.append ("%N%T%T%T" + an_old_name + " as " + a_new_name)
			a_string_context.insert_after_cursor (l_string, rename_cursor)
			set_rename_cursor (a_string_context.cursor_to_current_position)

			-- set the end keyword if needed
			if not has_changes then
					a_string_context.insert_after_cursor ("%N%T%Tend", rename_cursor)
				has_changes := True
			end

			-- move cursor to last position
			a_string_context.finish
		end

	add_redefine_clause (a_feature_name: STRING; a_string_context: ROUNDTRIP_STRING_LIST_CONTEXT) is
			-- Insert a new redefine clause in the context.
		local
			l_string: STRING
		do
			create l_string.make_empty

			-- add a redefine keyword if there isnt one
			if not has_redefine_clause then
				a_string_context.insert_after_cursor ("%N%T%Tredefine", parent_cursor)
				set_redefine_cursor (a_string_context.cursor_to_current_position)
				has_redefine_clause := True
			else
				l_string.append (",")
				has_redefine_clause := True
			end

			-- the redefine statement
			l_string.append ("%N%T%T%T" + a_feature_name)
			a_string_context.insert_after_cursor (l_string, redefine_cursor)
			set_redefine_cursor (a_string_context.cursor_to_current_position)

			-- set the end keyword if needed
			if not has_changes then
				a_string_context.insert_after_cursor ("%N%T%Tend", redefine_cursor)
				has_changes := True
			end

			-- move cursor to last position
			a_string_context.finish
		end

feature {NONE} -- Implementation

	has_changes: BOOLEAN
			-- Are inherited features changed in a way?

	parent_cursor: LINKED_LIST_CURSOR[STRING]
			-- Position to add additional changes.

	has_rename_clause: BOOLEAN
			-- Does a rename clause exist?

	rename_cursor: LINKED_LIST_CURSOR[STRING]
			-- Position to add additional renamings.

	has_redefine_clause: BOOLEAN
			-- Does a redefine clause exist?

	redefine_cursor: LINKED_LIST_CURSOR[STRING]
			-- Position to add additional redefinitions.

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

end -- class SCOOP_PROXY_PARENT_OBJECT
