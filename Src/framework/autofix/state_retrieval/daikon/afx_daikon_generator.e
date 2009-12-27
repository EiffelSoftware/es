note
	description: "Summary description for {AFX_DAIKON_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_GENERATOR
	create
		make


feature -- creator
	make is
		--
		do
			create daikon_state_list.make
		end

feature -- Declaration
	is_failing_tc : BOOLEAN
		-- is the test case a fail

	number_states:INTEGER is
			--
		do
			Result := daikon_state_list.count
		end

	restart is
			--
		do
			create daikon_state_list.make
		end


   	add_state (a_state: AFX_STATE; break_point: STRING; is_failing : BOOLEAN ) is
   			-- add traces for a breakpoint
   		local
   			daikon_state : AFX_DAIKON_STATE
   			name : STRING
   			a_daikon_declaration : AFX_DAIKON_DECLARATION
   			a_daikon_trace : AFX_DAIKON_TRACE
   		do
   			--CLASS_NAME.feature_name.bpslot:::POINT
   			is_failing_tc := is_failing
   			name := generate_state_name (a_state, break_point, is_failing)
   			create daikon_state.make (name,break_point)

   			from
				a_state.start
			until
				a_state.after
			loop
				create a_daikon_declaration.make (a_state.item_for_iteration)
				create a_daikon_trace.make (a_state.item_for_iteration)
				daikon_state.add_ordered_declaration (a_daikon_declaration)
				daikon_state.add_ordered_trace (a_daikon_trace)
				a_state.forth
			end

   			daikon_state_list.put_left  (daikon_state)

   		end

   	declarations : STRING is
   			-- print all declarations
   		do
   		   result := declaration_header
   		   from
   		   	  daikon_state_list.start
   		   until
   		   	  daikon_state_list.after
   		   loop


   		   	if daikon_state_list.isfirst then
   		   		--ENTER
   		   		result := result + "ppt " + daikon_state_list.item_for_iteration.name
   		   		result := result + first_state_definition
   		   		result := result + daikon_state_list.item_for_iteration.print_declaration
				result := result + "%N"

				--BPSLOT
				result := result + "ppt " + daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + "ppt-type point%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_declaration
				result := result + "%N"

   		   	elseif daikon_state_list.islast then
   		   		--BPSLOT
				result := result + "ppt " + daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + "ppt-type point%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_declaration
				result := result + "%N"

   		   		--EXIT
   		   		result := result + "ppt " + daikon_state_list.item_for_iteration.name
   		   		result := result + last_state_definition
   		   		result := result + daikon_state_list.item_for_iteration.print_declaration
				result := result + "%N"

   		   	else
   		   		--NORMAL
   		   		result := result + "ppt " + daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + "ppt-type point%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_declaration
				result := result + "%N"
   		   	end


   		   	  daikon_state_list.forth
   		   end

   		end

   	traces : STRING is
   			-- print all traces
   		do
   			result := ""
   		from
   		   	  daikon_state_list.start
   		   until
   		   	  daikon_state_list.after
   		   loop


   		   	  if daikon_state_list.isfirst then
   		   	  	--ENTER
   		   	  	result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::ENTER%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_trace
   		   	    result := result + "%N"

   		   	    --BPSLOT
   		   	    result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_trace
   		   	    result := result + "%N"

   		   	  elseif daikon_state_list.islast then
   		   	  	--BSLOT
   		   	  	result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_trace
   		   	    result := result + "%N"

   		   	    --EXIT
   		   	  	result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::EXIT1%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_trace
   		   	    result := result + "%N"

   		   	  else
   		   	  	result := result +  daikon_state_list.item_for_iteration.name
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + daikon_state_list.item_for_iteration.print_trace
   		   	    result := result + "%N"
   		   	  end



   		   	  daikon_state_list.forth
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


	generate_state_name (a_state: AFX_STATE ; break_point : STRING; is_failing : BOOLEAN) : STRING is
			-- generate the naming of a state
		do
			if (is_failing) then
				result := "F_"+a_state.class_.name + "." + a_state.feature_.feature_name+"()"
			else
				result := "P_"+a_state.class_.name + "." + a_state.feature_.feature_name+"()"
			end

		end


invariant
	invariant_clause: True -- Your invariant here

end
