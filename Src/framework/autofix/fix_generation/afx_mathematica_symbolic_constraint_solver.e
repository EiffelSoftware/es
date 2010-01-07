note
	description: "Summary description for {AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER

inherit
	AFX_SYMBOLIC_CONSTRAINT_SOLVER

	KL_SHARED_STRING_EQUALITY_TESTER

	AFX_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize.
		do
			config := a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Config used in current AutoFix session

feature -- Solve

	maximize (a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION])
			-- Maximize the value of `a_function' under constraints `a_constraints', with respect to `a_arguments'.
			-- Store results in `last_solutions'.
			-- If there is no solution, make `lasT_solutions' empty.
		do
			solve_internal ("Maximize", a_function, a_constraints, a_arguments)
		end

	minimize (a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION])
			-- Minimize the value of `a_function' under constraints `a_constraints', with respect to `a_arguments'.
			-- Store results in `last_solutions'.
			-- If there is no solution, make `lasT_solutions' empty.
		do
			solve_internal ("Minimize", a_function, a_constraints, a_arguments)
		end

	solve (a_maximize: BOOLEAN; a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION])
			-- Maximize or Minimize (depending on `a_maximize') the value of `a_function' under constraints `a_constraints', with respect to `a_arguments'.
			-- Store results in `last_solutions'.
			-- If there is no solution, make `lasT_solutions' empty.
		do
			if a_maximize then
				maximize (a_function, a_constraints, a_arguments)
			else
				minimize (a_function, a_constraints, a_arguments)
			end
		end

feature{NONE} -- Implementation

	expression_name_table: HASH_TABLE [AFX_EXPRESSION, STRING]
			-- Table for expression and their short names
			-- Key is a short name, value is the expression associated with that short name.
			-- short names are used in Mathematica.

	name_expression_table: HASH_TABLE [STRING, AFX_EXPRESSION]
			-- Table for expression and their short names
			-- Key is an expression, value is the short name associated with that expression.
			-- short names are used in Mathematica.

	expressions: DS_ARRAYED_LIST [AFX_EXPRESSION]
			-- Expressions that appear in the constraints and arguments of the last solving request.
			-- Sorted by the length of the expressions, from the longest to the shortest

feature{NONE} -- Implementation

	mathematica_program (a_method: STRING; a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION]): STRING
			-- Mathamatica program to solve `a_function' under constraints `a_constraints', with respect to `a_arguments' using `a_method'.
			-- `a_method' can be "Maximize" or "Minimize".
		local
			l_output: STRING
			l_cursor: CURSOR
		do
			create l_output.make (1024)
			l_output.append (a_method)
			l_output.append ("[{")
			l_output.append (expression_in_mathematica (a_function))
			l_output.append (", ")

				-- Construct linear constraints.
			l_cursor := a_constraints.cursor
			from
				a_constraints.start
			until
				a_constraints.after
			loop
				l_output.append (expression_in_mathematica (a_constraints.item_for_iteration))
				if a_constraints.index < a_constraints.count then
					l_output.append (once ", ")
				end
				a_constraints.forth
			end
			a_constraints.go_to (l_cursor)
			l_output.append (once "}, {")

				-- Construct arguments.
			l_cursor := a_arguments.cursor
			from
				a_arguments.start
			until
				a_arguments.after
			loop
				l_output.append (expression_in_mathematica (a_arguments.item_for_iteration))
				if a_arguments.index < a_arguments.count then
					l_output.append (once ", ")
				end
				a_arguments.forth
			end
			a_arguments.go_to (l_cursor)
			l_output.append (once "}")
			l_output.append (once "]%N")
			l_output.append (once "Exit[]%N")
			Result := l_output
		end

	parse_result (a_output: STRING; a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION])
			-- Parse Mathematica result in `a_output' and setup `last_solutions'.
		local
			l_output_parser: AFX_MATHEMATICA_CONSTRAINT_SOLVER_OUTPUT_PARSER
			l_solution: HASH_TABLE [TUPLE [argument_valuations: HASH_TABLE [STRING, STRING]; condition: STRING], STRING]
			l_value: STRING
			l_expr: AFX_AST_EXPRESSION
			l_conditions: LINKED_LIST [AFX_EXPRESSION]
			l_valuations: HASH_TABLE [AFX_EXPRESSION, AFX_EXPRESSION]
		do
			create last_solutions.make (2)
			if a_output.item (1) = '{' then
				create l_output_parser
				l_output_parser.parse (a_output)

				l_solution := l_output_parser.solution
				from
					l_solution.start
				until
					l_solution.after
				loop
					l_value := expression_in_eiffel (l_solution.key_for_iteration)
					create l_conditions.make
					create l_valuations.make (0)
					l_valuations.compare_objects
					if not l_value.has_substring ("infinity") then
						create l_expr.make_with_text (a_function.class_, a_function.feature_, l_value, a_function.written_class)
					end
					last_solutions.put ([l_conditions, l_valuations], l_expr)
					l_solution.forth
				end
			end
		end

	solve_internal (a_method: STRING; a_function: AFX_EXPRESSION; a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION])
			-- Solve `a_function' under constraints `a_constraints', with respect to `a_arguments' using `a_method'.
			-- `a_method' can be "Maximize" or "Minimize".
			-- Store results in `last_solutions'.
		local
			l_file_content: STRING
			l_output: STRING
			l_output_parser: AFX_MATHEMATICA_CONSTRAINT_SOLVER_OUTPUT_PARSER
			l_solution: HASH_TABLE [TUPLE [argument_valuations: HASH_TABLE [STRING, STRING]; condition: STRING], STRING]
			l_value: STRING
			l_expr: AFX_AST_EXPRESSION
			l_conditions: LINKED_LIST [AFX_EXPRESSION]
			l_valuations: HASH_TABLE [AFX_EXPRESSION, AFX_EXPRESSION]
		do
			ananlyze_constraints_and_arguments (a_constraints, a_arguments)

				-- Use Mathematica to solve the linear constraint problem.
			l_file_content := mathematica_program (a_method, a_function, a_constraints, a_arguments)
			create_mathematica_file (l_file_content)
			l_output := output_from_program_with_input_file (mathematica_command, Void, mathematica_file_path)
			l_output.replace_substring_all ("%R", "")
			l_output.replace_substring_all ("%N", "")
			l_output.left_adjust
			l_output.right_adjust

				-- Parse result from Mathematica and store result in `last_solutions'.
			create last_solutions.make (2)
			parse_result (l_output, a_function, a_constraints, a_arguments)
		end

	mathematica_command: STRING
			-- Command to launch Mathematica kernal to solve problem defined in `mathematica_file_name'
		do
			create Result.make (128)
			Result.append (mathematica_executable_path)
			Result.append (" -noprompt -run")
		end

	mathematica_executable_path: STRING
			-- Executable path of the Mathematica kernel
		do
			if {PLATFORM}.is_windows then
				Result := "math.exe"
			else
				Result := output_from_program ("/bin/sh -c %"which math%"", Void)
				Result.replace_substring_all ("%R", "")
				Result.replace_substring_all ("%N", "")
			end
		end

	expression_in_mathematica (a_expression: AFX_EXPRESSION): STRING
			-- String representation of `a_expression' in Mathematica format
		do
			create Result.make_from_string (a_expression.text)
			from
				expressions.start
			until
				expressions.after
			loop
				Result.replace_substring_all (expressions.item_for_iteration.text, name_expression_table.item (expressions.item_for_iteration))
				expressions.forth
			end
			Result.replace_substring_all (" and ", " && ")
			Result.replace_substring_all (" = ", " == ")
		end

	expression_in_eiffel (a_expression: STRING): STRING
			-- Expression (in Eiffel format) of `a_expression' which is in Mathematica format
		do
			create Result.make (a_expression.count * 2)
			Result.append (a_expression)
			Result.replace_substring_all (" && ", " and ")
			Result.replace_substring_all (" == ", " = ")
			from
				expression_name_table.start
			until
				expression_name_table.after
			loop
				Result.replace_substring_all (expression_name_table.key_for_iteration, expression_name_table.item_for_iteration.text)
				expression_name_table.forth
			end
		end

	ananlyze_constraints_and_arguments (a_constraints: LINKED_LIST [AFX_EXPRESSION]; a_arguments: LINKED_LIST [AFX_EXPRESSION])
			-- Ananlyze `a_constraints' and `a_arguments', and populate `expression_name_table', `name_expression_table' and
			-- `expressions'.
		local
			l_analyzer: AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER
			l_cursor: CURSOR
			l_merged_constraints: AFX_NUMERIC_CONSTRAINTS
			l_names: DS_HASH_SET [AFX_EXPRESSION]
			i: INTEGER
			l_expr_name: STRING
			l_sorter: DS_QUICK_SORTER [AFX_EXPRESSION]
		do
			create l_merged_constraints.make (Void)

				-- Analyze linear constraints to collect all relevant expressions.
			create l_analyzer
			l_cursor := a_constraints.cursor
			from
				a_constraints.start
			until
				a_constraints.after
			loop
				l_analyzer.analyze (a_constraints.item_for_iteration)
				check l_analyzer.is_matched end
				l_merged_constraints.merge (l_analyzer.constraints)
				a_constraints.forth
			end

				-- Construct simple names used in Mathematica for every Eiffel expression.
			create l_names.make (20)
			l_names.set_equality_tester (expression_equality_tester)
			l_merged_constraints.components.do_all (agent l_names.force_last)
			a_arguments.do_all (agent l_names.force_last)

			create expression_name_table.make (20)
			expression_name_table.compare_objects

			create name_expression_table.make (20)
			name_expression_table.compare_objects

			create expressions.make (l_names.count)

			from
				l_names.start
				i := 1
			until
				l_names.after
			loop
				l_expr_name := "var" + i.out
				expression_name_table.put (l_names.item_for_iteration, l_expr_name)
				name_expression_table.put (l_expr_name, l_names.item_for_iteration)
				expressions.force_last (l_names.item_for_iteration)
				i := i + 1
				l_names.forth
			end
			a_constraints.go_to (l_cursor)

				-- Sort `expressions' by the length of expressions, from longest to shortest.
			create l_sorter.make (
				create {AGENT_BASED_EQUALITY_TESTER [AFX_EXPRESSION]}.make (
					agent (a, b: AFX_EXPRESSION): BOOLEAN
						do
							Result := a.text.count > b.text.count
						end))
			l_sorter.sort (expressions)
		end

	create_mathematica_file (a_content: STRING)
			-- Create a file to store mathematica program `a_content'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (mathematica_file_path)
			l_file.put_string (a_content)
			l_file.close
		end

	mathematica_file_path: STRING
			-- File path to store Mathematica program for a linear constraint problem
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (config.data_directory)
			l_file_name.set_file_name ("linear_constraints.m")
			Result := l_file_name
		end
end
