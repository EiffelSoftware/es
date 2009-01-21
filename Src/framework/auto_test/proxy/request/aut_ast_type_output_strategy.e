indexing
	description: "Summary description for {AUT_AST_TYPE_OUTPUT_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_AST_TYPE_OUTPUT_STRATEGY

inherit
	AST_TYPE_OUTPUT_STRATEGY
		redefine
			process_named_tuple_type_a
		end

feature -- Process

	process_named_tuple_type_a (a_type: NAMED_TUPLE_TYPE_A) is
			-- Process `a_type'.
		local
			i, count: INTEGER
		do
			if a_type.is_separate then
				text_formatter.process_symbol_text (ti_separate_keyword)
				text_formatter.add_space
			end
			process_cl_type_a (a_type)
				-- TUPLE may have zero generic parameters
			count := a_type.generics.count
			if count > 0 then
				text_formatter.add_space
				text_formatter.process_symbol_text (ti_l_bracket)
				from
					i := 1
				until
					i > count
				loop
					a_type.generics.item (i).process (Current)
					if i /= count then
						text_formatter.process_symbol_text (ti_comma)
						text_formatter.add_space
					end
					i := i + 1
				end
				text_formatter.process_symbol_text (ti_r_bracket)
			end
		end

end
