note
	description: "SCOOP class name processing."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLASS_NAME

inherit
	SCOOP_WORKBENCH

feature -- Access

	process_class_name (l_as: ID_AS; is_set_prefix: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- Process 'l_as' with a class name printer
		require
			l_as_not_void: l_as /= Void
			l_context_not_void: l_context /= Void
			l_match_list_not_void: l_match_list /= Void
		do
			l_context_ref := l_context
			l_class_name_visitor.set_context (l_context_ref)
			l_class_name_visitor.setup (class_as, l_match_list, true, true)
			l_class_name_visitor.process_id (l_as, is_set_prefix)
		end

	process_class_name_str (l_class_name: STRING; is_set_prefix: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- Process 'l_as' with a class name printer
		require
			l_class_name_not_void: l_class_name /= Void
			l_context_not_void: l_context /= Void
			l_match_list_not_void: l_match_list /= Void
		do
			l_context_ref := l_context
			l_class_name_visitor.set_context (l_context_ref)
			l_class_name_visitor.setup (class_as, l_match_list, true, true)
			l_class_name_visitor.process_id_str (l_class_name, is_set_prefix)
		end

	process_class_name_list_with_prefix (l_as: CLASS_LIST_AS; print_both: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- Process 'l_as' with a class name printer
		require
			l_as_not_void: l_as /= Void
			l_context_not_void: l_context /= Void
			l_match_list_not_void: l_match_list /= Void
		do
			l_context_ref := l_context
			l_class_name_visitor.set_context (l_context_ref)
			l_class_name_visitor.setup (class_as, l_match_list, true, true)
			l_class_name_visitor.process_class_list_with_prefix (l_as, print_both)
		end

feature {NONE} -- Implementation

	l_context_ref: ROUNDTRIP_CONTEXT
			-- Reference to current processed context

	l_class_name_visitor_impl: SCOOP_CLASS_NAME_VISITOR is
			-- Creates a new class name visitor
		do
			Result := create {SCOOP_CLASS_NAME_VISITOR}.make_with_context (l_context_ref)
		end

	l_class_name_visitor: SCOOP_CLASS_NAME_VISITOR is
			-- Returns the once created visitor
		once
			Result := l_class_name_visitor_impl
		end

note
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

end -- SCOOP_CLASS_NAME
