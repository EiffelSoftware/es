note
	description: "[
					Roundtrip visitor to process type node within signature
					in SCOOP proxy class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_TYPE_SIGNATURE_PRINTER

inherit
	SCOOP_PROXY_TYPE_VISITOR
		redefine
			process_class_name
		end

create
	make_with_context

feature {NONE} -- Feature implementation

	evaluate_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
				is_filter_detachable := false
			else
				is_print_with_prefix := true
				is_filter_detachable := true
			end
		end

	evaluate_generic_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
				is_filter_detachable := false
			else
				is_print_with_prefix := true
				is_filter_detachable := true
			end
		end

	evaluate_named_tuple_type_flags (is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			--if is_separate then
				is_print_with_prefix := true
				is_filter_detachable := true
			--else
			--	is_print_with_prefix := false
			--	is_filter_detachable := false
			--end
		end

	evaluate_like_current_type_flags is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := true
			is_filter_detachable := false
		end

	evaluate_like_id_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
				is_filter_detachable := false
			else
				is_print_with_prefix := true
				is_filter_detachable := true
			end
		end

feature {NONE} -- class name implementation

	process_class_name (l_as: ID_AS; is_set_prefix: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- adds 'SCOOP_SEPARATE__'  as prefix to class name `ANY'
		do
			if l_as.name.as_upper.is_equal ("ANY") then
				context.add_string ("SCOOP_SEPARATE__")
			end
			Precursor (l_as, is_set_prefix, l_context, l_match_list)
		end

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

end -- class SCOOP_PROXY_TYPE_SIGNATURE_PRINTER
