note
	description: "Prints an Snippet as XML while depending purely on structure information (no matchlist needed)."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_FROM_SNIPPET_TRANSFORMER

inherit
	EXT_XML_FROM_AST_TRANSFORMER
		redefine
			xml_document,
			process_expr_call_as,
			process_instr_call_as
		end

	EPA_UTILITY

create
	make_from_snippet

feature {NONE} -- Creation

	make_from_snippet (a_snippet: EXT_SNIPPET)
		require
			a_snippet_not_void: attached a_snippet
		do
			make
			snippet := a_snippet.twin
		end

	snippet: EXT_SNIPPET
		-- The snippet to be transformed.

feature -- Access

	xml_document: XML_DOCUMENT
			-- XML document representing the traversed AST.
		local
			l_xml_root_element: XML_ELEMENT
			l_xml_root_name: STRING
--			l_xml_annotations_element: XML_ELEMENT
			l_ann_transformer: EXT_XML_FROM_ANN_TRANSFORMER
		do
				-- Create XML document.
			create Result.make

			l_xml_root_name := "envelope"

				-- Create and set XML root element.
			create l_xml_root_element.make (Void, l_xml_root_name, xml_ns_eimala_envelope)
			Result.set_root_element (l_xml_root_element)

				-- Attach Eiffel AST.
			l_xml_root_element.force_last (output.last_xml_document.root_element)

				-- Attach Hole Annotations.
			across
				snippet.holes as l_hole_iterator
			loop
				create l_ann_transformer

				if attached l_hole_iterator.item.annotations as l_annotation_set then
					from
						l_annotation_set.start
					until
						l_annotation_set.after
					loop
							-- Set id (= hole name)
						l_ann_transformer.set_reference_id (l_hole_iterator.key)
							-- Transform to XML and add to element.
						l_annotation_set.item_for_iteration.process (l_ann_transformer)
						l_xml_root_element.force_last (l_ann_transformer.last_xml)

						l_annotation_set.forth
					end
				end
			end

--				-- Attach Hole Annotations.
--			across
--				snippet.annotations as l_annotation_iterator
--			loop
--				create l_ann_transformer

--					-- Set id (= ???)
--				l_ann_transformer.set_reference_id ("???")
--					-- Transform to XML and add to element.
--				l_annotation_iterator.item.process (l_ann_transformer)
--				l_xml_root_element.force_last (l_ann_transformer.last_xml)
--			end
		end

feature {NONE} -- Hole Handling (Utiltiy)

	last_hole_name: detachable STRING

	is_hole (a_ast: AST_EIFFEL): BOOLEAN
			-- Checks if `a_ast' is an AST repressentation of an `{EXT_HOLE}'.
			-- In case it sets `last_hoel_name' to the first part before a space
			-- and by stripping away possible new line characters.			
		local
			l_ast_as_text: STRING
			l_ast_printer: ETR_AST_STRUCTURE_PRINTER
			l_ast_printer_output: ETR_AST_STRING_OUTPUT
		do
			create l_ast_printer_output.make_with_indentation_string ("%T")
			create l_ast_printer.make_with_output (l_ast_printer_output)

			l_ast_as_text := text_from_ast_with_printer (a_ast, l_ast_printer)

			if l_ast_as_text.starts_with ({EXT_HOLE}.hole_name_prefix) then
				Result := True
					-- Set `last_hole_name'.
				l_ast_as_text.replace_substring_all ("%N", " ")
				last_hole_name := l_ast_as_text.split (' ').at (1)
			end
		end

feature -- Processing

	process_expr_call_as (a_as: EXPR_CALL_AS)
		do
			if is_hole (a_as) then
				output.xml_element_open  ("exprHole", xml_ns_eimala_hole)
				output.xml_add_unqualified_attribute ("name", last_hole_name)
				output.xml_element_close ("exprHole", xml_ns_eimala_hole)
			else
				Precursor (a_as)
			end
		end

	process_instr_call_as (a_as: INSTR_CALL_AS)
		do
			if is_hole (a_as) then
				output.xml_element_open  ("instructionHole", xml_ns_eimala_hole)
				output.xml_add_unqualified_attribute ("name", last_hole_name)
				output.xml_element_close ("instructionHole", xml_ns_eimala_hole)
			else
				Precursor (a_as)
			end
		end

end
