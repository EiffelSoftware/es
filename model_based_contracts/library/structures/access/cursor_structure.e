indexing

	description: "[
		Active structures, which always have a current position
		accessible through a cursor.
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: cursor_structure, access;
	access: cursor, membership;
	contents: generic;
	model: bag, cursor_position, cursors, cursor_to_item, extendible, prunable, writable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class CURSOR_STRUCTURE [G] inherit

	ACTIVE [G]
		redefine
			item, readable
		end

feature -- Access

	cursor: CURSOR is
			-- Current cursor position
		deferred
		ensure
			cursor_not_void: Result /= Void
		-- ensure: model
			position_definition: Result.position = cursor_position
		end

	item: G is
			-- Current item
		deferred
		ensure then
		-- ensure then: model
			definition: cursor_to_item.image_of (cursor_position).contains (Result)
		end

feature -- Status report

	valid_cursor (p: CURSOR): BOOLEAN is
			-- Can the cursor be moved to position `p'?
		deferred
		ensure
		-- ensure: model
			definition: Result = cursors.contains (p.position)
		end

	readable: BOOLEAN is
			-- Is there a current item that may be read?
		deferred
		ensure then
		-- ensure then: model
			definition: Result = cursor_to_item.domain.contains (cursor_position)
		end

feature -- Cursor movement

	go_to (p: CURSOR) is
			-- Move cursor to position `p'.
		require
			cursor_position_valid: valid_cursor (p)
		deferred
		ensure
		-- ensure: model
			cursor_effect: cursor.position = p.position
		end

feature -- Model
	cursor_position: INTEGER is
			-- Cursor position
		deferred
		end

	cursors: MML_SET [INTEGER] is
			-- Set of possible cursors
		deferred
		end

	cursor_to_item: MML_RELATION [INTEGER, G] is
			-- Relation between cursor position and items
		deferred
		end

invariant
-- invariant: model
	cursor_position_in_cursors: cursors.contains (cursor_position)
	cursor_to_item_domain_from_cursors: cursor_to_item.domain.is_subset_of (cursors)
	cursor_to_item_is_fucntion: cursor_to_item.is_function
indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class CURSOR_STRUCTURE



