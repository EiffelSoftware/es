note
	description: "Creates a setter for an attribute."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_SETTER_GENERATOR
inherit
	ETR_SHARED_ERROR_HANDLER

	ETR_SHARED_LOGGER

	ETR_SHARED_TOOLS

	ETR_SHARED_PARSERS

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Access

	transformation_result: ETR_TRANSFORMABLE
			-- Result of last transformation

feature -- Operation

	generate_setter (a_transformable: ETR_TRANSFORMABLE; a_feature_name, a_arg_name, a_assignment, a_postcond: STRING)
			-- Generates a setter for `a_transformable'
		require
			non_void: a_transformable /= void and a_feature_name /= void and a_arg_name /= void and a_assignment /= void and a_postcond /= void
			valid_trans: a_transformable.is_valid
		local
			l_attr_name: STRING
			l_setter_string: STRING
		do
			error_handler.reset_errors
			if attached {FEATURE_AS}a_transformable.target_node as l_attribute then
				-- check strings
				if not (create {EIFFEL_SYNTAX_CHECKER}).is_valid_feature_name (a_feature_name) then
					error_handler.add_error(Current, "generate_setter", "%""+a_feature_name+"%" is not a valid name.")
				end

				if not (create {EIFFEL_SYNTAX_CHECKER}).is_valid_feature_name (a_arg_name) then
					error_handler.add_error(Current, "generate_setter", "%""+a_arg_name+"%" is not a valid name.")
				end

				parsing_helper.parse_instruction (a_assignment, a_transformable.context.context_class)
				if parsing_helper.parsed_instruction = void then
					error_handler.add_error(Current, "generate_setter", "%""+a_assignment+"%" is not a valid instruction.")
				end

				parsing_helper.parse_expr (a_postcond, a_transformable.context.context_class)
				if parsing_helper.parsed_expr = void then
					error_handler.add_error(Current, "generate_setter", "%""+a_postcond+"%" is not a valid expression.")
				end

				if not l_attribute.is_attribute then
					error_handler.add_error (Current, "generate_setter", "Feature is not an attribute")
				end

				if not error_handler.has_errors then
					l_attr_name := l_attribute.feature_name.name

					-- as easy as possible:
					l_setter_string := 	"feature "+a_feature_name+" ("+a_arg_name+": like "+l_attr_name+")%N"+
										"%Tdo%N"+
										"%T%T"+a_assignment+"%N"+
										"%Tensure%N"+
										"%T%T"+l_attr_name+"_set: "+a_postcond+"%N"+
										"%Tend%N"

					etr_feat_parser.set_syntax_version (etr_feat_parser.provisional_syntax)
					etr_feat_parser.parse_from_utf8_string (l_setter_string,void)

					if etr_feat_parser.error_count=0 then
						create transformation_result.make (etr_feat_parser.feature_node, a_transformable.context.class_context, false)
					else
						error_handler.add_error (Current, "generate_setter", "Feature parsing failed")
					end
				end
			else
				error_handler.add_error (Current, "generate_setter", "Transformable does not contain a feature-node")
			end
		end
note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
