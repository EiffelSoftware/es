note
	description: "Summary description for {EPA_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_UTILITY

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

	SHARED_WORKBENCH

	SHARED_EIFFEL_PARSER

	SHARED_SERVER

feature -- AST

	text_from_ast (a_ast: AST_EIFFEL): STRING
			-- Text from `a_ast'
		require
			a_ast_attached: a_ast /= Void
		do
			ast_printer_output.reset
			ast_printer.print_ast_to_output (a_ast)
			Result := ast_printer_output.string_representation
		end

	ast_printer: ETR_AST_STRUCTURE_PRINTER
			-- AST printer
		local
			l_output: ETR_AST_STRING_OUTPUT
		once
			create Result.make_with_output (ast_printer_output)
		end

	ast_printer_output: ETR_AST_STRING_OUTPUT
			-- Output for `ast_printer'
		once
			create Result.make_with_indentation_string ("%T")
		end

	ast_from_text (a_text: STRING): AST_EIFFEL
			-- AST node from `a_text'
			-- `a_text' must be able to be parsed in to a single AST node.
		local
			l_text: STRING
		do
			l_text := "feature foo do " + a_text + "%Nend"
			entity_feature_parser.parse_from_string (l_text, Void)

			if attached {ROUTINE_AS} entity_feature_parser.feature_node.body.as_routine as l_routine then
				if attached {DO_AS} l_routine.routine_body as l_do then
					if l_do.compound.count = 1 then
						Result := l_do.compound.first
					end
				end
			end
			check Result /= Void end
		end

feature -- Feature related

	arguments_of_feature (a_feature: FEATURE_I): DS_HASH_TABLE [INTEGER, STRING]
			-- Table of formal argument names in `a_feature'
			-- Key is the argument name, value is its index in the feature signature.
			-- The equality tester of the result is case insensitive equality tester.
		local
			i: INTEGER
			l_count: INTEGER
		do
			l_count := a_feature.argument_count
			create Result.make (l_count)
			Result.set_key_equality_tester (case_insensitive_string_equality_tester)

			if l_count > 0 then
				from
					i := 1
				until
					i > l_count
				loop
					Result.put (i, a_feature.arguments.item_name (i))
					i := i + 1
				end
			end
		end

	local_names_of_feature (a_feature: FEATURE_I): DS_HASH_SET [STRING]
			-- Set of local variable names in `a_feature'
			-- The equality tester of the result is case insensitive equality tester.
		do
			create Result.make (10)
			Result.set_equality_tester (case_insensitive_string_equality_tester)

			if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
				if l_routine.locals /= Void then
					l_routine.locals.do_all (
						agent (a_type_dec: TYPE_DEC_AS; a_result: DS_HASH_SET [STRING])
							local
								i: INTEGER
								c: INTEGER
							do
								from
									c := a_type_dec.id_list.count
									i := 1
								until
									i > c
								loop
									a_result.force_last (a_type_dec.item_name (i))
									i := i + 1
								end
							end (?, Result))
				end
			end
		end


end
