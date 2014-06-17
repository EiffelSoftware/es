note
	description: "Hinter single class processor."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_CLASS_PROCESSOR

inherit

	SHARED_SERVER

create
	make_with_options

feature -- Interface

	process_class (a_class: CLASS_C; a_output_file: PLAIN_TEXT_FILE)
			-- Process `a_class', write output to  `a_output_file'.
		require
			file_open_and_writable: a_output_file.is_writable
		local
			l_ast_iterator: AT_HINTER_AST_ITERATOR
			l_text: STRING_8
		do
			create l_ast_iterator.make_with_options (options)
			l_ast_iterator.setup (a_class.ast, match_list_server.item (a_class.class_id), true, true)
			l_ast_iterator.process_ast_node (a_class.ast)
			l_text := l_ast_iterator.text
			l_text.prune_all ('%R')
			a_output_file.put_string (l_text)
			io.put_string (l_text)
		end

feature {NONE} -- Implementation

	make_with_options (a_options: AT_OPTIONS)
			-- Initialization
		do
			options := a_options
		end

	options: AT_OPTIONS
			-- The current AutoTeach options.

end
