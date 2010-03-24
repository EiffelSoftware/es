note
	description: "[
					Roundtrip visitor to create a locking request feature in a client class, based on an original feature.
					A locking request feature exists for an original feature with separate arguments. It checks the non-separate precondition of the original feature. If the check is successful, it blocks until the scheduler signals that all all requested locks are granted and the wait condition is satisfied. Then it executes the enclosing routine.
					The non-separate precondition contains only calls on non-separate targets. The non-separate precondition is always controlled. Therefore it can be checked before the locking requestor gets executed. 
					The formal argument list of the locking requestor is changed in case the original feature redeclares its internal arguments from non-separate to separate.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_LR_VISITOR

inherit
	SCOOP_CLIENT_FEATURE_VISITOR
		redefine
			make,
			process_routine_as,
			process_id_as,
			process_require_as,
			process_require_else_as,
			process_type_dec_as,
			process_class_type_as,
			process_generic_class_type_as
		end

create
	make

feature -- Initialisation

	make(a_ctext: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		do
			Precursor (a_ctext)

			-- Reset some values
			is_print_with_processor_postfix := False
		end

feature -- Access

	add_locking_requestor (l_as: BODY_AS)
			-- Add a locking requestor for 'l_as'.
		do
			-- frozen keyword
			context.add_string ("%N%N%T")
			if feature_object.is_feature_frozen then
				context.add_string ("frozen ")
			end

			-- print feature name
			context.add_string (feature_object.feature_name + " ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- General implementation

	process_routine_as_function
			-- Adds body for routine body: function
		local
			is_set_prefix: BOOLEAN
			l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_routine_type: TYPE_A
			l_generics_visitor: SCOOP_GENERICS_VISITOR
		do
			-- add locals
			context.add_string ("%N%T%Tlocal%N%T%T%Ta_function_to_evaluate: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, ")
			l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor
			l_type_expr_visitor.resolve_type_in_class (feature_as.body.type, class_c)
			l_routine_type := l_type_expr_visitor.resolved_type
			context.add_string (" ")


			-- Fix for redeclarations if feature is query type:
			-- If `l_as.type' is non separate but was separate in an ancestor version we need to make it separate
			-- Only a potential problem when return type is `non-separate' and a `CLASS_TYPE_AS'
			is_set_prefix := l_routine_type.is_separate and then not l_routine_type.is_tuple or l_routine_type.is_formal
			process_class_name_str (l_routine_type.associated_class.name_in_upper, is_set_prefix, context, match_list)

			-- process internal generics
			if attached {GENERIC_CLASS_TYPE_AS} feature_as.body.type as typ then
				l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
				l_generics_visitor.process_internal_generics (typ.internal_generics, True, False)
				if typ.internal_generics /= Void then
					last_index := l_generics_visitor.get_last_index
				end
			end


			context.add_string ("]")

			-- add do keyword
			context.add_string ("%N%T%Tdo")

			-- create function
			context.add_string ("%N%T%T%Ta_function_to_evaluate := agent " + feature_object.feature_name + "_scoop_separate_" + parsed_class.class_name.name.as_lower + "_enclosing_routine ")
			if feature_as.body.internal_arguments /= Void then
				context.add_string ("(")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end

			-- call function
			context.add_string ("%N%T%T%Tseparate_execute_routine ([")
			process_separate_internal_arguments_as_actual_argument_list(True)
			context.add_string ("]")
			context.add_string (", a_function_to_evaluate,%N%T%T%T%Tagent "+ feature_object.feature_name.as_lower + "_scoop_separate_" + class_c.name.as_lower + "_wait_condition")
			if feature_as.body.internal_arguments /= Void then
				context.add_string (" (")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end

			-- 5th argument, postcondition processing: separate postconditions
			if feature_object.postconditions.separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + feature_object.feature_name + "_scoop_separate_")
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
			if feature_object.postconditions.non_separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_non_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + feature_object.feature_name + "_scoop_separate_")
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
			if not l_routine_type.associated_class.is_expanded and then not l_routine_type.is_formal then
				context.add_string ("?= ")
			else
				context.add_string (":= ")
			end
			context.add_string ("a_function_to_evaluate.last_result")
		end

	process_routine_as_procedure
			-- Adds body for routine body: procedure
		do
			context.add_string ("%N%T%Tdo")

			context.add_string ("%N%T%T%Tinvariant_disabled := True")
			context.add_string ("%N%T%T%Tseparate_execute_routine ([")
			process_separate_internal_arguments_as_actual_argument_list(True)
			context.add_string ("], agent " + feature_object.feature_name.as_lower + "_scoop_separate_" + class_c.name.as_lower + "_enclosing_routine ")
			if feature_as.body.internal_arguments /= Void then
				context.add_string ("(")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end
			context.add_string (",%N%T%T%T%Tagent " + feature_object.feature_name.as_lower + "_scoop_separate_" + class_c.name.as_lower + "_wait_condition ")
						if feature_as.body.internal_arguments /= Void then
				context.add_string ("(")
				process_internal_arguments_as_actual_argument_list(feature_as.body.internal_arguments)
				context.add_string (")")
			end

			-- 5th argument, postcondition processing: separate postconditions
			if feature_object.postconditions.separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + feature_object.feature_name + "_scoop_separate_")
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
			if feature_object.postconditions.non_separate_postconditions.count > 0 then
				-- add agent calling 'agent f_scoop_separate_C_non_separate_postcondition(<formal argument list>)'
				context.add_string (",%N%T%T%T%Tagent " + feature_object.feature_name + "_scoop_separate_")
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

	process_internal_arguments_as_actual_argument_list(l_as: FORMAL_ARGU_DEC_LIST_AS)
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

	process_separate_internal_arguments_as_actual_argument_list(with_processor: BOOLEAN)
			-- prints argument names as actual argument list to context.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i >= feature_object.arguments.separate_arguments.count
			loop
				last_index := feature_object.arguments.separate_arguments.i_th (i).first_token (match_list).index - 1
				is_print_with_processor_postfix := with_processor
				process_identifier_list (feature_object.arguments.separate_arguments.i_th (i).id_list)
				is_print_with_processor_postfix := False
				context.add_string (", ")
				i := i + 1
			end

			if i = feature_object.arguments.separate_arguments.count then
				last_index := feature_object.arguments.separate_arguments.i_th (i).first_token (match_list).index - 1
				is_print_with_processor_postfix := with_processor
				process_identifier_list (feature_object.arguments.separate_arguments.i_th (i).id_list)
				is_print_with_processor_postfix := False
			end
		end

	process_routine_as (l_as: ROUTINE_AS)
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

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			process_require_as(l_as)
		end

	process_require_as (l_as: REQUIRE_AS)
		local
			i: INTEGER
			l_tagged_as: TAGGED_AS
		do
				-- print only non-separate preconditions
			if feature_object.preconditions.non_separate_preconditions.count > 0 then
					-- print out require keyword
				avoid_proxy_calls_in_call_chains := true
				safe_process (l_as.require_keyword (match_list))
				if attached {REQUIRE_ELSE_AS} l_as as rea then
					-- Require Else call, process esle keyword
					safe_process (rea.else_keyword (match_list))
				end
				avoid_proxy_calls_in_call_chains := false

				from
					i := 1
				until
					i > feature_object.preconditions.non_separate_preconditions.count
				loop
					context.add_string ("%N%T%T%T")
					l_tagged_as := feature_object.preconditions.non_separate_preconditions.i_th (i).tagged_as
					last_index := l_tagged_as.first_token (match_list).index - 1
					safe_process (l_tagged_as)
					i := i + 1
				end
			end

			if l_as /= Void then
				last_index := l_as.last_token (match_list).index
			end
		end

	is_print_with_processor_postfix: BOOLEAN
			-- indicates that a postfix '.processor' is added to an id_as element

