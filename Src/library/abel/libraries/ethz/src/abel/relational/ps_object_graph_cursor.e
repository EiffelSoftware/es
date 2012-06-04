note
	description: "A cursor for an object graph data structure. Can call an agent in case of cycle detection. Items might be iterated over twice."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_GRAPH_CURSOR
inherit
	ITERATION_CURSOR[PS_OBJECT_GRAPH_PART]
	PS_EIFFELSTORE_EXPORT
create
	make

feature -- Cursor status and movement

	item: PS_OBJECT_GRAPH_PART
		-- Item at current cursor position.
		do
			Result:= current_cursor.item
		end


	after:BOOLEAN
		-- Are there no more items to iterate over?
		do
			Result:= cursor_stack.is_empty and current_cursor.after
		end

	forth
		-- Move to next position
		do
			move
		end

	previous:PS_OBJECT_GRAPH_PART
		-- The previous item
		require
			not after and not is_at_root_object
		do
			Result:= object_graph_stack.item
		ensure
			not_item: Result /= item
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


	move
		-- Move to the next item
		require
			not_after: not after
			consistent: is_consistent
		do
			from step_in
			until is_consistent
			loop
				fix
			variant
				object_graph_stack.count
			end
		ensure
			consistent: is_consistent
		end

	step_in
		-- Do a step down the object graph
		require
			not object_graph_stack.has (item)
		do
			object_graph_stack.put (item)
			cursor_stack.put (current_cursor)
			current_cursor:= item.dependencies.new_cursor
		ensure
			object_graph_stack.has (old item)
		end

	step_out
		-- Do a step up the object graph
		do
			current_cursor:= cursor_stack.item
			object_graph_stack.remove
			cursor_stack.remove
		end


	fix
		do
--			print ("state: " +  current_cursor.after.out + object_graph_stack.count.out + "%N")
			if not current_cursor.after and then object_graph_stack.has (item) then
--				print ("calling removal feature%N")
				visited_handler.call ([previous, item])
			end
			step_out
			current_cursor.forth
		end


	is_consistent: BOOLEAN
		do
			Result:= True
			if after then
				Result:= True
			elseif current_cursor.after then
				Result:= False
			elseif object_graph_stack.has (item) then
				Result:= False
			else
				Result:= True
			end

		end


feature {NONE} -- Implementation

	object_graph_stack:LINKED_STACK[ PS_OBJECT_GRAPH_PART]
	cursor_stack: LINKED_STACK[ INDEXABLE_ITERATION_CURSOR[PS_OBJECT_GRAPH_PART]]

	current_cursor: INDEXABLE_ITERATION_CURSOR[PS_OBJECT_GRAPH_PART]

	root: LINKED_LIST[PS_OBJECT_GRAPH_PART]


feature {NONE} -- Initialization

	make (graph:PS_OBJECT_GRAPH_PART)
		do
			create root.make
			root.extend (graph)
			current_cursor:= root.new_cursor

			create object_graph_stack.make
			create cursor_stack.make
			visited_handler:= agent default_handler
		end


invariant
	previous_dependant: not (after or is_at_root_object) implies previous.dependencies.has (item)
	current_cursor_not_in_stack: not cursor_stack.has (current_cursor)
	single_root: root.count = 1

end
