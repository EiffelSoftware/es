indexing
	description:
		"[
			Base class for `old' expressions handler.
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class EP_OLD_HANDLER

feature -- Access

	expression_writer: EP_EXPRESSION_WRITER
			-- Expression writer used to process old expressions

feature -- Element change

	set_expression_writer (a_expression_writer: EP_EXPRESSION_WRITER)
			-- Set `expression_writer' to `a_expression_writer'.
		require
			a_expression_writer_not_void: a_expression_writer /= Void
		do
			expression_writer := a_expression_writer
		ensure
			expression_writer_set: expression_writer = a_expression_writer
		end

feature -- Processing

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		require
			a_node_not_void: a_node /= Void
			expression_writer_set: expression_writer /= Void
		deferred
		end

end
