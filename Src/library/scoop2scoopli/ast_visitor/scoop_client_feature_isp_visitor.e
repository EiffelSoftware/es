indexing
	description: "Summary description for {SCOOP_CLIENT_FEATURE_ISP_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ISP_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_formal_argu_dec_list_as,
			process_tagged_as
--			process_static_access_as,
--			process_access_feat_as,
--			process_access_inv_as,
--			process_access_id_as,
--			process_parameter_list_as
		end

create
	make

feature -- Access

	process_individual_separate_postcondition (l_number: INTEGER; l_assertion: SCOOP_CLIENT_ASSERTION_OBJECT; l_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Process `l_as': the locking requester to the original feature.
		require
			l_assertion_not_void: l_assertion /= Void
			l_fo_not_void: l_fo /= Void
		do
			fo := l_fo
			index := l_number
			assertion := l_assertion

			-- create prefix
			create parameter_list_prefix.make_from_string ("caller_")

			-- print feature name
			context.add_string ("%N%N%T")
			context.add_string (fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + index.out + " ")

			-- process body
			process_body
		end

	process_body is
			-- processes the body of the feature
		local
			i: INTEGER
		do
			-- process internal arguments
			process_formal_argument_list_with_prefix (feature_as.body, "caller_: SCOOP_SEPARATE_TYPE")

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for separate postcondition clause " + index.out + " of routine `" + fo.feature_name + "'.")

			-- add locals
			context.add_string ("%N%T%Tlocal%N%T%T%Taux: BOOLEAN")

			-- add locals for exception handling
			context.add_string ("%N%T%T%Tl_exception: POSTCONDITION_VIOLATION")
			context.add_string ("%N%T%T%Tl_exception_factory: EXCEPTION_MANAGER_FACTORY")

			-- add do keyword
			context.add_string ("%N%T%Tdo")

			-- add expression
			context.add_string ("%N%T%T%Tif ")

			-- process separate postcondition with prefix 'caller_'
			is_print_assertion_as_expr := true
			is_print_parameters_with_prefix := true
			safe_process (assertion.get_tagged_as)
			is_print_parameters_with_prefix := false
			is_print_assertion_as_expr := false

			-- then
			context.add_string ("%N%T%T%Tthen -- Postcondition clause holds.")

			-- iterate over all separate arguments
			from
				i := 1
			until
				i > assertion.get_separate_argument_count
			loop
				context.add_string ("%N%T%T%T%Taux := " + assertion.get_i_th_separate_argument_tuple (i).argument_name)
				context.add_string (".decreased_postcondition_counter (" + assertion.get_i_th_separate_argument_tuple (i).occurrence.out + ")")

				i := i + 1
			end

			-- else part
			context.add_string ("%N%T%T%Telse")

			-- raise a postcondition exception
			context.add_string ("%N%T%T%T%Tcreate l_exception")
			context.add_string ("%N%T%T%T%Tl_exception.set_message (%"Postcondition violation: ")
			safe_process (assertion.get_tagged_as)
			context.add_string ("%")")
			context.add_string ("%N%T%T%T%Tcreate l_exception_factory")
			context.add_string ("%N%T%T%T%Tl_exception_factory.exception_manager.raise (l_exception)")

			-- end if part
			context.add_string ("%N%T%T%Tend")

			-- end body
			context.add_string ("%N%T%Tend")
		end

	process_formal_argument_list_with_prefix (l_as: BODY_AS; a_prefix: STRING) is
			-- prints internal arguments as an actual argument list,
			-- sets 'a_prefix' as a fist as a first argument.
		do
			context.add_string ("(")

			-- set flags for processing internal arguments
			is_print_with_prefix := true

			-- set prefix
			context.add_string (a_prefix)

			if l_as.internal_arguments /= void then
				context.add_string ("; ")
				-- process internal arguments
				last_index := l_as.internal_arguments.first_token (match_list).index - 1
				safe_process (l_as.internal_arguments)
			end

			-- reset flags
			is_print_with_prefix := false

			context.add_string (")")
		end

feature {NONE} -- Visitor implementation

	process_tagged_as (l_as: TAGGED_AS) is
		do
			if not is_print_assertion_as_expr then
				safe_process (l_as.tag)
				safe_process (l_as.colon_symbol (match_list))
			else
				last_index := l_as.expr.first_token (match_list).index - 1
			end
			safe_process (l_as.expr)
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS) is
			-- Process `l_as'.
		do
			if not is_print_with_prefix then
				safe_process (l_as.lparan_symbol (match_list))
			else
				last_index := l_as.arguments.first_token (match_list).index - 1
			end
			safe_process (l_as.arguments)
			if not is_print_with_prefix then
				safe_process (l_as.rparan_symbol (match_list))
			end
		end

feature {NONE} -- Visitor implementation - parameter list prefix changes

--	process_parameter_list_as (l_as: PARAMETER_LIST_AS) is
--			-- Process `l_as'.
--		do
--			safe_process (l_as.lparan_symbol (match_list))
--			if not is_print_parameters_with_prefix then
--				safe_process (l_as.parameters)
--			else
--				context.add_string (parameter_list_prefix + ", ")
--				safe_process (l_as.parameters)
--			end
--			safe_process (l_as.rparan_symbol (match_list))
--		end

--	process_static_access_as (l_as: STATIC_ACCESS_AS) is
--		do
--			safe_process (l_as.feature_keyword (match_list))
--			safe_process (l_as.class_type)
--			safe_process (l_as.dot_symbol (match_list))
--			safe_process (l_as.feature_name)
--			if l_as.internal_parameters /= Void then
--				safe_process (l_as.internal_parameters)
--			elseif is_print_parameters_with_prefix then
--				context.add_string (" (" + parameter_list_prefix + ")")
--			end
--		end

--	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
--		do
--			safe_process (l_as.feature_name)
--			if l_as.internal_parameters /= Void then
--				safe_process (l_as.internal_parameters)
--			elseif is_print_parameters_with_prefix then
--				context.add_string ("(" + parameter_list_prefix + ")")
--			end
--		end

--	process_access_inv_as (l_as: ACCESS_INV_AS) is
--		do
--			safe_process (l_as.dot_symbol (match_list))
--			safe_process (l_as.feature_name)
--			if l_as.internal_parameters /= Void then
--				safe_process (l_as.internal_parameters)
--			elseif is_print_parameters_with_prefix then
--				context.add_string ("(" + parameter_list_prefix + ")")
--			end
--		end

--	process_access_id_as (l_as: ACCESS_ID_AS) is
--		do
--			safe_process (l_as.feature_name)
--			if l_as.internal_parameters /= Void then
--				safe_process (l_as.internal_parameters)
--			elseif is_print_parameters_with_prefix then

--				context.add_string ("(" + parameter_list_prefix + ")")
--			end
--		end

feature {NONE} -- Implementation

	parameter_list_prefix: STRING
		-- prefix is used when a parameter list is processed an 'is_print_parameters_with_prefix' is true.
		-- it adds prefix as a first paramter in the list.

	is_print_parameters_with_prefix: BOOLEAN
		-- prints a parameter list with a given prefix as first parameter.

	is_print_assertion_as_expr: BOOLEAN
		-- prints the 'tagged_as' without tag and colon_symobol if is_print_assertion_as_expr is true.

	is_print_with_prefix: BOOLEAN
		-- prints the 'formal_argu_dec_list_as' with a prefix as first argument.
		-- the argument list is processed without the l- and rparan_sympbol.

	fo: SCOOP_CLIENT_FEATURE_OBJECT
		-- feature object of current processed feature.

	assertion: SCOOP_CLIENT_ASSERTION_OBJECT
		-- current processed assertion

	index: INTEGER
		-- index of current separate postcondition

end
