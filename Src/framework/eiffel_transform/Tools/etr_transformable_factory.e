note
	description: "Transformable factory"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRANSFORMABLE_FACTORY
inherit
	ETR_SHARED_ERROR_HANDLER
	REFACTORING_HELPER
		export
			{NONE} all
		end
	ETR_SHARED_PARSERS

feature -- New

	new_invalid: ETR_TRANSFORMABLE
			-- create a new invalid transformable
		do
			create Result.make_invalid
		end

	new_instr(an_instr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new instruction from `an_instr' with context `a_context'
		require
			instr_attached: an_instr /= void
			context_attached: a_context /= void
		do
			etr_feat_parser.parse_from_string ("feature new_instr_dummy_feature do "+an_instr+" end",void)

			if etr_feat_parser.error_count>0 then
				error_handler.add_error("new_instr: Parsing failed")
				create Result.make_invalid
			else
				if attached etr_feat_parser.feature_node as fn and then attached {DO_AS}fn.body.as_routine.routine_body as body then
					create Result.make_from_ast (body.compound.first, a_context, false)
				end
			end
		end

	new_expr(an_expr: STRING; a_context: ETR_CONTEXT): ETR_TRANSFORMABLE
			-- create a new exression from `an_expr' with context `a_context'
		require
			expr_attached: an_expr /= void
			context_attached: a_context /= void
		do
			etr_expr_parser.parse_from_string("check "+an_expr,void)

			if etr_expr_parser.error_count>0 then
				error_handler.add_error("new_expr: Parsing failed")
				create Result.make_invalid
			else
				create Result.make_from_ast (etr_expr_parser.expression_node, a_context, false)
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
