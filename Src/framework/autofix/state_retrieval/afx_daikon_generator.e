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

   	add_state (a_state: AFX_STATE; break_point: STRING) is
   			-- add traces for a breakpoint
   		local
   			daikon_state : AFX_DAIKON_STATE
   			name : STRING
   			a_daikon_declaration : AFX_DAIKON_DECLARATION
   			a_daikon_trace : AFX_DAIKON_TRACE
   		do
   			--CLASS_NAME.feature_name.bpslot:::POINT
   			name := generate_state_name (a_state, break_point)
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

   			daikon_state_list.put_right  (daikon_state)

   		end

   	print_declarations : STRING is
   			-- print all declarations
   		do
   		   result := declaration_header
   		   from
   		   	  daikon_state_list.start
   		   until
   		   	  daikon_state_list.after
   		   loop
   		   	result := result + "ppt " + daikon_state_list.item_for_iteration.name

   		   	if daikon_state_list.isfirst then
   		   		result := result + first_state_definition
   		   	elseif daikon_state_list.islast then
   		   		result := result + last_state_definition
   		   	else
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + "ppt-type point%N"
   		   	end

   		   	result := result + daikon_state_list.item_for_iteration.print_declaration

			  result := result + "%N"
   		   	  daikon_state_list.forth
   		   end

   		end

   	print_trace : STRING is
   			-- print all traces
   		do
   			result := ""
   		from
   		   	  daikon_state_list.start
   		   until
   		   	  daikon_state_list.after
   		   loop
   		      result := result +  daikon_state_list.item_for_iteration.name

   		   	  if daikon_state_list.isfirst then
   		   		result := result + ":::ENTER%N"
   		   	  elseif daikon_state_list.islast then
   		   		result := result + ":::EXIT1%N"
   		   	  else
   		   		result := result + ":::" + daikon_state_list.item_for_iteration.break_point + "%N"
   		   		result := result + "ppt-type point%N"
   		   	  end

   		   	  result := result + daikon_state_list.item_for_iteration.print_trace
   		   	  result := result + "%N"
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


	generate_state_name (a_state: AFX_STATE ; break_point : STRING) : STRING is
			-- generate the naming of a state
		do
			result := a_state.class_.name + "." + a_state.feature_.feature_name+ "()"
		end


invariant
	invariant_clause: True -- Your invariant here

end
