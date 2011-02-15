note
	description: "Summary description for {AFX_DAIKON_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_RESULT

inherit
	AFX_DAIKON_VARIABLE_NAME_CODEC

create
	make_from_string

feature
	make_from_string (daikon_output :STRING; a_tc_info : EPA_TEST_CASE_INFO) is
			--Create a Daikon result from a Daikon output and a test case information
		do
			create daikon_table.make (1000)
			test_case_info := a_tc_info
			build_table(daikon_output)
		end

feature -- Access
	test_case_info: EPA_TEST_CASE_INFO

	daikon_table: HASH_TABLE[EPA_STATE , INTEGER]

feature {NONE} -- Implementation

     build_table (daikon_output : STRING) is
			--Parses the result of a Daikon File.
		local
			list_tokens :LIST[STRING]
			states : EPA_STATE
			equation : EPA_EQUATION
			current_key : INTEGER
			l_line: STRING
		do
			list_tokens := daikon_output.split ('%N')

			from
				list_tokens.start
			until
				list_tokens.after
			loop
				l_line := list_tokens.item_for_iteration

				if list_tokens.item_for_iteration.has_substring (":::") then
					current_key := state_name(list_tokens.item_for_iteration)
				end

				if l_line.has_substring (" == ") and then not l_line.has_substring ("orig(") then
					states.force_last (build_equation (list_tokens.item_for_iteration))
				end

				if list_tokens.item_for_iteration.has_substring ("========") then
					if states = void then -- First state
						create states.make (100, test_case_info.recipient_class_, test_case_info.recipient_)
					else
						-- Save old state and create a new one
					   daikon_table.put (states.cloned_object,current_key)
					   create states.make (100, test_case_info.recipient_class_, test_case_info.recipient_)
					end
				end

				list_tokens.forth
			end
			if states /= Void and then not daikon_table.has (current_key) then
				daikon_table.put (states.cloned_object, current_key)
			end
		end


     build_equation ( str :STRING ) :EPA_EQUATION is
     		--Takes a line output from Daikon and builds an AFX_Equation
		local
			l_index: INTEGER
			l_expression_str, l_value_str: STRING
			expression : EPA_AST_EXPRESSION
			expression_boolean_value : EPA_BOOLEAN_VALUE
			expression_integer_value : EPA_INTEGER_VALUE
			tokens :LIST[STRING]
			equation : EPA_EQUATION
			l_expr: STRING
     	do
--     		if not str.has_substring ("orig(") then
	     		l_index := str.substring_index ("==", 1)
	     		check only_separator: str.substring_index ("==", l_index) = 0 end

	     		l_expression_str := str.substring (1, l_index - 1)
--	      		if l_expression_str.has_substring ("orig(") then
--	     			l_expression_str.replace_substring_all ("orig(", "old(")
--	     		end
	     		create expression.make_with_text (test_case_info.recipient_class_, test_case_info.recipient_,  (l_expression_str), test_case_info.recipient_class_)

	     		l_value_str := str.substring (l_index + 2, str.count)
				l_value_str.left_adjust
				l_value_str.right_adjust
	     		if (l_value_str.is_boolean) then
	     			create expression_boolean_value.make (l_value_str.to_boolean)
	     			create equation.make (expression,expression_boolean_value)

	     		else
	     			create expression_integer_value.make (l_value_str.to_integer)
	     			create equation.make (expression,expression_integer_value)

	     		end

				result := equation
--     		end
     	end


     	state_name ( str :STRING ) :INTEGER is
     		-- Filter the state name ENTER and EXIT1
     		-- are considered special states.
		local
			tokens :LIST[STRING]
     	do
     		tokens := str.split (':')
     		if tokens.i_th (4).is_equal ("ENTER") then
     			result := -1
     		elseif tokens.i_th (4).is_equal ("EXIT1")  then
     			result := -2
     		else
     			result := tokens.i_th (4).to_integer
     		end
     	end


end
