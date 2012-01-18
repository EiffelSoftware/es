note
	description: "Generates an XML Schema definition out of `{EXT_XSD_RECORD}' configuration items."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_GENERATOR

inherit
	EXT_XML_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization that initializes an empty XML Schema definition.
		local
			l_xml_root_element: XML_ELEMENT
			l_xml_pi_version: XML_PROCESSING_INSTRUCTION
		do
			create xml_document.make

			create l_xml_pi_version.make (Void, "xml", "version=%"1.0%" encoding=%"UTF-8%"")
			xml_document.force_last (l_xml_pi_version)

			create l_xml_root_element.make (Void, "schema", xml_ns_xsd)
			l_xml_root_element.add_unqualified_attribute ("elementFormDefault", "qualified")
			l_xml_root_element.add_unqualified_attribute ("xmlns", xml_ns_east_core.uri)
			l_xml_root_element.add_unqualified_attribute ("targetNamespace", xml_ns_east_core.uri)

			xml_document.set_root_element (l_xml_root_element)
		end

feature -- Access

	process (a_record_list: SORTED_LIST [EXT_EAST_RECORD])
			-- Process the configuration `a_record_list' and synthesizes
			-- an XML Schema document that is accessible through `last_xml_document'.
		local
			l_xml_new_line: XML_CHARACTER_DATA
		do
				-- Adds a new line to the output.
			create l_xml_new_line.make_last (xml_document.root_element, "%N")

			create l_xml_new_line.make_last (xml_document.root_element, "%N")
			add_last_xml_element_eiffel (xml_document.root_element)
			create l_xml_new_line.make_last (xml_document.root_element, "%N")

			across a_record_list as l_cursor loop
				create l_xml_new_line.make_last (xml_document.root_element, "%N")
				l_cursor.item.process_with_parent (xml_document.root_element)
				create l_xml_new_line.make_last (xml_document.root_element, "%N")
			end

			create l_xml_new_line.make_last (xml_document.root_element, "%N")
		end

	last_xml_document: XML_DOCUMENT
			-- A copy of the last created document.
		do
			Result := xml_document.twin
		end

feature {NONE} -- Implementation

	xml_document: XML_DOCUMENT
			-- XML document representing the traversed AST.

	add_last_xml_element_eiffel (a_parent: XML_ELEMENT)
			-- Create an XML element to capture any Eiffel AST.
		local
			l_xml_eiffel, l_xml_complex_type, l_xml_sequence, l_xml_any: XML_ELEMENT
		do
			create l_xml_eiffel.make_last (a_parent, "element", xml_ns_xsd)
			l_xml_eiffel.add_unqualified_attribute ("name", "eiffel")

			create l_xml_complex_type.make_last (l_xml_eiffel, "complexType", xml_ns_xsd)
			l_xml_complex_type.add_unqualified_attribute ("mixed", "true")

			create l_xml_sequence.make_last (l_xml_complex_type, "sequence", xml_ns_xsd)
			l_xml_sequence.add_unqualified_attribute ("minOccurs", "0")
			l_xml_sequence.add_unqualified_attribute ("maxOccurs", "unbounded")

			create l_xml_any.make_last (l_xml_sequence, "any", xml_ns_xsd)
			l_xml_any.add_unqualified_attribute ("namespace", xml_ns_east_core.uri)
		end

end
