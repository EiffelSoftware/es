note
	description: "Configuaration record to synthesize local elements in the Eiffel AST XML Schema definition."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_LOCAL_RECORD

inherit
	EXT_XSD_LOCAL_RECORD

	EXT_XML_CONSTANTS

	EXT_AST_NODE_TO_XML_MAPPING

create
	make_from_argument_list

feature {NONE} -- Initialization

	make_from_argument_list (a_parent_node: STRING; a_processing_id: INTEGER; a_element_name, a_element_node: STRING; a_optional: BOOLEAN)
			-- Initialization arguments to fill local record template.
		do
			parent_node		:= a_parent_node
			processing_id	:= a_processing_id
			element_name	:= a_element_name
			element_node	:= a_element_node
			optional		:= a_optional
				-- Default.
			mixed			:= True
		end

feature -- Access

	processing_id: INTEGER
		-- Branch ID originating from `{ETR_AST_STRUCTURE_PRINTER}'.

	element_name: STRING
		-- Value for the 1st local element's "name" attribute.		

	element_node: STRING
		-- Value for the 2nd local element's "name" attribute.

	optional: detachable BOOLEAN
		-- Is the local element optional?

	mixed: detachable BOOLEAN
		-- Does the local element support mixed content?

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML element and add is content to `a_parent'.
		do
			if output_local_elements then
					-- Output local element that includes group the reference.
				if attached as_xsd_local_element as l_item then
					l_item.set_parent (a_parent)
					a_parent.put_last (l_item)
				end
			else
					-- Output group reference without surrounding local element.
				if attached as_xsd_group_reference as l_item then
					l_item.set_parent (a_parent)
					a_parent.put_last (l_item)
				end
			end
		end

feature -- DEBUG OUTPUT

	debug_output: STRING
			-- String representation.
		do
			create Result.make_empty
			Result.append_integer (processing_id)
			Result.append (" = ")
			Result.append (element_name)
			Result.append (" [ from ")
			Result.append (parent_node)
			Result.append ("]")
		end


feature {NONE} -- Implementation

	output_local_elements: BOOLEAN = True
			-- Should local elements added?

	xml_element_name: like element_name
			-- Generate "name" attribute for local element definition.
		do
			Result := element_name
		end

	xml_element_group_name: like element_node
			-- Generate name to reference the group definition.
			-- `ast_node_to_xml_group_type' to rename `element_name'.		
		do
			Result := ast_node_to_xml_tag_group (element_node)
		end

	as_xsd_local_element: XML_ELEMENT
			-- Process `Current' as XML element.
		local
			l_xml_sequence, l_xml_element, l_xml_complex_type, l_xml_group: XML_ELEMENT
		do
			if attached optional as l_optional and then l_optional then
				create l_xml_sequence.make (Void, "sequence", xml_ns_xsd)
				l_xml_sequence.add_unqualified_attribute ("minOccurs", "0")
			end

			if attached l_xml_sequence then
				create l_xml_element.make_last (l_xml_sequence, "element", xml_ns_xsd)
				Result := l_xml_sequence
			else
				create l_xml_element.make (Void, "element", xml_ns_xsd)
				Result := l_xml_element
			end
			l_xml_element.add_unqualified_attribute ("name", xml_element_name)

			create l_xml_complex_type.make_last (l_xml_element, "complexType", xml_ns_xsd)

			if attached mixed as l_mixed and then l_mixed then
				l_xml_complex_type.add_unqualified_attribute ("mixed", "true")
			end

			create l_xml_group.make_last (l_xml_complex_type, "group", xml_ns_xsd)
			l_xml_group.add_unqualified_attribute ("ref", xml_element_group_name)
		end

	as_xsd_group_reference: XML_ELEMENT
			-- Process `Current' as XML element.
		local
			l_xml_sequence, l_xml_element, l_xml_complex_type, l_xml_group: XML_ELEMENT
		do
			create l_xml_group.make (Void, "group", xml_ns_xsd)
			l_xml_group.add_unqualified_attribute ("ref", xml_element_group_name)

			if attached optional as l_optional and then l_optional then
				l_xml_group.add_unqualified_attribute ("minOccurs", "0")
			end

			Result := l_xml_group
		end

end
