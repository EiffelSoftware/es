note
	description: "EiffelTransform shared parsers."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_SHARED_PARSERS
inherit
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_CONSTANTS

feature {NONE} -- Constants

	default_using_compiler_factory: BOOLEAN = true
			-- Default factory is a compiler factory

feature {NONE} -- Parser	

	parsing_helper: ETR_PARSING_HELPER
			-- Shared instance of ETR_PARSING_HELPER
		once
			create Result
			Result.set_compiler_factory (default_using_compiler_factory)
		end

	etr_class_parser: EIFFEL_PARSER
			-- Internal parser used to handle classes
		do
			if parsing_helper.is_using_compiler_factory then
				Result := parsing_helper.etr_compiler_class_parser
			else
				Result := parsing_helper.etr_non_compiler_class_parser
			end
		end

	etr_type_parser: EIFFEL_PARSER
			-- Internal parser used to handle classes
		do
			if parsing_helper.is_using_compiler_factory then
				Result := parsing_helper.etr_compiler_type_parser
			else
				Result := parsing_helper.etr_non_compiler_type_parser
			end
		end

	etr_expr_parser: EIFFEL_PARSER
			-- Internal parser used to handle expressions
		do
			if parsing_helper.is_using_compiler_factory then
				Result := parsing_helper.etr_compiler_expr_parser
			else
				Result := parsing_helper.etr_non_compiler_expr_parser
			end
		end

	etr_feat_parser: EIFFEL_PARSER
			-- Internal parser used to handle instructions
		do
			if parsing_helper.is_using_compiler_factory then
				Result := parsing_helper.etr_compiler_feat_parser
			else
				Result := parsing_helper.etr_non_compiler_feat_parser
			end
		end

feature -- Utilities

	setup_formal_parameters (a_parser: EIFFEL_PARSER; a_context_class: detachable CLASS_C)
			-- Setup formal parameters from `a_context_class' into `a_parser'.
		do
			a_parser.formal_parameters.wipe_out
			if a_context_class /= Void and then a_context_class.is_generic then
				if attached {EIFFEL_LIST [FORMAL_DEC_AS]} a_context_class.generics as l_generics then
					l_generics.do_all (
						agent (a_formal: FORMAL_DEC_AS; a_list: LIST [FORMAL_AS])
							do
								a_list.extend (a_formal.formal)
							end (?, a_parser.formal_parameters))
				end
			end
		end
		
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
