note
	description: "Utilities of the graphx library"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EGX_UTILITY

feature -- Basic operations

	save_graph_to_dot_file (a_graph: EGX_GENERAL_GRAPH [HASHABLE, ANY]; a_path: STRING)
			-- Save `a_graph' into a file whose absolute path is specified with `a_path'.
			-- The file is in Dot format, and using all default `out' for nodes and labels.
		local
			l_printer: EGX_SIMPLE_DOT_GRAPH_PRINTER [HASHABLE, ANY]
			l_file: PLAIN_TEXT_FILE
		do
			create l_printer.make_default
			l_printer.print_graph (a_graph)

			create l_file.make_create_read_write (a_path)
			l_file.put_string (l_printer.last_printing)
			l_file.close
		end

end
