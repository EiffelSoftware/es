note
	description: "[
					Roundtrip visitor to create locking request feature in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_LR_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			make,
			process_body_as,
			process_routine_as,
			process_id_as,
			process_require_as
		end

create
	make

feature -- Initialisation

	make(a_ctext: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		do
			Precursor (a_ctext)

			-- Reset some values
			is_print_with_processor_postfix := false
		end

feature -- Access

	process_feature_body (l_as: BODY_AS; l_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Process `l_as': the locking requester to the original feature.
		require
			l_fo_not_void: l_fo /= Void
			l_fo_preconditions_not_void: l_fo.preconditions /= Void
			l_fo_postconditions_not_void: l_fo.postconditions /= Void
		do
			fo := l_fo

			-- frozen keyword
			context.add_string ("%N%N%T")
			if fo.is_feature_frozen then
				context.add_string ("frozen ")
			end

			-- print feature name
			context.add_string (fo.feature_name + " ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			c_as: CONSTANT_AS
		do
			safe_process (l_as.internal_arguments)
			safe_process (l_as.colon_symbol (match_list))
			safe_process (l_as.type)
			safe_process (l_as.assign_keyword (match_list))
			safe_process (l_as.assigner)
			safe_process (l_as.is_keyword (match_list))

			c_as ?= l_as.content
			if c_as /= Void then
				l_as.content.process (Current)
				safe_process (l_as.indexing_clause)
			else
				safe_process (l_as.indexing_clause)

				-- add comment
				context.add_string ("%N%T%T%T-- Locking request of feature `" + fo.feature_name.as_lower + "'.")

				safe_process (l_as.content)
			end
		end

	process_routine_as (l_as: ROUTINE_AS) is
		do
			safe_process (l_as.obsolete_keyword (match_list))
			safe_process (l_as.obsolete_message)

			-- preconditions: only non separate required
			safe_process (l_as.precondition)

			if l_as.internal_locals /= Void then
				last_index := l_as.internal_locals.last_token (match_list).index
			end

			if feature_as.body.type /= Void then
				-- function
				process_routine_as_function
			else
				-- procedure
				process_routine_as_procedure
			end

			last_index := l_as.last_token (match_list).index - 1
			context.add_string ("%N%T%T")
			safe_process (l_as.end_keyword)
		end

	process_id_as (l_as: ID_AS) is
		do
			Precursor (l_as)
			if is_print_with_processor_postfix then
				context.add_string (".processor_")
			end
		end

	process_require_as (l_as: REQUIRE_AS) is
		local
			i: INTEGER
			l_tagged_as: TAGGED_AS
		do
				-- print only non-separate preconditions
			if fo.preconditions.non_separate_preconditions.count > 0 then
					-- print out require keyword
				safe_process (l_as.require_keyword (match_list))

				from
					i := 1
				until
					i > fo.preconditions.non_separate_preconditions.count
				loop
					context.add_string ("%N%T%T%T")
					l_tagged_as := fo.preconditions.non_separate_preconditions.i_th (i).get_tagged_as
					last_index := l_tagged_as.first_token (match_list).index - 1
					safe_process (l_tagged_as)
					i := i + 1
				end
			end

			if l_as /= Void then
				last_index := l_as.last_token (match_list).index
			end
		end

feature {NONE} -- Implementation

	process_routine_as_function is
			-- Adds body for routine body: function
		local
			is_set_prefix: BOOLEAN
			l_class_c: CLASS_C
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			-- add locals
			context.add_string ("%N%T%Tlocal%N%T%T%Ta_function_to_evaluate: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, ")
			create l_type_visitor
			l_class_c := l_type_visitor.evaluate_class_from_type (feature_as.body.type, class_c)
			context.add_string (" ")
			is_set_prefix := l_type_visitor.is_separate and then not l_type_visitor.is_tuple_type or l_type_visitor.is_formal
			process_class_name_str (l_class_c.name_in_upper, is_set_prefix, context, match_list)
			context.add_string ("]")

			-- add do keyword
			context.add_string ("%N%T%Tdo")

			-- create function
			context.add_string ("%N%T%T%Ta_function_to_evaluate := agent " + fo.feature_name + "_scoop_separate_" + parsed_class.class_name.name.as_lower + "_enclosing_routine ")
			if feature_as.body.internal_arguments /= Void then
				context.add_string ("(")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end

			-- call function
			context.add_string ("%N%T%T%Tseparate_execute_routine ([")
			process_separate_internal_arguments_as_actual_argument_list(true)
			context.add_string ("]")
			context.add_string (", a_function_to_evaluate,%N%T%T%T%Tagent "+ fo.feature_name.as_lower + "_scoop_separate_" + class_c.name.as_lower + "_wait_condition")
			if feature_as.body.internal_arguments /= Void then
				context.add_string (" (")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end

			-- 5th argument, postcondition processing: separate postconditions
			if fo.postconditions.separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + fo.feature_name + "_scoop_separate_")
				context.add_string (class_c.name.as_lower + "_separate_postcondition")
				if feature_as.body.internal_arguments /= Void then
					context.add_string (" (")
					process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
					context.add_string (")")
				end
			else
				-- just pass 'void' as fifth argument
				context.add_string (", Void")
			end

			-- 6th argument, postcondition processing: non separate postconditions
			if fo.postconditions.non_separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_non_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + fo.feature_name + "_scoop_separate_")
				context.add_string (class_c.name.as_lower + "_non_separate_postcondition")
				if feature_as.body.internal_arguments /= Void then
					context.add_string (" (")
					process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
					context.add_string (")")
				end
			else
				-- just pass 'void' as fifth argument
				context.add_string (", Void")
			end
			context.add_string (")")

			-- Result
			context.add_string ("%N%T%T%TResult ")
			if not l_class_c.is_expanded and then not l_type_visitor.is_formal then
				context.add_string ("?= ")
			else
				context.add_string (":= ")
			end
			context.add_string ("a_function_to_evaluate.last_result")
		end

	process_routine_as_procedure is
			-- Adds body for routine body: procedure
		do
			context.add_string ("%N%T%Tdo")

			context.add_string ("%N%T%T%Tinvariant_disabled := True")
			context.add_string ("%N%T%T%Tseparate_execute_routine ([")
			process_separate_internal_arguments_as_actual_argument_list(true)
			context.add_string ("], agent " + fo.feature_name.as_lower + "_scoop_separate_" + class_c.name.as_lower + "_enclosing_routine ")
			if feature_as.body.internal_arguments /= Void then
				context.add_string ("(")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end
			context.add_string (",%N%T%T%T%Tagent " + fo.feature_name.as_lower + "_scoop_separate_" + class_c.name.as_lower + "_wait_condition ")
						if feature_as.body.internal_arguments /= Void then
				context.add_string ("(")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end

			-- 5th argument, postcondition processing: separate postconditions
			if fo.postconditions.separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + fo.feature_name + "_scoop_separate_")
				context.add_string (class_c.name.as_lower + "_separate_postcondition")
				if feature_as.body.internal_arguments /= Void then
					context.add_string (" (")
					process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
					context.add_string (")")
				end
			else
				-- just pass 'void' as fifth argument
				context.add_string (", Void")
			end

			-- 6th argument, postcondition processing: non separate postconditions
			if fo.postconditions.non_separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_non_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + fo.feature_name + "_scoop_separate_")
				context.add_string (class_c.name.as_lower + "_non_separate_postcondition")
				if feature_as.body.internal_arguments /= Void then
					context.add_string (" (")
					process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
					context.add_string (")")
				end
			else
				-- just pass 'void' as fifth argument
				context.add_string (", Void")
			end
			context.add_string (")")

			-- End keyword.
			context.add_string ("%N%T%T%Tinvariant_disabled := False")
		end

	process_internal_arguments_as_actual_argument_list(l_as: FORMAL_ARGU_DEC_LIST_AS) is
			-- prints argument names as actual argument list to context.
		local
			i: INTEGER
		do
			if l_as /= Void then
				from
					i := 1
				until
					i >= l_as.arguments.count
				loop
					last_index := l_as.arguments.i_th (i).first_token (match_list).index - 1
					process_identifier_list (l_as.arguments.i_th (i).id_list)
					context.add_string (", ")
					i := i + 1
				end

				if i = l_as.arguments.count then
					last_index := l_as.arguments.i_th (i).first_token (match_list).index - 1
					process_identifier_list (l_as.arguments.i_th (i).id_list)
				end
			end
		end

	process_separate_internal_arguments_as_actual_argument_list(with_processor: BOOLEAN) is
			-- prints argument names as actual argument list to context.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i >= fo.arguments.separate_arguments.count
			loop
				last_index := fo.arguments.separate_arguments.i_th (i).first_token (match_list).index - 1
				is_print_with_processor_postfix := with_processor
				process_identifier_list (fo.arguments.separate_arguments.i_th (i).id_list)
				is_print_with_processor_postfix := false
				context.add_string (", ")
				i := i + 1
			end

			if i = fo.arguments.separate_arguments.count then
				last_index := fo.arguments.separate_arguments.i_th (i).first_token (match_list).index - 1
				is_print_with_processor_postfix := with_processor
				process_identifier_list (fo.arguments.separate_arguments.i_th (i).id_list)
				is_print_with_processor_postfix := false
			end
		end

feature {NONE} -- Implementation

	is_print_with_processor_postfix: BOOLEAN
		-- indicates that a postfix '.processor' is added to an id_as element

	fo: SCOOP_CLIENT_FEATURE_OBJECT
		-- feature object of current processed feature.

;note
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

end -- class SCOOP_CLIENT_FEATURE_LR_VISITOR
