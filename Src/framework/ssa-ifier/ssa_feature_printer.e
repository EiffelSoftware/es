note
	description: "Used to print a feature body in SSA form."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_FEATURE_PRINTER

inherit
	AST_ITERATOR
		redefine
			process_nested_as,
			process_access_feat_as,
--			process_access_id_as,
			process_assign_as,
			process_id_as,
			process_binary_as,
			process_unary_as,
--			process_do_as,
--			process_keyword_as,
--			process_symbol_as,
			process_bool_as,
--			process_char_as,
--			process_typed_char_as,
--			process_result_as,
--			process_retry_as,
--			process_unique_as,
--			process_deferred_as,
--			process_void_as,
--			process_string_as,
--			process_verbatim_string_as,
--			process_current_as,
			process_integer_as
--			process_real_as,
--			process_break_as,
--			process_symbol_stub_as
		end

	INTERNAL_COMPILER_STRING_EXPORTER

	SSA_SHARED

	SHARED_SERVER

create
	make

feature
	make
		do
			context := ""
			in_body := True
		end

feature -- AST
	process_assign_as (l_as: ASSIGN_AS)
		do
			put_raw_string (l_as.target.access_name)
			put_raw_string (" := ")
			put_raw_string (fix_print (l_as.source))
		end

	in_body: BOOLEAN


	process_id_as (l_as: ID_AS)
		do
			fix_print_basic (l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			fix_print_basic (l_as)
		end

	process_binary_as (l_as: BINARY_AS)
		do
			fix_print_basic (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			fix_print_basic (l_as)
		end

	process_bool_as (l_as: BOOL_AS)
		do
			fix_print_basic (l_as)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			fix_print_basic (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			fix_print_basic (l_as)
		end

	fix_print_basic (l_as: AST_EIFFEL)
		do
			if attached fix_print (l_as) then
			end
		end

	fix_print (l_as: AST_EIFFEL): STRING
		local
			fix: EXPR_FIXER
			expr: SSA_EXPR
			repls: LIST [SSA_REPLACEMENT]
		do
			if in_body then
				create fix.make
				l_as.process (fix)
				expr := fix.last_expr
				repls := expr.replacements

				from repls.start
				until repls.after
				loop
					Result := repls.item.var
					put_raw_string ("%N" + "-- planning step")
					put_raw_string ("%N" + Result  + " := " + repls.item.repl_text)
					repls.forth
				end
			else
--				put_raw_string (l_as.text (match_list))
			end
		end

feature
	context: STRING

	put_raw_string (a_str: STRING)
		do
			context := context + a_str
		end
end
