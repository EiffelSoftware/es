indexing
	description: "Summary description for {SCOOP_CLIENT_FEATURE_WC_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_WC_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			make,
			process_body_as,
			process_tagged_as,
			process_access_feat_as,
			process_access_assert_as,
			process_static_access_as,
			process_result_as,
			process_binary_as
		end

create
	make

feature -- Initialisation

	make(a_ctxt: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		do
			Precursor (a_ctxt)
		end

feature -- Access

	process_feature_body (l_as: BODY_AS; l_fo: SCOOP_CLIENT_FEATURE_OBJECT)
			-- Process `l_as': the locking requester to the original feature.
		require
			l_fo_not_void: l_fo /= Void
			l_fo_preconditions_not_void: l_fo.preconditions /= Void
			l_fo_postconditions_not_void: l_fo.postconditions /= Void
		do
			fo := l_fo

			-- print feature name
			context.add_string ("%N%N%T" + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_wait_condition ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS)
		local
			i: INTEGER
			r_as: ROUTINE_AS
		do
			safe_process (l_as.internal_arguments)

			-- Retun type is 'BOOLEAN'
			if l_as.type /= Void then
				safe_process (l_as.colon_symbol (match_list))
				context.add_string (" BOOLEAN ")
				last_index := l_as.type.last_token (match_list).index
			else
				context.add_string (": BOOLEAN ")
			end

			-- proceed
			safe_process (l_as.assign_keyword (match_list))
			safe_process (l_as.assigner)
			safe_process (l_as.is_keyword (match_list))

			r_as ?= l_as.content
			if r_as /= Void then
				safe_process (l_as.indexing_clause)

				-- add comment
				context.add_string ("%N%T%T%T-- Wrapper for wait-condition of enclosing routine `" + fo.feature_name + "'.")

				-- add do keyword
				context.add_string ("%N%T%Tdo")

				-- add 'Result'
				context.add_string ("%N%T%T%TResult := True")

				-- add precondition expressions with 'and then'
				from
					i := 1
				until
					i > fo.preconditions.wait_conditions.count
				loop
					context.add_string ("%N%T%T%T%Tand then (")
					safe_process (fo.preconditions.wait_conditions.i_th (i).get_tagged_as)
					context.add_string (")")
					i := i + 1
				end

				-- add end keyword
				context.add_string ("%N%T%Tend")
			end
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			-- print only expression of the wait condition
			last_index := l_as.expr.first_token (match_list).index - 1
			safe_process (l_as.expr)
		end

feature {NONE}
	process_binary_as (l_as: BINARY_AS)
		do
			safe_process (l_as.left)
			safe_process (l_as.operator (match_list))
			safe_process (l_as.right)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			if current_level.type.is_separate then
				context.add_string (".implementation_")
				set_current_level_is_separate (false)
			end

			process_internal_parameters(l_as.internal_parameters)
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			if current_level.type.is_separate then
				context.add_string (".implementation_")
				set_current_level_is_separate (false)
			end

			process_internal_parameters(l_as.internal_parameters)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			safe_process (l_as.feature_keyword (match_list))
			safe_process (l_as.class_type)
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			if current_level.type.is_separate then
				context.add_string (".implementation_")
				set_current_level_is_separate (false)
			end

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_result_as (l_as: RESULT_AS)
		do
			Precursor (l_as)
			if current_level.type.is_separate then
				context.add_string (".implementation_")
				set_current_level_is_separate (false)
			end
		end

feature {NONE} -- Implementation
	fo: SCOOP_CLIENT_FEATURE_OBJECT
		-- feature object of current processed feature.

end
