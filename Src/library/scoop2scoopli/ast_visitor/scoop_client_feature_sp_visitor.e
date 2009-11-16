indexing
	description: "Summary description for {SCOOP_CLIENT_FEATURE_SP_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_SP_VISITOR


inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_body_as,
			process_formal_argu_dec_list_as,
			process_type_dec_as
		end
	SCOOP_WORKBENCH

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
			context.add_string ("%N%N%T" + fo.feature_name + "_scoop_separate_" +
								class_c.name.as_lower + "_separate_postcondition ")

			-- process body
			last_index := l_as.start_position
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			i: INTEGER
			an_assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT
		do
			safe_process (l_as.internal_arguments)

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for separate postconditions of enclosing routine `" + fo.feature_name + "'.")

			-- add 'do' keyword
			context.add_string ("%N%T%Tdo")

			-- add call
			context.add_string ("%N%T%T%Tcreate " + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_unseparated_postconditions.make")

			-- add 'ensure' keyword
			context.add_string ("%N%T%Tensure")

			-- add comment
			context.add_string (" -- Operations are expressed as postconditions to allow for switching them on and off.")

			from
				i := 1
			until
				i > fo.postconditions.separate_postconditions.count
			loop
				-- get assertion object
				an_assertion_object := fo.postconditions.separate_postconditions.i_th (i)

				context.add_string ("%N%T%T%Tevaluated_as_separate_postcondition (")
				-- first argument: list of separate arguments
				context.add_string (an_assertion_object.get_separate_argument_list_as_string (false))
				-- second argument: agent
				context.add_string (", agent " + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + i.out + " ")
				process_formal_argument_list_as_actual_argument_list_with_prefix (l_as, an_assertion_object.get_i_th_separate_argument_tuple (1).argument_name)
				context.add_string (")")

				-- postcondition added_to_unseparated_postconditions
				context.add_string ("%N%T%T%T%Tor else added_to_unseparated_postconditions (" + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_unseparated_postconditions,")
				context.add_string ("%N%T%T%T%Tagent " + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + i.out + " ")
				process_formal_argument_list_as_actual_argument_list_with_prefix (l_as, "Current")

				context.add_string (")")
				i := i + 1
			end

			-- add 'end' keyword'
			context.add_string ("%N%T%Tend")
		end

	process_formal_argument_list_as_actual_argument_list_with_prefix (l_as: BODY_AS; a_prefix: STRING) is
			-- prints internal arguments as an actual argument list,
			-- sets 'a_prefix' as a fist as a first argument.
		do
			context.add_string ("(")

			-- set flags for processing internal arguments
			is_print_with_prefix := true
			is_print_as_actual_argument_list := true

			-- set prefix
			context.add_string (a_prefix)

			if l_as.internal_arguments /= void then
				context.add_string (", ")
				-- process internal arguments
				last_index := l_as.internal_arguments.start_position - 1
				safe_process (l_as.internal_arguments)
			end

			-- reset flags
			is_print_as_actual_argument_list := false
			is_print_with_prefix := false

			context.add_string (")")
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS) is
			-- Process `l_as'.
		do
			if not is_print_with_prefix then
				safe_process (l_as.lparan_symbol (match_list))
			else
				last_index := l_as.arguments.start_position - 1
			end
			safe_process (l_as.arguments)

			if not is_print_with_prefix then
				safe_process (l_as.rparan_symbol (match_list))
			end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS) is
		do
			process_identifier_list (l_as.id_list)
			if not is_print_as_actual_argument_list then
				safe_process (l_as.colon_symbol (match_list))
				safe_process (l_as.type)
			end
		end

feature {NONE} -- Implementation

	is_print_with_prefix: BOOLEAN
		-- prints the 'formal_argu_dec_list_as' with a prefix as first argument.
		-- the argument list is processed without the l- and rparan_sympbol.

	is_print_as_actual_argument_list: BOOLEAN
		-- prints the 'type_dec_as' as actual argument list.

	fo: SCOOP_CLIENT_FEATURE_OBJECT
		-- feature object of current processed feature.

end
