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
			process_access_feat_as
		end

create
	make

feature -- Initialisation

	make(a_ctxt: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		do
			Precursor (a_ctxt)

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

			-- print feature name
			context.add_string ("%N%N%T" + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_wait_condition ")

			-- process body
			last_index := l_as.start_position
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			i: INTEGER
			r_as: ROUTINE_AS
		do
			safe_process (l_as.internal_arguments)

			-- Retun type is 'BOOLEAN'
			if l_as.type /= Void then
				safe_process (l_as.colon_symbol (match_list))
				context.add_string (" BOOLEAN ")
				last_index := l_as.type.end_position
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
					is_print_with_processor_postfix := true
					safe_process (fo.preconditions.wait_conditions.i_th (i).get_tagged_as)
					is_print_with_processor_postfix := false
					context.add_string (")")
					i := i + 1
				end

				-- add end keyword
				context.add_string ("%N%T%Tend")
			end
		end

	process_tagged_as (l_as: TAGGED_AS) is
		do
			-- print only expression of the wait condition
			last_index := l_as.expr.start_position - 1
			safe_process (l_as.expr)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
		do
			safe_process (l_as.feature_name)

			-- if processing preconditions append ".implementation_" if the target is separate.
			if class_c.feature_table.has (l_as.feature_name.name.as_lower) then
					if class_c.feature_table.item (l_as.feature_name.name.as_lower).type.is_separate then
						context.add_string (".implementation_")
					end
			elseif fo.arguments.is_separate_argument(l_as.feature_name.name.as_lower) then
				-- current argument list contains actual feature name with separate type
				context.add_string (".implementation_")
			end

			safe_process (l_as.internal_parameters)
		end

feature {NONE} -- Implementation

	is_print_with_processor_postfix: BOOLEAN
		-- indicates that a postfix '.processor' is added to an id_as element

	fo: SCOOP_CLIENT_FEATURE_OBJECT
		-- feature object of current processed feature.

end
