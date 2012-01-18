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

	EXT_HOLE_UTILITY
		export
			{NONE} all
		end

	EPA_UTILITY

	REFACTORING_HELPER

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
			l_ann_transformer: EXT_XML_FROM_ANN_TRANSFORMER
			l_xml_new_line: XML_CHARACTER_DATA
		do
				-- Create XML document.
			create Result.make

			l_xml_root_name := envelope_root_element

				-- Create and set XML root element.
			create l_xml_root_element.make (Void, l_xml_root_name, xml_ns_east_envelope)
			Result.set_root_element (l_xml_root_element)

				-- Attach Eiffel AST.
			l_xml_root_element.force_last (output.last_xml_document.root_element)

				-- Add newline.
			create l_xml_new_line.make_last (l_xml_root_element, "%N")

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

							-- Add newline.
						create l_xml_new_line.make_last (l_xml_root_element, "%N")

						l_annotation_set.forth
					end
				end
			end

			fixme ("Extend with holes from static and dynamic analysis.")
			fixme ("Holes need to provide the identifier they refer to.")
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


feature -- Processing

	process_expr_call_as (a_as: EXPR_CALL_AS)
			-- Replace expression call by hole.
		do
			if
				is_hole (a_as)
				and then attached get_hole_name (a_as) as l_hole_name
				and then attached snippet.holes.at (l_hole_name) as l_hole
			then
				output.xml_element_open  (expr_hole_element, xml_ns_east_hole)
				output.xml_add_unqualified_attribute ("name", l_hole_name)

				if attached l_hole.hole_type as l_hole_type then
					output.xml_add_unqualified_attribute ("type", l_hole_type)
				end

				output.xml_string_append (l_hole_name)
				output.xml_element_close (expr_hole_element, xml_ns_east_hole)
			else
				Precursor (a_as)
			end
		end

	process_instr_call_as (a_as: INSTR_CALL_AS)
			-- Replace instruction call by hole.
		do
			if
				is_hole (a_as)
				and then attached get_hole_name (a_as) as l_hole_name
				and then attached snippet.holes.at (l_hole_name) as l_hole
			then
				output.xml_element_open  (instruction_hole_element, xml_ns_east_hole)
				output.xml_add_unqualified_attribute ("name", l_hole_name)

				if attached l_hole.hole_type as l_hole_type then
					output.xml_add_unqualified_attribute ("type", l_hole_type)
				end

				output.xml_string_append (l_hole_name)
				output.xml_element_close (instruction_hole_element, xml_ns_east_hole)

					-- Insert newline.
				output.xml_string_append ("%N")
			else
				Precursor (a_as)
			end
		end

end
