note
	description: "[
					Roundtrip visitor to create enclosing routine in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ER_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_body_as,
			process_precursor_as,
			process_ensure_as,
			process_routine_as,
			process_access_feat_as,
			process_access_assert_as,
			process_static_access_as,
			process_result_as,
			process_binary_as
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

create
	make

feature -- Access

	process_feature_body (l_as: BODY_AS; l_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Process `l_as': the locking requester to the original feature.
		require
			l_fo_not_void: l_fo /= Void
			l_fo_preconditions_not_void: l_fo.preconditions /= Void
			l_fo_postconditions_not_void: l_fo.postconditions /= Void
		do
			fo := l_fo

			-- print feature name
			context.add_string ("%N%N%T" + fo.feature_name + "_scoop_separate_")
			context.add_string (class_c.name.as_lower + "_enclosing_routine ")

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
				context.add_string ("%N%T%T%T-- Wrapper for enclosing routine `" + fo.feature_name.as_lower + "'.")

					-- process body (routine_as)
				safe_process (l_as.content)
			end
		end

	process_routine_as (l_as: ROUTINE_AS)
		local
			r_as: ROUTINE_AS
		do
				-- process 'l_as'
			safe_process (l_as.obsolete_keyword (match_list))
			safe_process (l_as.obsolete_message)

			processing_preconditions := True
			safe_process (l_as.precondition)

			processing_preconditions := False

			safe_process (l_as.internal_locals)
			safe_process (l_as.routine_body)
			safe_process (l_as.postcondition)
			safe_process (l_as.rescue_keyword (match_list))
			safe_process (l_as.rescue_clause)

				-- process end keyword
			context.add_string ("%N%T%T")
			last_index := l_as.end_keyword.first_token (match_list).index - 1
			safe_process (l_as.end_keyword)
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		local
			l_parent: STRING
		do
			last_index := l_as.first_token (match_list).index - 1

				-- print normal call to inherited feature
			context.add_string ("%N%T%T%T" + fo.feature_name + "_scoop_separate_")

			if l_as.parent_base_class /= Void then
				create l_parent.make_from_string (l_as.parent_base_class.class_name.name.as_lower)
				context.add_string (l_parent + "_enclosing_routine ")
			else
					-- get name of parent base class		
				l_parent := precursor_parent (fo.feature_name)
				if l_parent /= Void then
					context.add_string (l_parent.as_lower + "_enclosing_routine ")
				else
					error_handler.insert_error (create {INTERNAL_ERROR}.make (
							"In {SCOOP_CLIENT_FEATURE_ER_VISITOR}.process_precursor_as could%N%
							%not find a valid parent for the Precursor statement."))
				end
			end
			if l_as.internal_parameters /= void then
				last_index := l_as.internal_parameters.first_token (match_list).index - 1
			end

			update_current_level_with_call (l_as)
			process_internal_parameters(l_as.internal_parameters)
			last_index := l_as.last_token (match_list).index
		end

	process_ensure_as (l_as: ENSURE_AS) is
		local
			i: INTEGER
			a_post_condition: TAGGED_AS
		do
			context.add_string ("%N%T%Tensure")

				-- separate argument increased postcondition counter call
			if fo.arguments.has_separate_arguments and then fo.arguments.has_postcondition_occurrence then
				from
					i := 1
				until
					i > fo.arguments.separate_arguments.count
				loop
					context.add_string ("%N%T%T%T")
					context.add_string (fo.arguments.get_i_th_postcondition_argument_name (i))
					context.add_string (".increased_postcondition_counter (")
					context.add_string (fo.arguments.get_i_th_postcondition_argument_count (i).out)
					context.add_string (")")
					i := i + 1
				end
			end

				-- print immediate postcondition clauses.
			from
				i := 1
			until
				i > fo.postconditions.immediate_postconditions.count
			loop
				a_post_condition := fo.postconditions.immediate_postconditions.i_th (i).tagged_as
				last_index := a_post_condition.first_token (match_list).index - 1
				context.add_string ("%N%T%T%T")
				safe_process (a_post_condition)
				i := i + 1
			end

			if l_as /= Void then
				last_index := l_as.last_token (match_list).index
			end
		end

feature {NONE} -- Adding .implementation_ for precondition processing.
	processing_preconditions : BOOLEAN

	process_binary_as (l_as: BINARY_AS)
		do
			if processing_preconditions then
				safe_process (l_as.left)
				safe_process (l_as.operator (match_list))
				safe_process (l_as.right)
			else
				Precursor (l_as)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if processing_preconditions then
				safe_process (l_as.feature_name)

				update_current_level_with_call (l_as)

				if current_level.type.is_separate then
					context.add_string (".implementation_")
					set_current_level_is_separate (False)
				end

				process_internal_parameters(l_as.internal_parameters)
			else
				Precursor (l_as)
			end
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			if processing_preconditions then
				safe_process (l_as.feature_name)

				update_current_level_with_call (l_as)

				if current_level.type.is_separate then
					context.add_string (".implementation_")
					set_current_level_is_separate (False)
				end

				process_internal_parameters(l_as.internal_parameters)
			else
				Precursor (l_as)
			end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			if processing_preconditions then
				safe_process (l_as.feature_keyword (match_list))
				safe_process (l_as.class_type)
				safe_process (l_as.dot_symbol (match_list))
				safe_process (l_as.feature_name)

				update_current_level_with_call (l_as)

				if current_level.type.is_separate then
					context.add_string (".implementation_")
					set_current_level_is_separate (False)
				end

				-- process internal parameters and add current if target is of separate type.
				process_internal_parameters(l_as.internal_parameters)
			else
				Precursor (l_as)
			end
		end

	process_result_as (l_as: RESULT_AS)
		do
			Precursor (l_as)
			if processing_preconditions and current_level.type.is_separate then
				context.add_string (".implementation_")
				set_current_level_is_separate (False)
			end
		end

feature {NONE} -- Node implementation

	precursor_parent (a_feature_name: STRING): STRING is
			-- returns the parent of a precursor feature.
			-- traverses the redefining list of the parents.
		local
			i, j: INTEGER
		do
			from
				i := 1
			until
				i > parsed_class.parents.count
			loop
				if parsed_class.parents.i_th (i).redefining /= Void then
					from
						j := 1
					until
						j > parsed_class.parents.i_th (i).redefining.count
					loop
						if parsed_class.parents.i_th (i).redefining.i_th (i).internal_name.name.is_equal (a_feature_name) then
							Result := parsed_class.parents.i_th (i).type.class_name.name
						end
						j := j + 1
					end

				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	fo: SCOOP_CLIENT_FEATURE_OBJECT
			-- feature object of current processed feature.

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

end -- class SCOOP_CLIENT_FEATURE_ER_VISITOR
