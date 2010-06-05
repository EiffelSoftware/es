note
	description: "Summary description for {AFX_DAIKON_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_GENERATOR

inherit
	INTERNAL_COMPILER_STRING_EXPORTER
	
create
	make

feature -- creator
	make is
			--Initialize the list of states
		do
			create daikon_state_list.make
		end

feature -- Declaration
	is_failing_tc : BOOLEAN
		-- is the test case a fail

	number_states:INTEGER is
			-- Returns the number of states
		do
			Result := daikon_state_list.count
		end

	restart is
			-- Restart the list of states
		do
			create daikon_state_list.make
		end

   	add_state (a_skeleton: AFX_STATE_SKELETON; a_state: EPA_STATE; break_point: INTEGER; is_failing: BOOLEAN)
   			-- Add traces for a breakpoint
   			-- `a_skeleton' is the template for all possible variables/expressions.
   		local
   			daikon_state : AFX_DAIKON_STATE
   			name : STRING
   			a_daikon_declaration : AFX_DAIKON_DECLARATION
   			a_daikon_trace : AFX_DAIKON_TRACE
   			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
   			l_equation: detachable EPA_EQUATION
   			l_nonsensical_value: EPA_NONSENSICAL_VALUE
   		do
   			--CLASS_NAME.feature_name.bpslot:::POINT
   			is_failing_tc := is_failing
   			name := generate_state_name (a_state.class_, a_state.feature_, break_point, is_failing)
   			create daikon_state.make (name, break_point.out)
			create l_nonsensical_value
			from
				l_cursor := a_skeleton.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_equation := a_state.item_with_expression (l_cursor.item)
				if l_equation = Void then
					create l_equation.make (l_cursor.item, l_nonsensical_value)
				end

				create a_daikon_declaration.make (l_equation)
				create a_daikon_trace.make (l_equation)
				daikon_state.add_ordered_declaration (a_daikon_declaration)
				daikon_state.add_ordered_trace (a_daikon_trace)

				l_cursor.forth
			end

--   			from
--				a_state.start
--			until
--				a_state.after
--			loop
--				create a_daikon_declaration.make (a_state.item_for_iteration)
--				create a_daikon_trace.make (a_state.item_for_iteration)
--				daikon_state.add_ordered_declaration (a_daikon_declaration)
--				daikon_state.add_ordered_trace (a_daikon_trace)
--				a_state.forth
--			end

   			daikon_state_list.put_left  (daikon_state)

   		end

   	declarations : STRING is
   			-- print all declarations
   		do
		   create Result.make (1024 * 200)
   		   Result.append (declaration_header)
   		   from
   		   	  daikon_state_list.start
   		   until
   		   	  daikon_state_list.after
   		   loop


   		   	if daikon_state_list.isfirst then
   		   		--ENTER
   		   		Result.append (once "ppt ")
   		   		Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (first_state_definition)
   		   		Result.append (daikon_state_list.item_for_iteration.print_declaration)
				Result.append (once "%N")

				--BPSLOT
				Result.append (once "ppt ")
				Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (once ":::")
   		   		Result.append (daikon_state_list.item_for_iteration.break_point)
   		   		Result.append (once "%N")
   		   		Result.append (once "ppt-type point%N")
   		   		Result.append (daikon_state_list.item_for_iteration.print_declaration)
				Result.append (once "%N")

   		   	elseif daikon_state_list.islast then
   		   		--BPSLOT
				Result.append (once "ppt ")
				Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (once ":::")
   		   		Result.append (daikon_state_list.item_for_iteration.break_point)
   		   		Result.append (once "%N")
   		   		Result.append (once "ppt-type point%N")
   		   		Result.append (daikon_state_list.item_for_iteration.print_declaration)
				Result.append (once "%N")

   		   		--EXIT
   		   		Result.append (once "ppt ")
   		   		Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (last_state_definition)
   		   		Result.append (daikon_state_list.item_for_iteration.print_declaration)
				Result.append (once "%N")

   		   	else
   		   		--NORMAL
   		   		Result.append (once "ppt ")
   		   		Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (once ":::")
   		   		Result.append (daikon_state_list.item_for_iteration.break_point)
   		   		Result.append (once "%N")
   		   		Result.append (once "ppt-type point%N")
   		   		Result.append (daikon_state_list.item_for_iteration.print_declaration)
				Result.append (once "%N")
   		   	end

  		   	  daikon_state_list.forth
   		   end

   		end

   	traces : STRING is
   			-- print all traces
   		do
   			create Result.make (1024 * 100)
   		from
   		   	  daikon_state_list.start
   		   until
   		   	  daikon_state_list.after
   		   loop


   		   	  if daikon_state_list.isfirst then
   		   	  	--ENTER
   		   	  	Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (once ":::ENTER%N")
   		   		Result.append (daikon_state_list.item_for_iteration.trace_as_string)
   		   	    Result.append (once "%N")

   		   	    --BPSLOT
   		   	    Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (once ":::")
   		   		Result.append (daikon_state_list.item_for_iteration.break_point)
   		   		Result.append (once "%N")
   		   		Result.append (daikon_state_list.item_for_iteration.trace_as_string)
   		   	    Result.append (once "%N")

   		   	  elseif daikon_state_list.islast then
   		   	  	--BSLOT
   		   	  	Result.append (daikon_state_list.item_for_iteration.name)
   		   		Result.append (":::")
   		   		Result.append (daikon_state_list.item_for_iteration.break_point)
   		   		Result.append (once "%N")
   		   		Result.append (daikon_state_list.item_for_iteration.trace_as_string)
   		   	    Result.append ("%N")

   		   	    --EXIT
   		   	  	result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::EXIT1%N"
   		   		result := result + daikon_state_list.item_for_iteration.trace_as_string
   		   	    result := result + "%N"

   		   	  else
   		   	  	result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + daikon_state_list.item_for_iteration.trace_as_string
   		   	    result := result + "%N"
   		   	  end



   		   	  daikon_state_list.forth
   		   end

   		end

feature -- Access

	program_point_name (a_class: CLASS_C; a_feature: FEATURE_I; a_bpslot: INTEGER; a_enter: BOOLEAN; a_exit: BOOLEAN; a_failing: BOOLEAN): STRING
			-- Declaraction for a program point for break point slot `a_bpslot' for `a_feature'.
			-- `a_enter' and `a_exit' indicates if "ENTER" or "EXIT" is used in the declaraction.
			-- `a_failing' indicates whether the program point is used in passing test cases or failing test cases.
		do
			create Result.make (128)
			Result.append (once "ppt ")
			Result.append (generate_state_name (a_class, a_feature, a_bpslot, a_failing))
			if a_enter then
				Result.append (first_state_definition)
			elseif a_exit then
				Result.append (last_state_definition)
			else
   		   		Result.append (once ":::")
   		   		Result.append (a_bpslot.out)
   		   		Result.append (once "%N")
   		   		Result.append (once "ppt-type point%N")
			end
		end

	declaraction_for_skeleton (a_skeleton: AFX_STATE_SKELETON; a_class: CLASS_C; a_feature: FEATURE_I; a_failing: BOOLEAN): STRING
			-- String representing the Daikon variable declaraction for `a_skeleton' for `a_feature'
			-- If `a_failing' is True, the generated declaraction is for failing test cases,
			-- otherwise, for passing test casese.
		local
			i: INTEGER
			l_last_bpslot: INTEGER
			l_var_decs: LINKED_LIST [AFX_DAIKON_DECLARATION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_ppt_dec: STRING
			l_var_declaraction: STRING
			l_dec: AFX_DAIKON_DECLARATION
		do
				-- Collect variable declaractions for all expressions in `a_skeleton'.
			create l_var_decs.make
			create l_var_declaraction.make (2048)
			from
				l_cursor := a_skeleton.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_dec.make_with_expression (l_cursor.item)
				l_var_declaraction.append (l_dec.out)
				l_cursor.forth
			end

				-- Construct program point declaraction for all break point slots in `a_feature'.
			create Result.make (2048)

			Result.append (declaration_header)
			l_last_bpslot := a_feature.number_of_breakpoint_slots
			from
				i := 1
			until
				i > l_last_bpslot
			loop
				if i = 1 or i = l_last_bpslot then
					l_ppt_dec := program_point_name (a_class, a_feature, i, i = 1, i = l_last_bpslot, a_failing)
					Result.append (l_ppt_dec)
					Result.append (l_var_declaraction)
					Result.append ("%N")
				end

				l_ppt_dec := program_point_name (a_class, a_feature, i, False, False, a_failing)
				Result.append (l_ppt_dec)
				Result.append (l_var_declaraction)
				Result.append ("%N")
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	declaration_header :STRING is "decl-version 2.0%N%N"
		-- Declaration header

	first_state_definition : STRING is ":::ENTER%Nppt-type enter%N"
		-- The first state must be ENTER

	last_state_definition : STRING is ":::EXIT1%Nppt-type exit%N"
		-- The last state must be EXIT1

	daikon_state_list: LINKED_LIST [AFX_DAIKON_STATE]
		-- List of declarations for


	generate_state_name (a_class: CLASS_C; a_feature: FEATURE_I; break_point: INTEGER; is_failing: BOOLEAN): STRING is
			-- generate the naming of a state
		do
			if (is_failing) then
				result := "F_" + a_class.name + "." + a_feature.feature_name + "()"
			else
				result := "P_" + a_class.name + "." + a_feature.feature_name + "()"
			end

		end


invariant
	invariant_clause: True -- Your invariant here

end
