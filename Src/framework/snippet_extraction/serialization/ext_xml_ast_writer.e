note
	description: "Serializes an AST to a medium / file in XML format."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_AST_WRITER

inherit
	EXT_AST_NODE_CONSTANTS

	REFACTORING_HELPER

feature -- Basic operations

	write (a_ast: AST_EIFFEL ; a_medium: IO_MEDIUM)
			-- Write `a_ast' into `a_medium'.
		local
			l_formatter: XML_FORMATTER
			l_transformer: EXT_XML_FROM_AST_TRANSFORMER
		do
			if attached {FILE} a_medium as l_file then
				create l_transformer.make
				a_ast.process (l_transformer)

				create l_formatter.make
				l_formatter.set_output_file (l_file)
				l_formatter.process_document (l_transformer.xml_document)
			end
		end

	write_to_file (a_ast: AST_EIFFEL; a_path: STRING)
			-- Write each of `a_ast' to a file whose absolute path is given by `a_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			write (a_ast, l_file)
			l_file.close
		end

end
