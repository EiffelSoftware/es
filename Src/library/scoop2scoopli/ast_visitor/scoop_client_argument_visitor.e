note
	description: "[
					Roundtrip visitor to process internal argument list.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_ARGUMENT_VISITOR

obsolete
	"Use SCOOP_TYPE_EXPR_VISITOR"

inherit
	AST_ROUNDTRIP_ITERATOR
		export
			{NONE} all
			{SCOOP_VISITOR_FACTORY} setup
		redefine
			process_type_dec_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as
		end

feature -- Access

	process_arguments (l_as: FORMAL_ARGU_DEC_LIST_AS): SCOOP_CLIENT_ARGUMENT_OBJECT is
			-- Process internal argument list.
			-- Save separate types declarations in a list.
		do
			create arguments.make
			safe_process (l_as)
			Result := arguments
		end

feature {NONE} -- Roundtrip/Token

	process_type_dec_as (l_as: TYPE_DEC_AS) is
		do
				-- reset flag
			is_current_type_separate := False

				-- evalualte separateness
			safe_process (l_as.type)

				-- save separate argument in list
			if is_current_type_separate then
				-- extend the list
				arguments.separate_arguments.extend (l_as)
			else
				arguments.non_separate_arguments.extend (l_as)
			end
		end

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			if l_as.is_separate then
				is_current_type_separate := True
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			safe_process (l_as.internal_generics)
			if l_as.is_separate then
				is_current_type_separate := True
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			safe_process (l_as.parameters)
			if l_as.is_separate then
				is_current_type_separate := True
			end
		end

feature {NONE} -- Implementation

	arguments: SCOOP_CLIENT_ARGUMENT_OBJECT
		-- object collects processed arguments of processed feature

	is_current_type_separate: BOOLEAN
		-- separate state of current type declaration

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

end -- SCOOP_CLIENT_ARGUMENT_VISITOR
