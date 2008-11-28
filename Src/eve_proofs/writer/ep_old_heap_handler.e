indexing
	description:
		"[
			Old handler which maps old expressions using a second heap.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_OLD_HEAP_HANDLER

inherit

	EP_OLD_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_old_heap_name: STRING)
			-- Initialize old handler with name of old heap as `a_old_heap_name'.
		do
			old_heap_name := a_old_heap_name
		ensure
			old_heap_name_set: old_heap_name.is_equal (a_old_heap_name)
		end

feature -- Access

	old_heap_name: STRING
			-- Name of old heap

feature -- Processing

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		local
			l_temp_heap: STRING
		do
			check a_node.expr /= Void end

			l_temp_heap := expression_writer.name_mapper.heap_name
			expression_writer.name_mapper.set_heap_name (old_heap_name)
			a_node.expr.process (expression_writer)
			expression_writer.name_mapper.set_heap_name (l_temp_heap)
		end

end
