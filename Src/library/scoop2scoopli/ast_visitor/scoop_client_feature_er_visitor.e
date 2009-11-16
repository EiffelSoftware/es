indexing
	description: "Summary description for {SCOOP_CLIENT_FEATURE_ER_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ER_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_body_as,
			process_access_feat_as,
			process_precursor_as,
			process_ensure_as,
			process_routine_as
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
			last_index := l_as.start_position
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

	process_routine_as (l_as: ROUTINE_AS) is
		do
				-- process 'l_as'
			safe_process (l_as.obsolete_keyword (match_list))
			safe_process (l_as.obsolete_message)
			safe_process (l_as.precondition)
			safe_process (l_as.internal_locals)
			safe_process (l_as.routine_body)
			safe_process (l_as.postcondition)
			safe_process (l_as.rescue_keyword (match_list))
			safe_process (l_as.rescue_clause)

				-- process end keyword
			context.add_string ("%N%T%T")
			last_index := l_as.end_keyword.start_position - 1
			safe_process (l_as.end_keyword)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
		local
			is_print_without_caller: BOOLEAN
		do
			safe_process (l_as.feature_name)

			-- if processing preconditions append ".implementation_" if the target is separate.
			if class_c.feature_table.has (l_as.feature_name.name.as_lower) then
					if class_c.feature_table.item (l_as.feature_name.name.as_lower).type.is_separate then
						context.add_string (".implementation_")
						is_print_without_caller := true
					end
			elseif fo.arguments.is_separate_argument(l_as.feature_name.name.as_lower) then
				-- current argument list contains actual feature name with separate type
				context.add_string (".implementation_")
				is_print_without_caller := true
			end

			-- process internal parameters and add current if target is of separate type.
			increase_nested_level
			process_internal_parameters(l_as.internal_parameters)
			decrease_nested_level

			-- get 'is_separate' information about current call for next expr
			if not is_print_without_caller then
				set_current_level_is_separate (evaluate_id(l_as.feature_name))
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		local
			l_parent: STRING
		do
			last_index := l_as.start_position - 1

				-- print normal call to inherited feature
			context.add_string ("%N%T%T%T" + fo.feature_name + "_scoop_separate_")

			if l_as.parent_base_class /= Void then
				create l_parent.make_from_string (l_as.parent_base_class.class_name.name.as_lower)
				context.add_string (l_parent + "_enclosing_routine ")
			else
					-- get name of parent base class		
				l_parent := get_precursor_parent (fo.feature_name)
				if l_parent /= Void then
					context.add_string (l_parent.as_lower + "_enclosing_routine ")
				else
					error_handler.insert_error (create {INTERNAL_ERROR}.make (
							"In {SCOOP_CLIENT_FEATURE_ER_VISITOR}.process_precursor_as could%N%
							%not find a valid parent for the Precursor statement."))
				end
			end
			if l_as.internal_parameters /= void then
				last_index := l_as.internal_parameters.start_position - 1
			end

			increase_nested_level
			process_internal_parameters(l_as.internal_parameters)
			decrease_nested_level
			last_index := l_as.end_position
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
				a_post_condition := fo.postconditions.immediate_postconditions.i_th (i).get_tagged_as
				last_index := a_post_condition.start_position - 1
				context.add_string ("%N%T%T%T")
				safe_process (a_post_condition)
				i := i + 1
			end

			if l_as /= Void then
				last_index := l_as.end_position
			end
		end

feature {NONE} -- Node implementation

	get_precursor_parent (a_feature_name: STRING): STRING is
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

end
