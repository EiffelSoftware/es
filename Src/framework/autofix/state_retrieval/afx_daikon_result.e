note
	description: "Summary description for {AFX_DAIKON_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_RESULT

	create
		make_from_string

feature
	make_from_string (daikon_output :STRING; a_tc_info : AFX_TEST_CASE_INFO) is
			--
		do
			create daikon_table.make (1000)
			test_case_info := a_tc_info
			build_table(daikon_output)
		end

feature -- Access
test_case_info: AFX_TEST_CASE_INFO

daikon_table: HASH_TABLE[AFX_STATE , INTEGER]

feature {NONE} -- Implementation

     build_table (daikon_output : STRING) is
			--
		local
			list_tokens :LIST[STRING]
			states : AFX_STATE
			equation : AFX_EQUATION
			current_key : INTEGER
		do
			list_tokens := daikon_output.split ('%N')

			from
				list_tokens.start
			until
				list_tokens.after
			loop
				if list_tokens.item_for_iteration.has_substring (":::") then
					current_key := state_name(list_tokens.item_for_iteration)
				end

				if list_tokens.item_for_iteration.has_substring (" == ") then
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

		end


     build_equation ( str :STRING ) :AFX_EQUATION is
     		--
		local
			expression : AFX_AST_EXPRESSION
			expression_boolean_value : AFX_BOOLEAN_VALUE
			expression_integer_value : AFX_INTEGER_VALUE
			tokens :LIST[STRING]
			equation : AFX_EQUATION
     	do
     		tokens := str.split ('=')
     		create expression.make_with_text (test_case_info.recipient_class_, test_case_info.recipient_,tokens.i_th (1), test_case_info.recipient_class_)

			tokens.i_th (3).left_adjust
			tokens.i_th (3).right_adjust
     		if (tokens.i_th (3).is_boolean) then
     			create expression_boolean_value.make (tokens.i_th (3).to_boolean)
     			create equation.make (expression,expression_boolean_value)

     		else
     			create expression_integer_value.make (tokens.i_th (3).to_integer)
     			create equation.make (expression,expression_integer_value)

     		end

			result := equation

     	end


     	state_name ( str :STRING ) :INTEGER is
     		--

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
