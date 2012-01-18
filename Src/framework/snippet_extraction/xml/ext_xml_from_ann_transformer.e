note
	description: "Serializes an descendants of `{ANN_ANNOTATION}' to XML."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_FROM_ANN_TRANSFORMER

inherit
	ANN_VISITOR

	EXT_XML_CONSTANTS

feature -- Access

	reference_id: STRING
		assign set_reference_id
			-- Identifier of XML element, the annotations refer to.

	set_reference_id (a_id: STRING)
			-- Set `reference_id'.
		require
			a_aid_not_void: attached a_id
		do
			reference_id := a_id
		end

	last_xml: detachable XML_ELEMENT
			-- XML element created by last called process_* routine.

feature -- XML Constants

	element_name_mention_annotation: STRING = "mention_annotation"
			-- XML name constant of mention annotation.

feature -- Processors

	process_mention_annotation (a_ann: ANN_MENTION_ANNOTATION)
			-- Process `a_ann'.
		require else
			reference_id_not_void: attached reference_id
		local
			l_element: XML_ELEMENT
			l_expr: XML_ELEMENT
			l_expr_string: XML_CHARACTER_DATA
		do
			create l_element.make (Void, element_name_mention_annotation, xml_ns_east_annotation)
			l_element.add_unqualified_attribute ("references_to", reference_id)

			if a_ann.is_conditional then
				l_element.add_unqualified_attribute ("conditional", "true")
			end

				-- Add AST of `expression' in XML format.
			transformer.reset
			transformer.transform (a_ann.ast_of_expression)

			if not transformer.xml_document.root_element.elements.is_empty then
				l_expr := transformer.xml_document.root_element.elements.first
				l_expr.set_parent (l_element)
				l_element.force_last (l_expr)

				last_xml := l_element
			else
					-- Add textual representation.
				last_xml := l_element
				create l_expr_string.make_last (last_xml, a_ann.expression)
			end
		end

	process_sequence_annotation (a_ann: ANN_SEQUENCE_ANNOTATION)
			-- Unused.
		require else
			reference_id_not_void: attached reference_id
		do
		end

	process_state_annotation (a_ann: ANN_STATE_ANNOTATION)
			-- Unused.
		require else
			reference_id_not_void: attached reference_id
		do
		end

feature {NONE} -- Implementation

	transformer: EXT_XML_FROM_AST_TRANSFORMER
			-- Transformer that creates XML out of ASTs.
		once
			create Result.make
		end

end
