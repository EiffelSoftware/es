indexing
	description: "Node for the explicit processor specification tag."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLICIT_PROCESSOR_SPECIFICATION_AS

inherit
	EXPR_AS
	LEAF_AS

create
	initialize,
	initialize_with_handler

feature {NONE} -- Initialization

	initialize (e: ID_AS) is
			-- Create a new ID AST node made up
			-- of characters contained in `s'.
		require
			e_not_void: e /= Void
		do
			entity := e
		ensure
			entity_set: entity.is_equal (e)
		end

	initialize_with_handler (e, h: ID_AS) is
			-- Create a new ID AST node made up
			-- of characters contained in `s'.
		require
			e_not_void: e /= Void
			h_not_void: h /= Void
			h_equals_handler: h.name.is_equal ("handler")
		do
			entity := e
			handler := h
		ensure
			entity_set: entity.is_equal (e)
			handler_set: handler.is_equal (h)
		end

feature -- Access

	entity: ID_AS
			-- Name of the entity.

	handler: ID_AS
			-- Name of the handler.

feature -- Visitor

	process (v: AST_VISITOR) is
			-- process current element.
		do
			v.process_explicit_processor_specification_as (Current)
		end

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN is
			-- Is `other' equivalent to the current object ?
		do
			Result := is_equal (other)
		end

invariant
	invariant_clause: True -- Your invariant here

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EXPLICIT_PROCESSOR_SPECIFICATION_AS
