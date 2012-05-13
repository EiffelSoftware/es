note
	description: "A cursor for an object graph data structure. Can call an agent in case of cycle detection. Items might be iterated over twice."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_GRAPH_CURSOR
inherit
	ITERATION_CURSOR[PS_OBJECT_GRAPH_PART]

create
	make

feature -- Cursor status and movement

	item: PS_OBJECT_GRAPH_PART
		-- Item at current cursor position.


	after:BOOLEAN
		-- Are there no more items to iterate over?

	forth
		-- Move to next position
		do
			-- do a depth first search - first follow dependencies
			if not current_cursor.after then
				step_in
				if object_graph_stack.has (item) then
					-- found an already visited item
					visited_handler.call ([previous, item])
					retreat
				end
			else
				-- we have reached the end of the dependency list - time to retreat
				if not is_at_root_object then
					retreat
				else
					after:= True
				end
			end
		end

	previous:PS_OBJECT_GRAPH_PART
		-- The previous item
		require
			not after and not is_at_root_object
		do
			Result:= object_graph_stack.item
		end

	is_at_root_object:BOOLEAN
		-- Is the cursor currently pointing at the root object?
		do
			Result:= object_graph_stack.is_empty and not after
		end



feature -- Visited item handler function

	visited_handler: PROCEDURE [ANY, TUPLE[PS_OBJECT_GRAPH_PART, PS_OBJECT_GRAPH_PART]]
		-- A handler function in case an already visited item is found. In that case, `item' is the object that was found twice

	set_handler (a_handler: PROCEDURE  [ANY, TUPLE[PS_OBJECT_GRAPH_PART, PS_OBJECT_GRAPH_PART]])
		do
			visited_handler:= a_handler
		end


	default_handler (parent, visited_item:PS_OBJECT_GRAPH_PART)
		do
		end


feature {NONE} -- Implementation

	retreat
		-- Retreat from current item - we either reached an end or the object was already visited
		do
			step_out
			current_cursor.forth
			-- check if we've reached the end - else call Current.forth again as we need to step in if there's a new item, or step out again if we've already reached the end of the list
			if not object_graph_stack.is_empty and current_cursor.after then
				Current.forth
			else
				after:=True
			end

		end


	step_in
		-- Do a step down the object graph
		do
			object_graph_stack.put (item)
			cursor_stack.put (current_cursor)
			item:= current_cursor.item
			current_cursor:= item.new_cursor
		end

	step_out
		-- Do a step up the object graph
		do
			item:= object_graph_stack.item
			current_cursor:= cursor_stack.item
			object_graph_stack.remove
			cursor_stack.remove
		end


feature {NONE} -- Implementation

	object_graph_stack:LINKED_STACK[ PS_OBJECT_GRAPH_PART]
	cursor_stack: LINKED_STACK[ ITERATION_CURSOR[PS_OBJECT_GRAPH_PART]]

	current_cursor: ITERATION_CURSOR[PS_OBJECT_GRAPH_PART]


feature {NONE} -- Initialization

	make (graph:PS_OBJECT_GRAPH_PART)
		do
			item:=graph
			create object_graph_stack.make
			create cursor_stack.make
			current_cursor:= item.dependencies.new_cursor
			visited_handler:= agent default_handler
		end




end
