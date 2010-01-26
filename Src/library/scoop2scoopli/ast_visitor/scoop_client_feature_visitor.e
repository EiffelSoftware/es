note
	description: "[
					Roundtrip visitor to process feature node (`FEATURE_AS' node) in
					SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_feature_as,
			process_keyword_as
		end
		
	SCOOP_BASIC_TYPE

create
	make

feature -- Access

	process_feature(l_as: FEATURE_AS) is
			-- Process `l_as'.
		do
			safe_process (l_as)
		end

feature {NONE} -- Visitor implementation

	process_feature_as (l_as: FEATURE_AS) is
		local
			i, nb: INTEGER
			l_infix_prefix: INFIX_PREFIX_AS
			is_separate: BOOLEAN
			l_feature_object: SCOOP_CLIENT_FEATURE_OBJECT
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_argument_visitor: SCOOP_CLIENT_ARGUMENT_VISITOR
			l_feature_assertion_visitor: SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR
			l_feature_lr_visitor: SCOOP_CLIENT_FEATURE_LR_VISITOR
			l_feature_er_visitor: SCOOP_CLIENT_FEATURE_ER_VISITOR
			l_feature_wc_visitor: SCOOP_CLIENT_FEATURE_WC_VISITOR
			l_feature_nsp_visitor: SCOOP_CLIENT_FEATURE_NSP_VISITOR
			l_feature_sp_visitor: SCOOP_CLIENT_FEATURE_SP_VISITOR
		do
			set_current_feature_as (l_as)

			if l_as.is_attribute or l_as.is_constant then
				last_index := l_as.first_token (match_list).index - 1
				context.add_string ("%N%N%T")
				safe_process (l_as.feature_names)
				safe_process (l_as.body)
			else -- routine
				-- create feature object
				create l_feature_object
				set_feature_object (l_feature_object)

				-- get feature name visitor
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

				-- create an argument visitor
				l_argument_visitor := scoop_visitor_factory.new_client_argument_visitor_for_class (parsed_class, match_list)
				-- create assertion visitor
				l_feature_assertion_visitor := scoop_visitor_factory.new_client_feature_assertion_visitor (context)
				-- create locking request body (feature, procedure, deferred routines)
				l_feature_lr_visitor := scoop_visitor_factory.new_client_feature_lr_visitor (context)
				-- create enclosing routine body (feature, procedure, deferred routines)
				l_feature_er_visitor := scoop_visitor_factory.new_client_feature_er_visitor (context)
				-- create wait condition wrapper (feature, procedure, deferred routines)
				l_feature_wc_visitor := scoop_visitor_factory.new_client_feature_wc_visitor (context)
				-- create non separate postcondition clauses wrapper
				l_feature_nsp_visitor := scoop_visitor_factory.new_client_feature_nsp_visitor (context)
				-- create separate postcondition clauses wrapper
				l_feature_sp_visitor := scoop_visitor_factory.new_client_feature_sp_visitor (context)

				-- create for each feature name a new body
				-- (and also for the other SCOOP routines)
				from
					i := 1
					nb := l_as.feature_names.count
				until
					i > nb
				loop
					is_separate := false
					-- check if there are separate arguments
					if l_as.body /= Void and then l_as.body.internal_arguments /= void then
						l_feature_object.set_arguments (l_argument_visitor.process_arguments (l_as.body.internal_arguments))

						if l_feature_object.arguments.has_separate_arguments then
							is_separate := true
						end
					end

					-- identify frozen key word
					last_index := l_as.feature_names.i_th (i).first_token (match_list).index
					if l_as.feature_names.i_th (i).is_frozen and then
					   l_as.feature_names.i_th (i).frozen_keyword.index /= 0 then
						l_feature_object.is_feature_frozen.set_item (true)
					end

					-- process name
					l_feature_name_visitor.process_feature_name (l_as.feature_names.i_th (i), false)
					l_feature_object.set_feature_name (l_feature_name_visitor.get_feature_name)
					l_feature_name_visitor.process_feature_name (l_as.feature_names.i_th (i), true)
					l_feature_object.set_feature_alias_name (l_feature_name_visitor.get_feature_name)
					-- declaration name writes the infix and non-infix notation if the feature name
					-- contains an infix name. Change this to an alias notation in EiffelStudio 6.4
					l_feature_name_visitor.process_feature_declaration_name (l_as.feature_names.i_th (i))
					l_feature_object.set_feature_declaration_name (l_feature_name_visitor.get_feature_name)

					if is_separate then

						-- assertion visitor
						l_feature_assertion_visitor.process_feature_body (l_as.body, l_feature_object)

						-- get result objects
						l_feature_object.set_preconditions (l_feature_assertion_visitor.get_preconditions)
						l_feature_object.set_postconditions (l_feature_assertion_visitor.get_postconditions)

						-- locking request body (feature, procedure, deferred routines)
						l_feature_lr_visitor.process_feature_body (l_as.body, l_feature_object)

						-- enclosing routine body (feature, procedure, deferred routines)
						l_feature_er_visitor.process_feature_body (l_as.body, l_feature_object)

						-- wait condition wrapper (feature, procedure, deferred routines)
						l_feature_wc_visitor.process_feature_body (l_as.body, l_feature_object)

						-- postcondition processing
						if not l_feature_object.postconditions.separate_postconditions.is_empty then

							-- unseparated postcondition attribute
							create_unseparated_postcondition_attribute (l_feature_object)
						end

						if not l_feature_object.postconditions.non_separate_postconditions.is_empty then
							-- non separate postcondition clauses wrapper
							l_feature_nsp_visitor.process_feature_body (l_as.body, l_feature_object)
						end

						if not l_feature_object.postconditions.separate_postconditions.is_empty then
							-- separate postcondition clauses wrapper
							l_feature_sp_visitor.process_feature_body (l_as.body, l_feature_object)
						end

						-- postcondition processing
						if not l_feature_object.postconditions.separate_postconditions.is_empty then

							-- wrappers for individual separate postcondition clauses
							create_separate_postcondition_wrapper (l_feature_object)
						end

					else
							-- print original feature
						context.add_string ("%N%N%T")
						if l_feature_object.is_feature_frozen then
							context.add_string ("frozen ")
						end
						context.add_string (l_feature_object.feature_alias_name + " ")
						last_index := l_as.body.first_token (match_list).index - 1

						safe_process (l_as.body)

						-- add a wrapper feature from the old infix notation to
						-- the non-infix notation version
						-- Remove this call with EiffelStudio 6.4
						l_infix_prefix ?= l_as.feature_names.i_th (i)
						if l_infix_prefix /= Void then
							l_feature_name_visitor.process_declaration_infix_prefix (l_infix_prefix)

							create_infix_feature_wrapper(l_as, l_feature_name_visitor.get_feature_name, l_feature_object.feature_name)
						end
					end

					i := i + 1
				end

			end

			-- invalidate workbench access
			set_current_feature_as_void
		end

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Process `l_as'.
		do
			if l_as.is_frozen_keyword then
				Precursor (l_as)
				-- add a space after the frozen keyword before printing the feature name
				context.add_string (" ")
			else
				Precursor (l_as)
			end
		end

feature {NONE} -- Implementation

	create_infix_feature_wrapper (l_as: FEATURE_AS; an_original_feature_name, a_feature_name: STRING) is
			-- Remove this feature with EiffelStudio 6.4
			-- It creates a wrapper feature so that a call on a infix feature
			-- is wrapped to the non-infix version
		local
			i, nb: INTEGER
			l_last_index: INTEGER
			l_type_dec: TYPE_DEC_AS
			l_argument_list: FORMAL_ARGU_DEC_LIST_AS
		do
			-- save index
			l_last_index := last_index

			context.add_string ("%N%N%T" + an_original_feature_name + " ")

			last_index := l_as.body.first_token (match_list).index - 1

			safe_process (l_as.body.internal_arguments)
			safe_process (l_as.body.colon_symbol (match_list))
			safe_process (l_as.body.type)
			-- skip assigner
			--safe_process (l_as.assign_keyword (match_list))
			--safe_process (l_as.assigner)
			last_index := l_as.body.is_keyword_index - 1
			context.add_string (" ")
			safe_process (l_as.body.is_keyword (match_list))

			-- add comment
			context.add_string ("%N%T%T%T-- Feature wrapper for infix / prefix feature.")
			context.add_string ("%N%T%T%T-- Hack for EiffelStudio 6.3")

			if l_as.is_deferred then
				-- add deferred keyword
				context.add_string ("%N%T%Tdeferred")
			else
				-- add do keyword
				context.add_string ("%N%T%Tdo")

				-- add call to non_infix feature
				context.add_string ("%N%T%T%TResult := " + a_feature_name + " ")

				-- add internal argument as actual arguments
				if l_as.body.internal_arguments /= Void then
					l_argument_list := l_as.body.internal_arguments

					-- add bracket
					context.add_string ("(")

					from
						i := 1
						nb := l_argument_list.arguments.count
					until
						i > nb
					loop
						l_type_dec := l_argument_list.arguments.i_th (i)

						last_index := l_type_dec.first_token (match_list).index - 1
						process_identifier_list (l_type_dec.id_list)

						if i < nb then
							context.add_string (", ")
						end

						i := i + 1
					end

					-- add bracket
					context.add_string (")")
				end
			end

			-- add end keyword
			context.add_string ("%N%T%Tend")

			-- restore current index
			last_index := l_last_index
		end

	create_unseparated_postcondition_attribute (a_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Generate list of unseparated postconditions.
			-- Unseparated postconditions are separate postcondition that
			-- involve a non-separate object at run time. They are treated as
			-- non-separate postconditions.
		require
			a_fo_not_void: a_fo /= Void
		do
			context.add_string ("%N%N%T" + a_fo.feature_name + "_scoop_separate_" + class_c.name.as_lower +
								"_unseparated_postconditions: LINKED_LIST [ROUTINE [ANY, TUPLE]]")
			context.add_string ("%N%T%T-- Precondition clauses of `" + a_fo.feature_name + "' that seem to be separate but are not.")
			context.add_string ("%N%T%T-- They have to be processed as correctness conditions.")
		end

	create_separate_postcondition_wrapper  (a_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Generate wrappers for individual separate postcondition clauses.
		require
			a_fo_not_void: a_fo /= Void
		local
			i: INTEGER
			an_assertion: SCOOP_CLIENT_ASSERTION_OBJECT
			l_feature_isp_visitor: SCOOP_CLIENT_FEATURE_ISP_VISITOR
		do
			-- create visitor for individual separate postcondition clauses.
			l_feature_isp_visitor := scoop_visitor_factory.new_client_feature_isp_visitor (context)

			-- iterate over all separate postconditions
			from
				i := 1
			until
				i > a_fo.postconditions.separate_postconditions.count
			loop
				-- get assertion
				an_assertion := a_fo.postconditions.separate_postconditions.i_th (i)

				-- process feature
				l_feature_isp_visitor.process_individual_separate_postcondition (i, an_assertion, a_fo)

				i := i + 1
			end
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

end -- class SCOOP_CLIENT_FEATURE_VISITOR
