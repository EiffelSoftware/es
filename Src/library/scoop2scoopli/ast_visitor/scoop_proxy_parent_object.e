indexing
	description: "Summary description for {SCOOP_PARENT_PROXY_OBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_PARENT_OBJECT

create
	make

feature -- Initialization

	make (a_parent_name: STRING)
			-- Create a new proxy parent object
		do
			set_parent_name (a_parent_name)
		end

feature -- Access

	parent_name: STRING
			-- Name of current parent object

	set_parent_name (a_parent_name: STRING) is
			-- Setter for `parent_name'.
		require
			a_parent_name /= Void
		do
			parent_name := a_parent_name
		end

	parent_class_c: CLASS_C
			-- Reference to class C of current parent.

	set_parent_class_c (a_class_c: CLASS_C) is
			-- Setter for `parent_class_c'.
		require
			a_class_c_not_void: a_class_c /= Void
		do
			parent_class_c := a_class_c
		end

	set_parent_cursor (a_cursor: LINKED_LIST_CURSOR[STRING]) is
			-- Setter for `parent_cursor'.
		require
			a_cursor_not_void: a_cursor /= Void
		do
			parent_cursor := a_cursor
		end

	set_rename_cursor (a_cursor: LINKED_LIST_CURSOR[STRING]) is
			-- Setter for `rename_cursor'.
		require
			a_cursor_not_void: a_cursor /= Void
		do
			has_changes := true
			has_rename_clause := true
			rename_cursor := a_cursor
		end

	set_redefine_cursor (a_cursor: LINKED_LIST_CURSOR[STRING]) is
			-- Setter for `redefine_cursor'.
		require
			a_cursor_not_void: a_cursor /= Void
		do
			has_changes := true
			has_redefine_clause := true
			redefine_cursor := a_cursor
		end

feature -- Context change

	add_rename_clause (an_old_name, a_new_name: STRING; a_string_context: ROUNDTRIP_STRING_LIST_CONTEXT) is
			-- Inserts a new rename clause in the context
		local
			l_string: STRING
		do
			create l_string.make_empty

			-- add a rename keyword if there isnt one
			if not has_rename_clause then
				a_string_context.insert_after_cursor ("%N%T%Trename", parent_cursor)
				set_rename_cursor (a_string_context.get_cursor)
				has_rename_clause := true
			else
				l_string.append (",")
				has_rename_clause := true
			end

			-- the rename statement
			l_string.append ("%N%T%T%T" + an_old_name + " as " + a_new_name)
			a_string_context.insert_after_cursor (l_string, rename_cursor)
			set_rename_cursor (a_string_context.get_cursor)

			-- set the end keyword if needed
			if not has_changes then
					a_string_context.insert_after_cursor ("%N%T%Tend", rename_cursor)
				has_changes := true
			end

			-- move cursor to last position
			a_string_context.finish
		end

	add_redefine_clause (a_feature_name: STRING; a_string_context: ROUNDTRIP_STRING_LIST_CONTEXT) is
			-- Inserts a new redefine clause in the context
		local
			l_string: STRING
		do
			create l_string.make_empty

			-- add a redefine keyword if there isnt one
			if not has_redefine_clause then
				a_string_context.insert_after_cursor ("%N%T%Tredefine", parent_cursor)
				set_redefine_cursor (a_string_context.get_cursor)
				has_redefine_clause := true
			else
				l_string.append (",")
				has_redefine_clause := true
			end

			-- the redefine statement
			l_string.append ("%N%T%T%T" + a_feature_name)
			a_string_context.insert_after_cursor (l_string, redefine_cursor)
			set_redefine_cursor (a_string_context.get_cursor)

			-- set the end keyword if needed
			if not has_changes then
				a_string_context.insert_after_cursor ("%N%T%Tend", redefine_cursor)
				has_changes := true
			end

			-- move cursor to last position
			a_string_context.finish
		end

feature {NONE} -- Implementation

	has_changes: BOOLEAN
			-- Inherited features are changed in a way.

	parent_cursor: LINKED_LIST_CURSOR[STRING]
			-- Position to add additional changes

	has_rename_clause: BOOLEAN
			-- Indicates the existance of a rename clause.

	rename_cursor: LINKED_LIST_CURSOR[STRING]
			-- Position to add additional renamings

	has_redefine_clause: BOOLEAN
			-- Indicates the existance of a redefine clause.

	redefine_cursor: LINKED_LIST_CURSOR[STRING]
			-- Position to add additional redefinitions

end