feature {NONE} -- Feature redeclaration handling
	process_id_as (l_as: ID_AS)
		do
			Precursor (l_as)
			if feature_object /= void and then feature_object.is_internal_arguments_to_substitute_defined then
				from
					feature_object.internal_arguments_to_substitute.start
				until
					feature_object.internal_arguments_to_substitute.after
				loop
					if feature_object.internal_arguments_to_substitute.item.is_equal (l_as.index) then
						context.add_string ("."+{SCOOP_SYSTEM_CONSTANTS}.proxy_conversion_feature_name)
					end
					feature_object.internal_arguments_to_substitute.forth
				end
			end
			if is_print_with_processor_postfix then
				context.add_string (".processor_")
			end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			if is_internal_arguments and then attached {CLASS_TYPE_AS} l_as.type as typ then
				-- We are in Internal Arguments (not random type dec)

				single_process_identifier_list (l_as.id_list,typ)
				last_index := l_as.last_token (match_list).index
			else
				-- Not internal arguments: skip substitution
				Precursor (l_as)
			end

		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		local
			add_scoop_separate__: BOOLEAN
		do
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.attachment_mark (match_list))
			safe_process (l_as.expanded_keyword (match_list))

			-- skip separate keyword and processor tag
			if l_as.is_separate then
				process_leading_leaves (l_as.separate_keyword_index)
				last_index := l_as.class_name.index - 1
				context.add_string (" ")
			end

			if substitute_internal_argument then
				add_scoop_separate__ := False
				substitute_internal_argument := False
			else
				add_scoop_separate__ := l_as.is_separate
			end

			-- process class name
			process_leading_leaves (l_as.class_name.index)
			process_class_name (l_as.class_name, add_scoop_separate__, context, match_list)
			last_index := l_as.class_name.index

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		local
			l_generics_visitor: SCOOP_GENERICS_VISITOR
			add_scoop_separate__: BOOLEAN
		do
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.attachment_mark (match_list))
			safe_process (l_as.expanded_keyword (match_list))

			-- skip separate keyword and processor tag
			if l_as.is_separate then
				process_leading_leaves (l_as.separate_keyword_index)
				last_index := l_as.class_name.index - 1
				context.add_string (" ")
			end

			if substitute_internal_argument then
				add_scoop_separate__ := False
				substitute_internal_argument := False
			else
				add_scoop_separate__ := l_as.is_separate
			end
			-- process class name
			process_leading_leaves (l_as.class_name.index)
			process_class_name (l_as.class_name, add_scoop_separate__, context, match_list)
			context.add_string (" ")
			last_index := l_as.class_name.index

			-- process internal generics
			l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
			l_generics_visitor.process_internal_generics (l_as.internal_generics, True, False)
			if l_as.internal_generics /= Void then
				last_index := l_generics_visitor.get_last_index
			end

			safe_process (l_as.rcurly_symbol (match_list))
		end

	single_process_identifier_list (l_as: IDENTIFIER_LIST; l_as_type: CLASS_TYPE_AS)
			-- Process `l_as'
		local
			pos,x,j,i, l_count: INTEGER
			l_index: INTEGER
			l_ids: CONSTRUCT_LIST [INTEGER]
			l_id_as: ID_AS
			l_leaf: LEAF_AS
			type_dec: TYPE_DEC_AS
			l_generics_visitor: SCOOP_GENERICS_VISITOR
			generics_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			add_scoop_separate__: BOOLEAN
			interal_argument_to_substitute: TUPLE[pos:INTEGER;type:TYPE_AS]
			feature_name: FEATURE_NAME
		do
			if l_as /= Void then
				l_ids := l_as.id_list
				if l_ids /= Void and l_ids.count > 0 then

					-- Get the position of the first argument of the list in the feature
					x := 1
					from
						j := 1
					until
						j > feature_as.body.internal_arguments.arguments.count
					loop
						type_dec:= feature_as.body.internal_arguments.arguments.i_th (j)
						from
							type_dec.id_list.id_list.start
						until
							type_dec.id_list.id_list.after
						loop
							if type_dec.id_list.id_list.item.is_equal (l_ids.i_th (1)) then
								pos := x
							end
							x := x +1
							type_dec.id_list.id_list.forth
						end
						j := j +1
					end

					from
						l_ids.start
						i := 1
							-- Temporary/reused objects to print identifiers.
						create l_id_as.initialize_from_id (1)
						if l_as.separator_list /= Void then
							l_count := l_as.separator_list.count
						end
					until
						l_ids.after
					loop
						l_index := l_ids.item
						if match_list.valid_index (l_index) then
							l_leaf := match_list.i_th (l_index)
								-- Note that we do not set the `name_id' for `l_id_as' since it will require
								-- updating the NAMES_HEAP and we do not want to do that. It is assumed in roundtrip
								-- mode that the text is never obtained from the node itself but from the `text' queries.
							l_id_as.set_position (l_leaf.line, l_leaf.column, l_leaf.position, l_leaf.location_count)
							l_id_as.set_index (l_index)
							safe_process (l_id_as)

							context.add_string (":")
							last_index := l_as_type.first_token (match_list).index
							-- Check if we need to substitute the internal argument
							add_scoop_separate__ := False
							if l_as_type.is_separate then
								add_scoop_separate__ := True
								if need_internal_argument_substitution(feature_as.feature_name, class_c, pos) then
									feature_object.internal_arguments_to_substitute.put_front (l_ids.item)
									substitute_internal_argument := True
									add_scoop_separate__ := False

								end
							end
							if add_scoop_separate__ then
								context.add_string ({SCOOP_SYSTEM_CONSTANTS}.scoop_proxy_class_prefix)
							end
							context.add_string (l_as_type.class_name.name)
							if attached {GENERIC_CLASS_TYPE_AS} l_as_type as gen_typ then
								create l_assign_finder
								l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
								create interal_argument_to_substitute.default_create
								interal_argument_to_substitute.pos := pos
								interal_argument_to_substitute.type := gen_typ
								from
									feature_as.feature_names.start
								until
									feature_as.feature_names.after
								loop
									if feature_as.feature_names.item.visual_name.is_equal (feature_as.feature_name.name) then
										feature_name := feature_as.feature_names.item
									end
									feature_as.feature_names.forth
								end
								generics_to_substitute := l_assign_finder.generic_parameters_to_replace (feature_name, class_c, False, interal_argument_to_substitute, False)
								if not generics_to_substitute.is_empty then
									l_generics_visitor.set_generics_to_substitute (generics_to_substitute)
								end
								l_generics_visitor.process_internal_generics (gen_typ.generics, True, True)
							end
						end
						if i <= l_count then
							context.add_string ("; ")
							i := i + 1
						end
						pos := pos +1
						l_ids.forth
					end
				end
			end
		end

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

end -- class SCOOP_CLIENT_FEATURE_LR_VISITOR
