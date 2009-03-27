indexing
	description:
		"[
			Old Handler which uses the `old' keyword.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_OLD_KEYWORD_HANDLER

inherit

	EP_OLD_HANDLER

feature -- Access

	old_heap_name: STRING
			-- <Precursor>
		do
			Result := "old(Heap)"
--			Result.append (expression_writer.name_mapper.heap_name)
--			Result.append (")")
		end

feature -- Processing

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		do
			check a_node.expr /= Void end
			expression_writer.expression.put ("old(")
			a_node.expr.process (expression_writer)
			expression_writer.expression.put (")")
		end

end
