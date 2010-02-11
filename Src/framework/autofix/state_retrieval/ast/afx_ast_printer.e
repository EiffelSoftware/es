note
	description: "Summary description for {AFX_AST_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_AST_PRINTER

inherit
	AST_ITERATOR
		redefine
			process_keyword_as,
			process_symbol_as,
			process_bool_as,
			process_char_as,
			process_typed_char_as,
			process_result_as,
			process_retry_as,
			process_unique_as,
			process_deferred_as,
			process_void_as,
			process_string_as,
			process_verbatim_string_as,
			process_current_as,
			process_integer_as,
			process_real_as,
			process_id_as,
			process_break_as,
			process_symbol_stub_as,
			process_access_feat_as,
			process_parameter_list_as,
			process_paran_as,
			process_binary_as,
			process_unary_as,
			process_nested_as
		end

	REFACTORING_HELPER

feature -- Basic operations

	print_in_context (a_ast: AST_EIFFEL; a_context: ROUNDTRIP_CONTEXT)
			-- Print the text of `a_ast' into `a_context'.
		do
			fixme ("This class should be removed. Need to refactor its descendants. 27.12.2009 Jasonw")
			context := a_context
			a_ast.process (Current)
		end

feature -- Roundtrip: process leaf

	process_break_as (l_as: BREAK_AS)
			-- Process `l_as'.
		do
			check False end
		end

	process_keyword_as (l_as: KEYWORD_AS)
			-- Process `l_as'.
		do
			fixme ("Not supported for the moment. 8.12.2009 Jasonw")
		end

	process_symbol_as (l_as: SYMBOL_AS)
			-- Process `l_as'.
		local
			l_stub: SYMBOL_STUB_AS
		do
			create l_stub.make (l_as.code, 0, 0, 0, 0)
			append_string (l_stub.literal_text (Void))
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS)
			-- Process `l_as'.
		do
			check False end
		end

	process_bool_as (l_as: BOOL_AS)
		do
			append_string (l_as.value.out)
		end

	process_char_as (l_as: CHAR_AS)
		do
			append_string (l_as.value.out)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
			-- Process `l_as'.
		do
			fixme ("Do not support now. 8.12.2009 Jasonw")
		end

	process_result_as (l_as: RESULT_AS)
		do
			append_string ("Result")
		end

	process_retry_as (l_as: RETRY_AS)
		do
			fixme ("Do not support now. 8.12.2009 Jasonw")
		end

	process_unique_as (l_as: UNIQUE_AS)
		do
			fixme ("Do not support now. 8.12.2009 Jasonw")
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			fixme ("Do not support now. 8.12.2009 Jasonw")
		end

	process_void_as (l_as: VOID_AS)
		do
			append_string ("Void")
		end

	process_string_as (l_as: STRING_AS)
		do
			append_string (l_as.value)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			append_string (l_as.value)
		end

	process_current_as (l_as: CURRENT_AS)
		do
			append_string ("Current")
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			context.add_string (l_as.integer_64_value.out)
		end

	process_real_as (l_as: REAL_AS)
		do
			context.add_string (l_as.value)
		end

	process_id_as (l_as: ID_AS)
		do
			append_string (l_as.name)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			append_string (l_as.access_name)

			if attached l_as.parameters as l_para then
				append_string (" (")
				safe_process (l_para)
				append_string (")")
			end
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'.
		local
			l_cursor: CURSOR
		do
			if attached l_as.parameters as l_list then
				append_string ("(")
				l_cursor := l_list.cursor
				from
					l_list.start
				until
					l_list.after
				loop
					safe_process (l_list.item_for_iteration)
					if l_list.index < l_list.count then
						append_string (", ")
					end
					l_list.forth
				end
				l_list.go_to (l_cursor)
				append_string (")")
			end
		end

	process_paran_as (l_as: PARAN_AS)
		do
			append_string ("(")
			l_as.expr.process (Current)
			append_string (")")
		end

	process_binary_as (l_as: BINARY_AS)
		do
			l_as.left.process (Current)
			append_string (" ")
			append_string (l_as.op_name.name)
			append_string (" ")
			l_as.right.process (Current)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			append_string (l_as.operator_name)
			append_string (" ")
			l_as.expr.process (Current)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			l_as.target.process (Current)
			append_string (".")
			l_as.message.process (Current)
		end

feature{NONE} -- Implementation

	context: ROUNDTRIP_CONTEXT
			-- Context to store printed text

	append_string (a_str: STRING)
			-- Append `a_str' into `context'.
		do
			context.add_string (a_str)
		end

end
