note
	description: "A Daikon state is composed by a set of declarations and traces"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_STATE

create
	make

feature -- creation

	make (state_name: STRING; b_point: STRING)
			-- Create the state with a unique name.
		do
			create declaration_list.make
			create trace_list.make
			name := state_name
			break_point := b_point
		end

	add_ordered_declaration ( declaration : AFX_DAIKON_DECLARATION ) is
			-- 	add one declaration to the list of declarations
		do
			declaration_list.extend (declaration)
		end

	add_ordered_trace ( trace : AFX_DAIKON_TRACE ) is
			-- 	add one declaration to the list of declarations
		do
			trace_list.extend (trace)
		end

	print_declaration : STRING is
			-- return the state declaration
		do
			create Result.make (1024)
			from
				declaration_list.start
			until

				declaration_list.after
			loop
				Result.append (declaration_list.item_for_iteration.out)
				declaration_list.forth
			end
		end

	trace_as_string : STRING is
			-- return the state declaration
		do
			create Result.make (1024)
			from
				trace_list.start
			until

				trace_list.after
			loop
				Result.append (trace_list.item_for_iteration.out)
				trace_list.forth
			end

		end

feature --Access

    name : STRING
    	-- is the name of the state

    break_point :STRING
    	-- the break point number

feature {NONE} -- Implementation

	declaration_list : LINKED_LIST[AFX_DAIKON_DECLARATION]
		-- list of declarations

	trace_list : LINKED_LIST[AFX_DAIKON_TRACE]

invariant
	invariant_clause: True -- Your invariant here

end
